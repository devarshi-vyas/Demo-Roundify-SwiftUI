//
//  customOTPView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 04/12/25.
//

import SwiftUI


struct customOTPView: View {
    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool
    @Binding var isEntered: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Enter OTP")
                    .font(.default)
                    .fontWeight(.regular)
                Spacer()
            }.padding(.horizontal)
            
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    OTPTextBox(index)
                }
            }
            .background(content: {
                TextField("", text: $otpText.limit(6))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
            })
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing = true
            }
            .onChange(of: otpText) { newValue in
                if newValue.count == 6 {
                    isKeyboardShowing = false
                    isEntered = true
                    // Handle OTP verification here
                    print("OTP entered: (newValue)")
                }else {
                    
                    isEntered = false
                }
            }
            

        }
        .padding()
        .onAppear {
            isKeyboardShowing = true
        }
    }
    
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
                    .font(.title)
                    .fontWeight(.semibold)
            } else {
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(otpText.count > index ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
        }
    }
}

// String extension to limit character count
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

// Preview
struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        customOTPView(isEntered: .constant(false))
    }
}
