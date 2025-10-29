//
//  HPayMiniApp.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI

import Stripe
@main
struct HPayMiniApp: App {
    
    
    @StateObject private var container = AppContainer()
    
    init() {
            StripeAPI.defaultPublishableKey = "pk_test_51SN7GG34pRxpJcORrr89ok52Cud4Ip6A9aKZoK2TC5YYJqPLkbQKb9a8OjvV1grOWhSfQ4qOVYv0Qmp0oGlXd3AS00lwBLRMNM"
        }
    var body: some Scene {
        WindowGroup {
            HPayRootView()
                .environmentObject(container)
        }
    }
}


final class AppContainer: ObservableObject {
    let api: HPayRepository
    let repo: HPayRepository
    
    
    init() {
#if DEBUG
        self.repo = MockHPayAPI(latency: .milliseconds(650), errorRate: 0.15)
#else
        self.repo = MockHPayAPI(latency: .milliseconds(500), errorRate: 0.05)
#endif
        self.api = MockHPayAPI(latency: .milliseconds(500), errorRate: 0.05)
        
        //MARK: SripePayment
//        self.api = HPayRepositoryCla(repo: repo)
        
//      ****  to activate this modify [WalletView , AddCashView] for init paymentScreen **
    }
}
