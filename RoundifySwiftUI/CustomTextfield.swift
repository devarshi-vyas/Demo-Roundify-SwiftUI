//
//  CustomTextfield.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 19/11/25.
//

import SwiftUI

struct CustomTextfield: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .padding(.leading)
                .font(.caption)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .padding(.horizontal)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CustomTextfield(title: "", placeholder: "", text: .constant(""))
}
