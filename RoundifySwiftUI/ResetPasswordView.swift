//
//  ResetPasswordView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 29/12/25.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State private var newpassword: String = ""
    @State private var confirmpassword: String = ""
    @EnvironmentObject var router: Router
    
    private let toast = ToastManager.shared
    @StateObject var viewModel = SignupViewModel()
    let userID: String
    let phone: String
    
    var body: some View {
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
                    Text("Reset Password")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Fill up new password and confirm new password to reset your password.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                }
                
                
                CustomSecureTextfield(title:"New Password" , placeholder:"Enter your new password", text: $newpassword)
                
                CustomSecureTextfield(title:"Confirm New Password" , placeholder:"Enter your confirm password", text:$confirmpassword)
                
                Button("RESET PASSWORD"){
                    
                    if checkValidation() {
                        
                        resetPasswordRequest()
                    }
                    
                }.frame(maxWidth: .infinity)
                    .frame(height:40)
                    .background(Color.customBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Button("BACK TO LOGIN"){
                   
                    router.navigateToRoot()
                    
                }.font(.subheadline)
                    .fontWeight(.semibold)
                    .underline()
                    .foregroundColor(.customBlue)
                
                
                Spacer()
                
            }.frame(maxWidth: .infinity,maxHeight:.infinity)
                .background(Color.white)
                .cornerRadius(20)
            
        }.navigationBarBackButtonHidden()
        
        
    }
    
    
    private func checkValidation() -> Bool {
        
        if newpassword.isEmpty || confirmpassword.isEmpty {
            
            toast.show(message: "Please fill all the fields", style: .error)
            
            return false
        }
        
        if newpassword != confirmpassword {
            
            toast.show(message: "Password does not match", style: .error)
            
            return false
        }
        
        return true
    }
    
    private func resetPasswordRequest() {
        
        let parameters: [String: Any] = [
            "UserID": userID,
            "PhoneNumber": "+91" + phone ,
            "Password": newpassword ]
        
        viewModel.resetPasswordRequest(params: parameters)
        
    }
   
}

#Preview {
    ResetPasswordView(userID: "", phone: "")
}
