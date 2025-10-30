//
//  Repository.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation


protocol HPayRepository {
    func getWallet() async throws -> Wallet
    func topUp(amount: Decimal) async throws -> Wallet
    func getCards() async throws -> [Card]
    func createCard(brand: String, last4: String, expMonth: Int, expYear: Int) async throws -> Card
    func removeCard(id: UUID) async throws
    func getTransactions() async throws -> [Transactions]
    var userId: Int { get }
    func credit(amountSar: Decimal) async throws -> Wallet
}


final class HPayRepositoryCla: HPayRepository {
    private let repo: HPayRepository
    init(repo: HPayRepository) { self.repo = repo }
    
    let baseURL = URL(string: "https://hpaymini-stripe-backend-1.onrender.com")!
    let userId: Int = 1
    @Published var errorMessage: String?
    
    func getWallet() async throws -> Wallet {
        let url = baseURL.appendingPathComponent("wallet")
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.queryItems = [.init(name: "userId", value: "1")]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let bal = (json["balance"] as? Double) ?? 0
        return Wallet(balance: Decimal(bal))
    }
    func topUp(amount: Decimal) async throws -> Wallet {
        var req = URLRequest(url: baseURL.appendingPathComponent("top-up"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "userId": 1,
            "amount": NSDecimalNumber(decimal: amount)
        ])
        
        let (data, _) = try await URLSession.shared.data(for: req)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        // If backend returns { "balance": 150 }
        let newBalance = json["balance"] as? Double ?? 0
        return Wallet(balance: Decimal(newBalance))
    }
    func credit(amountSar: Decimal) async throws -> Wallet {
        var req = URLRequest(url: baseURL.appendingPathComponent("wallet/refund"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "userId": 1,
            "amountSar": (amountSar as NSDecimalNumber).doubleValue
        ])
        let (data, _) = try await URLSession.shared.data(for: req)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let bal = (json["balance"] as? Double) ?? 0
        return Wallet(balance: Decimal(bal))
    }
    func getCards() async throws -> [Card] { try await repo.getCards() }
    func createCard(brand: String, last4: String, expMonth: Int, expYear: Int) async throws -> Card {
        try await repo.createCard(brand: brand, last4: last4, expMonth: expMonth, expYear: expYear)
    }
    func removeCard(id: UUID) async throws { try await repo.removeCard(id: id) }
    func getTransactions() async throws -> [Transactions] { try await repo.getTransactions() }
}





