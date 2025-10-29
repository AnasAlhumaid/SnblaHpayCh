//
//  AddCashView.swift
//  HPayMini
//
//  Created by Anas Hamad on 28/10/2025.
//

import SwiftUI


struct AddCashView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: AddCashViewModel
    @State var selected = ""
   @State var otherActive = false
    
    
 
    @State private var contentHeight = 400.0
    
    var onConfirm: ((Decimal) -> Void)?
    
    
    var body: some View {
        
        
        VStack(alignment: .leading){
            HStack{
                Text("إضافة رصيد")
                    .font(.title2)
                    .foregroundStyle(Color("deepBrown"))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color("deepBrown"))
                }

             
                
            }
            .padding(.vertical)
            
            VStack(alignment:.leading){
                Text("طريقة الدفع" )
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("deepBrown"))
                
                PaymentMethodSelector(
                    selected: $selected,
                    options: [
                        PaymentOption(title: "الدفع الإلكتروني", logo: nil),
                        PaymentOption(title: "نقاط مكافأة", logo: "mokafaaLogo")
                    ]
                )
                
            }
            .padding(.vertical)
            if selected == "الدفع الإلكتروني" {
                
                VStack(alignment:.leading){
                    Text("مبلغ الشحن")
                        .fontWeight(.bold)
                        .foregroundStyle(Color("deepBrown").opacity(0.6))
                    HStack{
                        
                        Button {
                            otherActive = false
                            vm.amountText = "300"
                           
                        } label: {
                            Text("300 ر.س")
                                .foregroundStyle(Color("deepBrown").opacity(0.7))
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 0.5)
                                        .fill(vm.amountText == "300" ?Color("deepBrown").opacity(1) : Color("deepBrown").opacity(0.3))
                                }
                        }

                        Button {
                            otherActive = false
                            vm.amountText = "400"
                        } label: {
                            Text("400 ر.س")
                                .foregroundStyle(Color("deepBrown").opacity(0.7))
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 0.5)
                                        .fill(vm.amountText == "400" ?Color("deepBrown").opacity(1) : Color("deepBrown").opacity(0.3))
                                }
                        }

                        Button {
                            otherActive = false
                            vm.amountText = "500"
                            
                        } label: {
                            Text("500 ر.س")
                                .foregroundStyle(Color("deepBrown").opacity(0.7))
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 0.5)
                                        .fill(vm.amountText == "500" ?Color("deepBrown").opacity(1) : Color("deepBrown").opacity(0.3))
                                }
                        }

                        Button {
                            vm.amountText = ""
                            otherActive.toggle()
                        } label: {
                            Text("أخرى")
                                .foregroundStyle(Color("deepBrown").opacity(0.7))
                                .fontWeight(.bold)
                                .font(.caption)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 0.5)
                                        .fill(Color("deepBrown").opacity(0.3))
                                }
                        }

                        
                    }
                }
                .padding(.vertical)
               
            }
            if otherActive{
                VStack(alignment:.leading){
                    TextField("مبلغ الشحن", text: $vm.amountText)
                        .padding(10)
                        .keyboardType(.numberPad)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.5)
                                .fill(Color("deepBrown").opacity(0.3))
                        )
                    Text("الحد الاقصى 1000.00 ر.س")
                        .font(.caption)
                        .foregroundStyle(Color("deepBrown").opacity(0.7))
                    
                    
                }
            }
                
                         
            
            Button {
                vm.state = .loading
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    Task {
                        await vm.confirmTopUp()
                      
                    }
                        if let amount = Decimal(string: vm.amountText), amount > 0 {
                                                   onConfirm?(amount)
                          
                                               }
                })
              
                  
             
            } label: {
                if vm.state == .loading{
                    ProgressView()
                        .tint(.white)
                        .padding()
                        .frame(width: size.width - 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    
                                    Color("deepBrown").opacity(0.8)
                                )
                        )
                        .padding()
                }else{
                    Text("متابعة")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: size.width - 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    
                                    Color("deepBrown").opacity(0.8)
                                )
                        )
                        .padding()
                }
                   
                
            }
            .disabled(!vm.isValidAmount)
            
            
        }
        .padding()
      
        
        
        
        
        

        
        
        
        
        .environment(\.layoutDirection, .rightToLeft)
    }
}


struct PaymentOption: Identifiable {
    let id = UUID()
    let title: String
    let logo: String? // optional image on right side (e.g. "mokafaa")
}

struct PaymentMethodSelector: View {
    @Binding var selected: String
    let options: [PaymentOption]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options.indices, id: \.self) { i in
                let option = options[i]
                
                Button {
                    selected = option.title
                } label: {
                    HStack {
                        Spacer()
                        if let logo = option.logo {
                            Image(logo)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                        Text(option.title)
                            .foregroundStyle(Color("deepBrown"))
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .fill(selected == option.title ? Color("deepBrown") : .clear)
                                    .frame(width: 12, height: 12)
                            )
                    }
                    .padding( )
                    
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .fill(Color("deepBrown").opacity(0.2))
                            .shadow(color: .black.opacity(0.05), radius: 2, y: 4)
                    )
                }
                .buttonStyle(.plain)
                
                // Separator BETWEEN items only
                if i < options.count - 1 {
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        Text("أو")
                        
                            .foregroundStyle(Color("deepBrown"))
                            .padding(.horizontal, 12)
                            .background(Color(.systemBackground)) // or .white to “cut” the line
                    }
                    .frame(maxWidth: .infinity) // ensure full width
                }
            }
        }
        
        
        .environment(\.layoutDirection, .leftToRight)
    }
}

