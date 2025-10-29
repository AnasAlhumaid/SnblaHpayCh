//
//  TransactionsView.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


struct TransactionsView: View {
    let repo: HPayRepository
    @StateObject private var vm: TransactionsViewModel
    
    
    init(repo: HPayRepository) {
        self.repo = repo
        _vm = StateObject(wrappedValue: TransactionsViewModel(repo: repo))
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errors {
                    Text(error).foregroundStyle(.red)
                } else {
                    List(vm.txs) { tx in
                        HStack {
                            Image(systemName: icon(for: tx))
                            VStack(alignment: .leading) {
                                Text(title(for: tx))
                                Text(DateFormatter.tx.string(from: tx.createdAt))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(Money.format(tx.amount))
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .navigationTitle("Activity")
            .task { await vm.load() }
        }
    }
    
    
    private func icon(for tx: Transactions) -> String {
        switch tx.type { case .topUp: return "arrow.down.circle"; case .payment: return "arrow.up.circle"; case .refund: return "arrow.uturn.backward.circle" }
    }
    private func title(for tx: Transactions) -> String {
        switch tx.type { case .topUp: return "Top‑Up"; case .payment: return "Payment"; case .refund: return "Refund" }
    }
}
