//
//  CardsViewModel.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//
import Foundation


@MainActor
final class CardsViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading = false
    @Published var error: String? = nil
    
    
    @Published var brand = "Visa"
    @Published var last4 = ""
    @Published var expMonth = ""
    @Published var expYear = ""
    
    
    private let repo: HPayRepository
    init(repo: HPayRepository) { self.repo = repo }
    
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do { cards = try await repo.getCards() } catch { errorHandler(error) }
    }
    
    
    func addCard() async {
        guard let month = Int(expMonth), let year = Int(expYear), last4.count == 4 else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            _ = try await repo.createCard(brand: brand, last4: last4, expMonth: month, expYear: year)
            await load()
            brand = "Visa"; last4 = ""; expMonth = ""; expYear = ""
        } catch { errorHandler(error) }
    }
    
    
    func delete(at offsets: IndexSet) async {
        guard let index = offsets.first else { return }
        let id = cards[index].id
        isLoading = true
        defer { isLoading = false }
        do { try await repo.removeCard(id: id); await load() } catch { errorHandler(error) }
    }
    
    
    private func errorHandler(_ error: Error) { self.error = error.localizedDescription }
}
