//
//  PhoneTextField.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 25/12/25.
//

import Foundation
import SwiftUI



struct PhoneTextField: View {
    
    @Binding var textPhone: String
    @Binding var isVerifyClicked:Bool
    
    
    var body: some View {
        
        VStack(spacing:15) {
            VStack {
                
                HStack {
                    Text("+91")
                        .font(.headline)
                        .foregroundStyle(Color.gray)
                    
                    VStack{
                        
                    }.frame(maxWidth:1.0, maxHeight: 25)
                        .background(Color.gray)
                    
                    TextField("Enter Phone Number", text:$textPhone)
                        .font(.headline)
                        .keyboardType(.numberPad)
                        .onChange(of: textPhone) { oldValue, newValue in
                            // Limit to 10 digits
                            if newValue.count > 10 {
                                textPhone = String(newValue.prefix(10))
                            }
                        }
                    
                    Button("Verify"){
                        
                        isVerifyClicked.toggle()
                        
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
    PhoneTextField(textPhone:.constant(""), isVerifyClicked:.constant(false))
}
    

