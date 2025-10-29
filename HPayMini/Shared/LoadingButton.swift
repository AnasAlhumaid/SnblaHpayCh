//
//  LoadingButton.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


struct LoadingButton: View {
    var title: String
    var imageName: String
    var isLoading: Bool = false
    var action: () -> Void
   
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading { ProgressView().controlSize(.small) }
                VStack{
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(10)
                        .background(.white)
                        .foregroundStyle(Color("deepBrown"))
                        .clipShape(Circle())
                    Text(title)
                        .foregroundStyle(Color("deepBrown"))
                        .font(.caption2)
                        
                    
                }
            }
            .frame(maxWidth: .infinity)
        }
      
        .disabled(isLoading)
    }
}
