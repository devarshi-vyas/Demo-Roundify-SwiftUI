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
    @State private var receivedOtp:String = ""
    @State private var isVerifyClicked:Bool = false
   
    @StateObject var validationsModel = Validations()
    @StateObject var viewModel = SignupViewModel()
    
    private let toast = ToastManager.shared
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
                
                CustomPhoneTextField(textPhone:$phone, isVerifyClicked: $isVerifyClicked)
                    .focused($isInputActive)
                
                isOtpViewOpened ? customOTPView(isOtpEntered: $isOtpEntered, receivedOTP:$receivedOtp).focused($isInputActive) : nil
                
                
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
                    
                    router.navigate(to: .signup2(mobile: phone))
                    
                    //  navigateToSignUp2 = true
                    
                }.frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .background(isOtpEntered && isToggle ? Color.customBlue : Color.customBlue.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .disabled(!(viewModel.isOTPVerified && isToggle))
                
                
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
            .onChange(of: isVerifyClicked) { oldValue, newValue in
                if newValue {
                    
                    if checkValidation() == false {
                        
                        return
                    } else {
                        
                        let  verifyUserParams = [
                            "PhoneNumber": "+91" + (phone),
                            "Function": "signup" ]
                        
                        viewModel.verifyUser(params:verifyUserParams)
                    }
                    
                }
            }
        
            .onChange(of: viewModel.isUserVerified) { oldValue, newValue in
                if newValue {
                    let number = "+91" + (phone)
                    let params = ["phoneNumber":number]
                    viewModel.getOTPRequest(params: params)
                }
            }
            .onChange(of: viewModel.isOTPReceived) { oldValue, newValue in
                if newValue {
                   isOtpViewOpened = true
                }
            }
            .onChange(of: isOtpEntered) { oldValue, newValue in
                if newValue {
                    let parameters: [String: Any] = [
                        "user": ["phoneNumber":"+91" + phone],
                        "code": receivedOtp
                    ]
                    
                    viewModel.verifyOTPRequest(params: parameters)
                }
            }
          
        
            
        
     //   }.navigationBarBackButtonHidden()
        
//        .navigationDestination(isPresented: $navigateToSignUp2) {
//           SignUpSecondView()
//        }
        
    }
    
    
   
    private func checkValidation() -> Bool {
        
        let validMobileError =  validationsModel.validateMobileNumber(phone)
        
        if validMobileError == nil {
            
            return true
        }else {
            
            toast.show(message: validMobileError ?? "", style: .error)
            
            return false
            
        }
        
        
    }
    
   
    
}
#Preview {
    SignUpFirstView()
}
