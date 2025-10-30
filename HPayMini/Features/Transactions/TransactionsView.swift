//
//  TransactionsView.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI



struct RecentTransactionsSnippet: View {
 
    @ObservedObject var vm: TransactionsViewModel

    var body: some View {
        
        VStack {
            if vm.isLoading {
                ProgressView()
            } else if vm.errors != nil {
                Text("Couldn’t load.")
            } else {
                ForEach(vm.txs.prefix(3)) { tx in
                    let signColor: Color = tx.type == .payment ? .red : .green
                    HStack {
                        HStack{
                            if tx.image == "banda" {
                                Image( tx.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).fill(Color("deepBrown").opacity(0.1)))
                            }else{
                                Image( systemName: tx.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).fill(Color("deepBrown").opacity(0.1)))
                            }
                            
                            
                        }
                        VStack(alignment: .leading) {
                            Text(tx.name)
                            
                            Text(DateFormatter.tx.string(from: tx.createdAt))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        
                        
                        
                        Spacer()
                        RiyalAmountView(amount: tx.amount, color: signColor)
                    }
                    Divider()
                }
            }
        }
        
        .task { await vm.load() }
        
    }
}
