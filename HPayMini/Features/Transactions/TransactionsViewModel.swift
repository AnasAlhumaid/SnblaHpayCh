//
//  TransactionsViewModel.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import Foundation


@MainActor
final class TransactionsViewModel: ObservableObject {
    @Published var txs: [Transactions] = []
    @Published var isLoading = false
    @Published var errors: String? = nil
    
    
    private let repo: HPayRepository
    init(repo: HPayRepository) { self.repo = repo }
    
    
    func load() async {
        
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            txs = try await repo.getTransactions()
            
        }
        catch {
            errors = error.localizedDescription
        }
        
        
    }
}
