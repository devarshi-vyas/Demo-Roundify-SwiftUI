//
//  SignUpSecondView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 20/11/25.
//

import SwiftUI

struct SignUpSecondView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var navigateToLogin: Bool = false
    @State private var isToggle: Bool = false
    
    @StateObject var validationsModel = Validations()
    @StateObject var viewModel = SignupViewModel()
    
    let mobileNumber: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router
    
    private let toast = ToastManager.shared
    
    var body: some View {
     //   NavigationStack {
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
                
                ScrollView {
                    VStack(spacing:10) {
                        Spacer()
                            .frame(height: 10)
                        
                        VStack(spacing:10) {
                            Text("Sign Up")
                                .font(Font.largeTitle.bold())
                            Text("Create your account by filling your details below")
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                            .frame(height:0) // Fixed space from top
                        
                        CustomTextfield(title:"Name" , placeholder: "Enter your name", text: $name)
                        
                        CustomTextfield(title:"Email" , placeholder: "Enter your email", text: $email)
                        
                        CustomSecureTextfield(title:"Password", placeholder: "enter your password", text: $password)
                        
                        CustomSecureTextfield(title:"Confirm Password", placeholder: "enter your confirm password", text: $confirmpassword)
                        
                        HStack(spacing:10) {
                            Button {
                                isToggle.toggle()
                            } label: {
                                if isToggle {
                                    Image(systemName: "checkmark.square.fill")
                                }else{
                                    Image(systemName: "square")
                                }
                            }.frame(width: 20, height: 20)
                            
                            
                            Text("Review Terms & Conditions and Privacy Policy")
                                .font(Font.system(size: 13))
                            
                            Spacer()
                        }.padding()
                        
                        
                        Button("SIGN UP") {
                            
                            if checkValidation() {
                                
                                let parameters: [String: Any] = [
                                    "Name": name,
                                    "Email": email,
                                    "Password": password,
                                    "PhoneNumber":"+91" + mobileNumber
                                ]
                                
                                
                                viewModel.signUpRequest(params: parameters)
                                
                            }
                            
                            
                        }.frame(maxWidth:.infinity)
                            .frame(height: 50)
                            .background(Color.customBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        HStack(spacing:5) {
                            Text("Already have an account?")
                            
                            Button("LOGIN") {
                                
                                router.navigateToRoot()
                                
                         //   navigateToLogin = true
                                
                            }.underline(true)
                                .foregroundColor(.customBlue)
                               
                            
                        } .font(.subheadline)
                            .padding(.bottom,2)
                        
                        Spacer()
                        
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(20.0)
                    
                }
            }.navigationBarBackButtonHidden(true)
      
            
     //   }.navigationBarBackButtonHidden()
        
//            .navigationDestination(isPresented: $navigateToLogin) {
//               ContentView()
//            }
        
    }
    
 
    private func checkValidation() -> Bool {
        
        let validEmailError = validationsModel.validateEmail(email)
        
        let validPasswordError = validationsModel.validatePassword(password)
        
        
        let validNameError = validationsModel.validateName(name)
        
        let passwordMatch = password == confirmpassword
        
        
        if validEmailError == nil && validPasswordError == nil && validNameError == nil && passwordMatch {
            
            return true
            
        } else if validNameError != nil {
            
            toast.show(message: "Please enter valid Name", style: .error)
            
            return false
        }
        
        else if validEmailError != nil  {
            
            toast.show(message: "Please enter valid Email", style: .error)
            return false
            
        }else if validPasswordError != nil {
            
            toast.show(message: "Please enter valid Password", style: .error)
            return false
            
        } else if password != confirmpassword {
            
            toast.show(message: "Password does not match", style: .error)
            
            return false
        }
            
       return true
    }
    
    
}

#Preview {
    SignUpSecondView(mobileNumber: "")
}

