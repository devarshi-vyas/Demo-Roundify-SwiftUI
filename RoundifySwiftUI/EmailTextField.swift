//
//  EmailTextField.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 25/12/25.
//

import Foundation

import SwiftUI


struct EmailTextField: View {
    
    @Binding var textEmail: String
    @Binding var otpviewOpened: Bool
    
    
    var body: some View {
        
        VStack(spacing:15) {
            VStack {
                
                HStack {
                    
                    TextField("Enter Your Email", text:$textEmail)
                        .font(.headline)
                        .keyboardType(.numberPad)
                        .onChange(of: textEmail) { oldValue, newValue in
                            // Limit to 10 digits
                            if newValue.count > 10 {
                                textEmail = String(newValue.prefix(10))
                            }
                        }
                    
                    Button("Verify"){
                        
                        otpviewOpened = true
                        
                    }.foregroundColor(.customBlue)
                    
                    Spacer()
                    
                }.padding(10)
                
            }.frame(maxWidth: .infinity, maxHeight:50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .padding(.horizontal)
            
        }
        
    }
}
    
    #Preview {
        EmailTextField(textEmail:.constant(""), otpviewOpened: .constant(false))
    }
    
