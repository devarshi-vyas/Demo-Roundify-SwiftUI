//
//  ContentView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 17/11/25.
//
//
//import SwiftUI
//import SwiftData
//
//// MARK: - ContentView
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//    @EnvironmentObject var router: Router
//
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var navigateToSignup = false
//    @State private var showAlert = false
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var isOtpEntered: Bool = false
//    @State private var isOtpHidden = true
//    @State private var isNotValid: Bool = false
//    
//    @StateObject var validationsModel = Validations()
//    @EnvironmentObject var viewModel: LoginViewModel
//    
//    private let toast = ToastManager.shared
//    
//
//    var body: some View {
//        ZStack {
//            VStack {
//             
//                HeaderviewAuthentication()
//                
//                Spacer()
//                    .frame(height:-10)
//                
//                ScrollView {
//                    VStack(spacing: 20) {
//                        Spacer()
//                            .frame(height:5)
//                        
//                        VStack(spacing:10) {
//                            Text("Login")
//                                .font(.title)
//                                .fontWeight(.bold)
//                            
//                            Text("Fill up the below details to get Log in to your account")
//                                .padding(.horizontal)
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Spacer()
//                            .frame(height:10)
//                        
//                        CustomTextfield(
//                            title: "UserId or Email",
//                            placeholder: "Enter your UserId or Email",
//                            text: $username
//                        )
//                        
//                        CustomSecureTextfield(
//                            title: "Password",
//                            placeholder: "Enter your Password",
//                            text: $password
//                        )
//                        
//                        if isOtpHidden {
//                            HStack {
//                                Spacer()
//                                
//                                Button("FORGOT USERID OR PASSWORD") {
//                                    router.navigate(to:.forgotPassword)
//                                }
//                                .underline()
//                                .font(.system(size: 14))
//                                .foregroundColor(Color.customBlue)
//                                .padding(.trailing,20)
//                            }
//                            
//                        }
//                        
//                        if !isOtpHidden
//                        {
//                            VStack(spacing: 10) {
//                                Text("To ensure security of your account, an OTP has been sent to your registered email and mobile number for verification of this new device.")
//                                    .multilineTextAlignment(.leading)
//                                    .font(Font.system(size: 14))
//                                    .foregroundColor(Color.customBlue)
//                                    .padding()
//                                
//                                customOTPView(isEntered:$isOtpEntered)
//                                
//                            }
//                            
//                        }
//                        
//                        Spacer()
//                            .frame(height: 10)
//                        
//                        Button("LOGIN") {
//                            
//                           checkValidatation()
//                            
//                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 45)
//                        .background(Color.customBlue)
//                        .foregroundColor(.white)
//                        .cornerRadius(5)
//                        .padding(.horizontal)
//                        .disabled(isLoginDisabled)
//                        .opacity(isLoginDisabled ? 0.6 : 1.0)
//                        
//                        HStack {
//                            Text("Don't have an account?")
//                            Button("SIGNUP") {
//                                router.navigate(to: .signup1)
//                            }
//                            .underline()
//                            .font(.system(size: 14))
//                            .foregroundColor(Color.customBlue)
//                            .padding(.trailing,20)
//                        }
//                        
//                        Spacer()
//                    }.frame(maxWidth: .infinity, maxHeight:.infinity)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                    
//                    
//                }.background(Color.white).cornerRadius(20)
//            }
//            .navigationBarBackButtonHidden(true)
//            
//            // Loading overlay
//            if viewModel.isLoading {
//                Color.black.opacity(0.3)
//                    .edgesIgnoringSafeArea(.all)
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    .scaleEffect(1.5)
//            }
//        }
//  
//        .onChange(of: viewModel.isSuccess) { oldValue, newValue in
//            if newValue {
//                toast.show(message: "Login successful!", style: .success)
//            }
//        }
//        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
//            if let error = newValue {
//                toast.show(message: error, style:.error)
//            }
//        }
//        
//        .onChange(of: viewModel.isDeviceIdSucess) { oldValue, newValue in
//            if newValue {
//                DeviceUUIDManager.shared.saveNewDeviceID(viewModel.deviceId ?? "")
//                CredentialManager.shared.clearCredentials()
//                TokenManager.shared.clearTokens()
//                
//            }
//        }
//        .onChange(of: viewModel.isNewDeviceId) { oldValue, newValue in
//            if newValue {
//                
//                isOtpHidden = false
//                
//            }
//        }
//        
//    }
//    
//   
//    
//    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
