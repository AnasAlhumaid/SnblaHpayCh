//
//  Models.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation


struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    var brand: String
    var last4: String
    var expMonth: Int
    var expYear: Int
}


enum TransactionType: String, Codable { case topUp, payment, refund }


enum TransactionStatus: String, Codable { case pending, succeeded, failed }


struct Transactions: Identifiable, Codable {
    let id: UUID
    let type: TransactionType
    let amount: Decimal
    let createdAt: Date
    let status: TransactionStatus
}


struct Wallet: Codable { var balance: Decimal }
