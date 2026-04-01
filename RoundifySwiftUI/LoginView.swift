//
//  LoginView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 12/02/26.
//

import SwiftUI

struct LoginView: View {
    
  //  @Query private var items: [Item]
    @EnvironmentObject var router: Router

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigateToSignup = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isOtpEntered: Bool = false
    @State private var isOtpHidden = true
    @State private var isNotValid: Bool = false
    @State private var receivedOTP: String = ""
    @State private var isSecondLogin: Bool = false

    @StateObject var validationsModel = Validations()
    @EnvironmentObject var viewModel: LoginViewModel

    private let toast = ToastManager.shared
    

    var body: some View {
        ZStack {
            mainContent
            
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.isSuccess) { oldValue, newValue in
            if newValue {
                if !viewModel.isNewDeviceId {
                    toast.show(message: "Login successful!", style: .success)
                    router.navigate(to: .tabBarView)
                } else {
                    isOtpHidden = false
                    isSecondLogin = true
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if let error = newValue {
                toast.show(message: error, style:.error)
            }
        }
        .onChange(of: viewModel.isDeviceIdSucess) { oldValue, newValue in
            if newValue {
                DeviceUUIDManager.shared.saveNewDeviceID(viewModel.deviceId ?? "")
                CredentialManager.shared.clearCredentials()
                TokenManager.shared.clearTokens()
            }
        }
        .onChange(of: viewModel.isSucesswithOTP){ oldValue, newValue in
            if newValue {
                router.navigate(to: .tabBarView)
            }
        }
    
    }

    // MARK: - Subviews

    private var mainContent: some View {
        VStack {
            HeaderviewAuthentication()
            
            Spacer()
                .frame(height: -10)
            
            ScrollView {
                loginFormContent
            }
            .background(Color.white)
            .cornerRadius(20)
        }
    }

    private var loginFormContent: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 5)
            
            loginHeader
            
            Spacer()
                .frame(height: 10)
            
            inputFields
            
            if !isOtpHidden {
                otpSection
            }
            
            Spacer()
                .frame(height: 10)
            
            loginButton
            
            signupPrompt
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
    }

    private var loginHeader: some View {
        VStack(spacing: 10) {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Fill up the below details to get Log in to your account")
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
    }

    private var inputFields: some View {
        VStack(spacing: 10) {
            CustomTextfield(
                title: "UserId or Email",
                placeholder: "Enter your UserId or Email",
                text: $username
            )
            
            CustomSecureTextfield(
                title: "Password",
                placeholder: "Enter your Password",
                text: $password
            )
            
            if isOtpHidden {
                forgotPasswordButton
            }
        }
    }

    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            
            Button("FORGOT USERID OR PASSWORD") {
                router.navigate(to: .forgotPassword)
            }
            .underline()
            .font(.system(size: 14))
            .foregroundColor(Color.customBlue)
            .padding(.trailing, 20)
        }
    }

    private var otpSection: some View {
        VStack(spacing: 10) {
            Text("To ensure security of your account, an OTP has been sent to your registered email and mobile number for verification of this new device.")
                .multilineTextAlignment(.leading)
                .font(Font.system(size: 14))
                .foregroundColor(Color.customBlue)
                .padding()
            
            customOTPView(isOtpEntered: $isOtpEntered, receivedOTP: $receivedOTP)
        }
    }

    private var loginButton: some View {
        Button("LOGIN") {
            if isSecondLogin{
                performOtpLogin()
            }else {
                checkValidatation()
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .background(Color.customBlue)
        .foregroundColor(.white)
        .cornerRadius(5)
        .padding(.horizontal)
        .disabled(isSecondLogin ? isLoginwithOTPDisabled : isLoginDisabled)
        .opacity((isSecondLogin ? isLoginwithOTPDisabled : isLoginDisabled) ? 0.6 : 1.0)
    }

    private var signupPrompt: some View {
        HStack {
            Text("Don't have an account?")
            Button("SIGNUP") {
                router.navigate(to: .signup1)
            }
            .underline()
            .font(.system(size: 14))
            .foregroundColor(Color.customBlue)
            .padding(.trailing, 20)
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
    
    private func performLogin() {
        // Hide keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let params: [String: Any] = [
            "Email": username,  // Change to "email" or "userId" if needed
            "Password": password,
//            "device_info" : [
//                "device_id": "069815f7-37ca-4c16-84f6-f68ecdf4902c",
//                "device_make": "Apple",
//                "device_model": "iPhone 13 Pro",
//                "os_version": "18.3",
//                "app_version": "0.0.1",
//                "platform": "Mobile",
//                "platform_detail" : "iOS"
//            ]
            
            "device_info":DeviceInfoProvider.shared.deviceInfo
        ]
        
        viewModel.login(params: params)
    }
    
    
    private func performOtpLogin() {
        
        let params: [String: Any] = [
        "action": "Verify",
        "userID": CredentialManager.shared.getUserID() ?? "",
        "device_info":[
            "device_id":DeviceUUIDManager.shared.getDeviceUUID()
        ],
        "otp": receivedOTP]
        
        
        viewModel.loginWithOtp(params: params)
    }
    
    
    private var isLoginDisabled: Bool {
        username.isEmpty ||
        password.isEmpty ||
        viewModel.isLoading
    }
    
    private var isLoginwithOTPDisabled: Bool {
         !isOtpEntered
    }
    
    
    private func checkValidatation() {
        
        let validEmailError =  validationsModel.validateEmail(username)
        
        let validPasswordError =  validationsModel.validatePassword(password)
        
        if validEmailError == nil && validPasswordError == nil {
            
            if DeviceUUIDManager.shared.existingDeviceID() {
                CredentialManager.shared.clearCredentials()
                TokenManager.shared.clearTokens()
                
            } else {
                
                viewModel.getDeviceID()
            }
            
            performLogin()
            
        }
        else if validEmailError != nil  {
            
            toast.show(message: "Please enter valid Email", style: .error)
            
        }else if validPasswordError != nil {
            
            toast.show(message: "Please enter valid Password", style: .error)
        }
        
    }
}

#Preview {
    LoginView()
}
