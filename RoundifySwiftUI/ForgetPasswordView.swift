//
//  ForgetPasswordView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 19/12/25.
//

import SwiftUI

struct ForgetPasswordView: View {
    
    @State private var selectedType = "Forgot Password"
    let forgotTypes: [String] = ["Forgot Password", "Forgot UserID"]
    
    let verifyTypes: [String] = ["Mobile","E-mail"]
    
    @State private var selectedVerifyType = "Mobile"
    
    @State var txtUserId: String = ""
    @State var txtPhone: String = ""
    @State var txtEmail: String = ""
    @State var isOtpOpen: Bool = false
    @State private var isMobile: Bool = true
    @State private var isUserId: Bool = true
    @FocusState private var isInputActive
    @State private var isOtpEntered:Bool = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        
        VStack {
            ZStack {
                Image("bgimage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .top)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                
                Text("Roundifi")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
            }
            
            ScrollView {
                
                VStack(spacing: 10) {
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("Forgot User ID or Password?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Fill up the below details to get Forgot user ID or Password to your account.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                }
                
                VStack(spacing:15){
                    
                    Spacer()
                        .frame(height:10)
                    
                    HStack {
                        Text("Choose")
                            .padding(.leading,15)
                            .font(.subheadline)
                        
                        Spacer()
                        
                    }
                    
                    CustomSegmentControl(
                        items: forgotTypes,
                        itemLabel: { $0 },
                        selection: $selectedType,
                        backgroundColor: Color.gray.opacity(0.1),
                        selectedBackgroundColor: .customBlue,
                        selectedTextColor: .white,
                        unselectedTextColor: .primary,
                        onSelectionChange: { tab in
                            
                            isUserId = (tab == "Forgot Password")
                            
                        }
                    ).padding(.horizontal, 20)
                    
                    
                    if isUserId {
                        
                        CustomTextfield(title: "UserID", placeholder: "Enter your userID", text: $txtUserId) .focused($isInputActive)
                    }
                    
                    
                    HStack {
                        Text("Verify")
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                    }
                    
                    HStack {
                        CustomSegmentControlwithHW(
                            items: verifyTypes,
                            itemLabel: { $0 },
                            selection: $selectedVerifyType,
                            backgroundColor: Color.gray.opacity(0.1),
                            selectedBackgroundColor: .customBlue,
                            selectedTextColor: .white,
                            unselectedTextColor: .primary,
                            width: 150,
                            segmentHeight:20,
                            onSelectionChange: { tab in
                                
                                isMobile = (tab == "Mobile")
                                
                            }
                            
                            
                        ).padding(.horizontal)
                        
                        
                        
                        Spacer()
                    }
                    
                    Group {
                        if isMobile {
                            PhoneTextField(textPhone: $txtPhone, otpviewOpened: $isOtpOpen) .focused($isInputActive)
                        } else {
                            EmailTextField(textEmail: $txtEmail, otpviewOpened: $isOtpOpen) .focused($isInputActive)
                        }
                    }
                    
                    isOtpOpen ? customOTPView(isEntered: $isOtpEntered).focused($isInputActive) : nil
                    
                    
                    Button("Continue") {
                        
                        router.navigate(to: .resetPassword)
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.customBlue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(15)
                        .font(Font.system(size: 16, weight: .semibold))
                    
                    
                    Button("BACK TO LOGIN"){
                     
                     router.navigateToRoot()
                        
                    }.underline()
                     .font(Font.system(size: 14, weight: .semibold))
                     .foregroundColor(Color.customBlue)
                    
                }
                
                Spacer()
                
            }.frame(maxWidth: .infinity,maxHeight:.infinity)
                .background(Color.white)
                .cornerRadius(20)
            
        }.onTapGesture {
            isInputActive = false
        }.navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ForgetPasswordView()
}
