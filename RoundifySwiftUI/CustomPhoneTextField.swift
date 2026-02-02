//
//  CustomPhoneTextField.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 04/12/25.
//

import SwiftUI

struct CustomPhoneTextField: View {
    
    @Binding var textPhone: String
    @Binding var otpviewOpened: Bool
  
    
    var body: some View {
        
        VStack(spacing:15) {
            
            HStack {
                Text("Phone No.")
                    .font(.headline)
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
            
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
                        
                        otpviewOpened = true
                        
                    }.foregroundColor(.blue)
                    
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
        CustomPhoneTextField(textPhone:.constant(""), otpviewOpened: .constant(false))
    }
    

