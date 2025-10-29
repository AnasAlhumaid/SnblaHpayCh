//
//  CardsView.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


struct CardsView: View {
    let repo: HPayRepository
    @StateObject private var vm: CardsViewModel
    
    
    init(repo: HPayRepository) {
        self.repo = repo
        _vm = StateObject(wrappedValue: CardsViewModel(repo: repo))
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("البطاقات المحفوظة") {
                    ForEach(vm.cards) { card in
                        HStack {
                            Image(systemName: "creditcard")
                            VStack(alignment: .leading) {
                                Text("\(card.brand) •••• \(card.last4)")
                                Text("Exp: \(card.expMonth)/\(card.expYear)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                        Task { await vm.delete(at: offsets) }
                    }
                }
                
                
                Section("اضف بطاقة جديدة (mock)") {
                    Picker("نوعها", selection: $vm.brand) {
                        Text("Visa").tag("Visa"); Text("Mastercard").tag("Mastercard"); Text("Mada").tag("Mada")
                    }
                    TextField("Last 4 digits", text: $vm.last4)
                        .keyboardType(.numberPad)
                    HStack {
                        TextField("MM", text: $vm.expMonth).keyboardType(.numberPad)
                        Text("/")
                        TextField("YYYY", text: $vm.expYear).keyboardType(.numberPad)
                    }
                    LoadingButton(title: "Add Card", imageName: "plus", isLoading: vm.isLoading) { Task { await vm.addCard() } }
                        .disabled(vm.last4.count != 4)
                }
                
                
                if let error = vm.error {
                    Section { Text(error).foregroundStyle(.red) }
                }
            }
            .navigationTitle("البطاقات")
            .task { await vm.load() }
        }
    }
}
