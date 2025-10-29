//
//  AddCashViewModel.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation


@MainActor
final class AddCashViewModel: ObservableObject {
    
    enum State: Equatable {
        case idle, loading, success(String), error(String)
    }

    @Published var amountText = ""
    @Published var state: State = .idle
    @Published var requestDismiss = false
    private let repo: HPayRepository
    private let payment: PaymentServiceType

    init(repo: HPayRepository, payment: PaymentServiceType) {
        self.repo = repo
        self.payment = payment
    }

    // MARK: - Validation
    var isValidAmount: Bool {
        let normalized = normalizeArabicDigits(amountText).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty,
              normalized.first != ".",
              let dec = Decimal(string: normalized)
        else { return false }

        // no more than 2 fraction digits
        if fractionDigits(of: normalized) > 2 { return false }

        // minimum 1 SAR
        return dec >= 1
    }

    private func fractionDigits(of s: String) -> Int {
        guard let dot = s.firstIndex(of: ".") else { return 0 }
        return s.distance(from: s.index(after: dot), to: s.endIndex)
    }

    /// Convert Arabic-Indic digits to ASCII so Decimal(string:) can parse
    private func normalizeArabicDigits(_ s: String) -> String {
        var out = ""
        out.reserveCapacity(s.count)
        for ch in s {
            if let scalar = ch.unicodeScalars.first {
                switch scalar.value {
                // Arabic-Indic ٠١٢٣٤٥٦٧٨٩
                case 0x0660...0x0669:
                    let val = Int(scalar.value - 0x0660)
                    out.append(String(val))
                // Eastern Arabic-Indic ۰۱۲۳۴۵۶۷۸۹
                case 0x06F0...0x06F9:
                    let val = Int(scalar.value - 0x06F0)
                    out.append(String(val))
                default:
                    out.append(ch)
                }
            } else {
                out.append(ch)
            }
        }
        return out
    }

    // MARK: - Action
    func confirmTopUp() async {
        guard isValidAmount, let amount = Decimal(string: amountText) else { return }
      
        state = .loading
        do {
            
            let clientSecret = try await payment.createTopUpIntent(userId: repo.userId, amountSar: amount)
           

            try await payment.presentPaymentSheet(clientSecret: clientSecret)

            let wallet = try await repo.credit(amountSar: amount)


            state = .success("الرصيد الجديد: \(Money.format(wallet.balance)) ر.س")
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}


