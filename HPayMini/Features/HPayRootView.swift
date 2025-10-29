//
//  HPayRootView.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


struct HPayRootView: View {
    @EnvironmentObject var container: AppContainer
    
    
    var body: some View {
        TabView {
            WalletView(repo: container.repo)
                .tabItem { Label("HPay", systemImage: "creditcard") }
           
        
        }
    }
}
