//
//  Untitled.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


@MainActor
final class WalletViewModel: ObservableObject {
    @Published var wallet: Wallet? = nil
    @Published var isLoading = false
    @Published var error: String? = nil
    
    
    private let repo: HPayRepository
    init(repo: HPayRepository) { self.repo = repo }
    
    
    func load() async {
        isLoading = true; defer { isLoading = false }
        do { wallet = try await repo.getWallet() } catch { self.error = error.localizedDescription }
    }
}
