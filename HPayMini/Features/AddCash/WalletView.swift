//
//  Untitled.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI
import Stripe
import StripePaymentSheet


struct WalletView: View {
    let repo: HPayRepository
    @StateObject private var vm: WalletViewModel
    @State private var showingAddCash = false
    @State private var showingAddCard = false
    @State private var isProcessingPayment = false
    @State private var sheetHeight: CGFloat = .zero
    @State private var pendingAmount: Decimal? = nil
    
    let stripe = StripePaymentService()
   
    
    
    init(repo: HPayRepository) {
        self.repo = repo
        _vm = StateObject(wrappedValue: WalletViewModel(repo: repo))
       
    }
    
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack() {
                    ZStack {
                        Image("cardBackground")
                        
                            .resizable()
                            .frame(width: size.width - 30
                                   ,height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack{
                            VStack{
                                
                            }
                            .frame(height: 80)
                            HStack() {
                                
                                VStack(alignment:.leading){
                                    Text("إجمالي الرصيد")
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                    Text(Money.format(vm.wallet?.balance ?? 0))
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal,40)
                            
                        }
                        
                    }
                    
                    
                    
                    
                    HStack{
                        LoadingButton(title: "اضافة رصيد", imageName: "plus.circle") { showingAddCash = true }
                        LoadingButton(title: "تحويل", imageName: "paperplane") { }
                        LoadingButton(title: "بطاقات", imageName: "creditcard") { showingAddCard = true }
                        LoadingButton(title: "المزيد", imageName: "ellipsis") { }
                        
                    }
                    
                    .frame(maxWidth: size.width - 100)
                    
                    
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack{
                                VStack(alignment: .leading){
                                    Text("نقدم لك  HPaymini")
                                        .font(.callout.bold())
                                    Text("اكتشف محفظتك بشكل جديد ومزايا إضافية !")
                                        .font(.caption)
                                }
                                Spacer()
                            }
                            .padding()
                            .frame(width: size.width - 20)
                            .background(Color(red: 0.8612945676, green: 0.8787013292, blue: 0.979521215))
                            .cornerRadius(10)
                            
                            HStack{
                                Text("العمليات")
                                    .font(.headline)
                                    .foregroundStyle(Color("deepBrown"))
                                    .fontWeight(.bold)
                                Spacer()
                                Text("إظهار الكل")
                                    .foregroundStyle(.blue)
                                
                            }
                            
                            RecentTransactionsSnippet(repo: repo)
                            Spacer(minLength: 0) // lets the card stretch
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .background(
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .ignoresSafeArea(edges: .bottom)
                    )
                    
                    
                    
                    
                    
                }
                .navigationTitle("HPay")
                .toolbar { ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        Task { await vm.load() }
                    } label: {
                        Image(systemName: "arrow.trianglehead.counterclockwise")
                            .foregroundStyle(Color("deepBrown"))
                    }
                    
                } }
                .task {
                    
                    
                    await vm.load()
                    
                }
                
                .sheet(isPresented: $showingAddCard) {
                    CardsView(repo:repo)
                        .environment(\.layoutDirection, .rightToLeft)
                }
                
                .sheet(isPresented: $showingAddCash) {
                    // MARK: For add payment sandbox use StripePaymentService() insted MockPaymentService()  ---------------------------
                    
                    AddCashView(vm: AddCashViewModel(repo: repo, payment: MockPaymentService()),
                                onConfirm: { amount in
                        pendingAmount = amount
                        showingAddCash = false
                        
                    }
                    )
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }
                    .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                        sheetHeight = newHeight
                    }
                    .presentationDetents([.height(sheetHeight)])
                }
                
                
                // MARK: For payment sandbox ---------------------------
                //                .onChange(of: showingAddCash) { old,new in
                //                    if !new, let amount = pendingAmount, !isProcessingPayment {
                //                        Task { await startStripePayment(amount: amount) }
                //                    }
                //                }
                
                
                
                
                
            }
        }
        
        .environment(\.layoutDirection, .rightToLeft)
        
        
    }
    
    // MARK: For payment sandbox ---------------------------
    
    @MainActor
    func startStripePayment(amount: Decimal) async {
        isProcessingPayment = true
        defer { isProcessingPayment = false }
        do {
            let clientSecret = try await stripe.createTopUpIntent(userId: 1, amountSar: amount)
            try await stripe.presentPaymentSheet(clientSecret: clientSecret)
            let wallet = try await repo.topUp(amount: amount)
            print("✅ New balance:", wallet.balance)
        } catch {
            print("❌ Stripe failed:", error.localizedDescription)
        }
        pendingAmount = nil
    }
    
    
    
}


struct RecentTransactionsSnippet: View {
    let repo: HPayRepository
    @StateObject private var vm: TransactionsViewModel
    
    init(repo: HPayRepository) {
        self.repo = repo
        _vm = StateObject(wrappedValue: TransactionsViewModel(repo: repo))
    }
    
    
    var body: some View {
        
        VStack {
            if vm.isLoading {
                ProgressView()
            } else if vm.errors != nil {
                Text("Couldn’t load.")
            } else {
                ForEach(vm.txs.prefix(3)) { tx in
                    HStack {
                        HStack{
                            Image( "banda")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).fill(Color("deepBrown").opacity(0.1)))
                            
                        }
                        VStack(alignment: .leading) {
                            Text(tx.type == .topUp ? "Top-Up" : "Payment")
                            Text(DateFormatter.tx.string(from: tx.createdAt))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        
                        
                        
                        Spacer()
                        let signColor: Color = (tx.amount as NSDecimalNumber).doubleValue < 0 ? .red : .green
                        RiyalAmountView(amount: tx.amount, color: signColor)
                    }
                    Divider()
                }
            }
        }
        
        .task { await vm.load() }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
