//
//  API.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation

struct APIError: Error, LocalizedError {
    let message: String
    var errorDescription: String? { message }
}


final class MockHPayAPI: HPayRepository {
        private let latency: Duration
        private let errorRate: Double
    var userId: Int
        private var wallet = Wallet(balance: 104.90)
        private var cards: [Card] = [
            Card(id: UUID(), brand: "Visa", last4: "4242", expMonth: 12, expYear: 2027),
            Card(id: UUID(), brand: "Mastercard", last4: "4444", expMonth: 5, expYear: 2026)
        ]
        private var txs: [Transactions] = [
            Transactions(id: UUID(), type: .topUp, amount: 4.90, createdAt: Date().addingTimeInterval(-3600*6), status: .succeeded, name: "بندة", image: "banda"),
            Transactions(id: UUID(), type: .payment, amount: 100.00, createdAt: Date().addingTimeInterval(-3600*24), status: .succeeded, name: "بندة", image: "banda")
        ]
        init(userId: Int = 1,latency: Duration = .milliseconds(600), errorRate: Double = 0.1) {
            self.latency = latency
            self.errorRate = errorRate
            self.userId = userId
        }
    
        private func maybeFail() throws {
            if Double.random(in: 0...1) < errorRate {
                throw APIError(message: "Network error. Please try again.")
            }
        }
        
       
        
        
        func getWallet() async throws -> Wallet {
            
                        return wallet
        }
        
        func topUp(amount: Decimal) async throws -> Wallet {
            
            try maybeFail()
            wallet.balance += amount
            txs.insert(Transactions(id: UUID(), type: .topUp, amount: amount, createdAt: Date(), status: .succeeded, name: "إضافة رصيد", image: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"), at: 0)
            return wallet
        }
        
        func getCards() async throws -> [Card] {
            try await Task.sleep(for: latency)
            try maybeFail()
            return cards
        }
        
        func createCard(brand: String, last4: String, expMonth: Int, expYear: Int) async throws -> Card {
            try await Task.sleep(for: latency)
            try maybeFail()
            let card = Card(id: UUID(), brand: brand, last4: last4, expMonth: expMonth, expYear: expYear)
            cards.append(card)
            return card
        }
        
        func removeCard(id: UUID) async throws {
            try await Task.sleep(for: latency)
            try maybeFail()
            cards.removeAll { $0.id == id }
        }
        
        func getTransactions() async throws -> [Transactions] {
            try await Task.sleep(for: latency)
           
            return txs.sorted { $0.createdAt > $1.createdAt }
        }
        
       
        
        func credit(amountSar: Decimal) async throws -> Wallet {
        
            wallet.balance += amountSar
            txs.insert(Transactions(id: UUID(), type: .topUp, amount: amountSar, createdAt: Date(), status: .succeeded, name: "إضافة رصيد", image: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90"), at: 0)
            return wallet
        }
        
       
        
        
     
    }

