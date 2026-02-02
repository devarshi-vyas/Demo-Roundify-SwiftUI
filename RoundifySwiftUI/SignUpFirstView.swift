//
//  SignUpFirstView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 03/12/25.
//

import SwiftUI

struct SignUpFirstView: View {
    
    @State private var phone:String = ""
    @State private var isToggle:Bool = false
    @State private var isOtpViewOpened:Bool = false
    @FocusState private var isInputActive: Bool
    @State private var isOtpEntered:Bool = false
    @State private var navigateToSignUp2:Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
     //  NavigationStack {
        VStack {
            ZStack {
                Image("bgimage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges:.top)
                    .frame(maxWidth: .infinity)
                    .frame(height:100)
                
                Text("Roundifi")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
            }
            VStack(spacing:20){
                Spacer()
                    .frame(height:10)
                
                VStack(spacing:10) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Please verify your mobile number")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                }
                
                CustomPhoneTextField(textPhone:$phone, otpviewOpened: $isOtpViewOpened)
                    .focused($isInputActive)
                
                
                isOtpViewOpened ? customOTPView(isEntered: $isOtpEntered).focused($isInputActive) : nil
                
                
                HStack(spacing:10) {
                    
                    Button {
                        isToggle.toggle()
                    } label: {
                        isToggle ? Image(systemName: "checkmark.square.fill"):Image(systemName: "square")
                        
                    }
                    
                    Text("Review Terms & Conditions and Privacy Policy")
                        .font(.caption)
                    
                    Spacer()
                }.padding(.horizontal)
                
                
                Button("CONTINUE") {
                    
                    router.navigate(to: .signup2)
                    
                    //  navigateToSignUp2 = true
                    
                }.frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .background(isOtpEntered && isToggle ? Color.customBlue : Color.customBlue.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .disabled(!(isOtpEntered && isToggle))
                
                
                HStack(spacing:5) {
                    
                    Text("Already have an account?")
                    
                    Button("LOGIN") {
                        
                        router.navigateBack()
                        
                    }.underline(true)
                        .padding(.bottom,2)
                        .foregroundColor(.customBlue)
                    
                }.font(.subheadline)
                
                
                Spacer()
                
            }.frame(maxWidth: .infinity,maxHeight:.infinity)
                .background(Color.white)
                .cornerRadius(20)
            
            
            
        }.onTapGesture {
                isInputActive = false
            }.navigationBarBackButtonHidden(true)
            
     //   }.navigationBarBackButtonHidden()
        
//        .navigationDestination(isPresented: $navigateToSignUp2) {
//           SignUpSecondView()
//        }
        
    }
    
}
#Preview {
    SignUpFirstView()
}
