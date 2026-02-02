//
//  CustomSecureTextfield.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 20/11/25.
//

import SwiftUI

struct CustomSecureTextfield: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool = true
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .padding(.leading)
                .font(.caption)
            
            ZStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                }else {
                    
                    TextField(placeholder, text: $text)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                }
        
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        if isSecure {
                            Image(systemName: "eye.slash")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }else{
                            Image(systemName: "eye")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }
                        
                    }.padding(.trailing,30)
                }
            }
            
        }
    }
    
}
    
    #Preview {
        CustomSecureTextfield(title: "", placeholder: "", text:.constant(""))
    }
    

