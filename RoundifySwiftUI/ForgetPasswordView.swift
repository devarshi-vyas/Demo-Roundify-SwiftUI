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
    @State var isGetOtp: Bool = false
    @State var isVerifyClicked: Bool = false
    @State private var isMobile: Bool = true
    @State private var isUserId: Bool = true
    @FocusState private var isInputActive
    @State private var isOtpEntered:Bool = false
    @State private var receivedOtp:String = ""
    @State private var showAlert = false
    @EnvironmentObject var router: Router
    @StateObject var validationsModel = Validations()
    private let toast = ToastManager.shared
    @StateObject var viewModel = SignupViewModel()
    
    
//    var body: some View {
//        
//        VStack {
//
//            HeaderviewAuthentication()
//            
//            ScrollView {
//                
//                VStack(spacing: 10) {
//                    
//                    Spacer()
//                        .frame(height: 10)
//                    
//                    Text("Forgot User ID or Password?")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                    
//                    Text("Fill up the below details to get Forgot user ID or Password to your account.")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                    
//                }
//                
//                VStack(spacing:15){
//                    
//                    Spacer()
//                        .frame(height:10)
//                    
//                    HStack {
//                        Text("Choose")
//                            .padding(.leading,15)
//                            .font(.subheadline)
//                        
//                        Spacer()
//                        
//                    }
//                    
//                    CustomSegmentControl(
//                        items: forgotTypes,
//                        itemLabel: { $0 },
//                        selection: $selectedType,
//                        backgroundColor: Color.gray.opacity(0.1),
//                        selectedBackgroundColor: .customBlue,
//                        selectedTextColor: .white,
//                        unselectedTextColor: .primary,
//                        onSelectionChange: { tab in
//                            if tab == "Forgot Password" {
//                                isUserId = true
//                            } else {
//                                isUserId = false
//                            }
//                            
//                        }
//                    ).padding(.horizontal, 20)
//                    
//                    
//                    if isUserId {
//                        
//                        CustomTextfield(title: "UserID", placeholder: "Enter your userID", text: $txtUserId) .focused($isInputActive)
//                            .autocapitalization(.allCharacters)
//                    }
//                    
//                    
//                    HStack {
//                        Text("Verify")
//                            .font(.subheadline)
//                            .padding(.horizontal)
//                        
//                        Spacer()
//                        
//                    }
//                    
//                    HStack {
//                        CustomSegmentControlwithHW(
//                            items: verifyTypes,
//                            itemLabel: { $0 },
//                            selection: $selectedVerifyType,
//                            backgroundColor: Color.gray.opacity(0.1),
//                            selectedBackgroundColor: .customBlue,
//                            selectedTextColor: .white,
//                            unselectedTextColor: .primary,
//                            width: 150,
//                            segmentHeight:20,
//                            onSelectionChange: { tab in
//                                if tab == "Mobile" {
//                                    isMobile = true
//                                } else {
//                                    isMobile = false
//                                }
//                                
//                            }
//                        ).padding(.horizontal)
//                        
//                        
//                        Spacer()
//                    }
//                    
//                    Group {
//                        if isMobile {
//                            PhoneTextField(textPhone: $txtPhone, isVerifyClicked: $isVerifyClicked) .focused($isInputActive)
//                        } else {
//                            EmailTextField(textEmail: $txtEmail, otpviewOpened: $isVerifyClicked) .focused($isInputActive)
//                        }
//                    }
//                    
//                    isOtpOpen ? customOTPView(isOtpEntered: $isOtpEntered, receivedOTP:$receivedOtp).focused($isInputActive) : nil
//                    
//                    
//                    Button("Continue") {
//                        if isUserId {
//                            if isMobile {
//                                getUseridRequest()
//                            }
//                        } else {
//                            router.navigate(to: .resetPassword(userid: txtUserId, phone: txtPhone))
//                        }
//                    }.frame(maxWidth: .infinity)
//                        .frame(height: 40)
//                        .background(viewModel.isOTPVerified ? .customBlue : .customBlue.opacity(0.3))
//                        .foregroundColor(.white)
//                        .cornerRadius(5)
//                        .padding(15)
//                        .font(Font.system(size: 16, weight: .semibold))
//                        .disabled(!viewModel.isOTPVerified)
//                        
//                    Button("BACK TO LOGIN"){
//                     
//                     router.navigateToRoot()
//                        
//                    }.underline()
//                     .font(Font.system(size: 14, weight: .semibold))
//                     .foregroundColor(Color.customBlue)
//                    
//                }
//                
//                Spacer()
//                
//            }.frame(maxWidth: .infinity,maxHeight:.infinity)
//                .background(Color.white)
//                .cornerRadius(20)
//            
//        }.onTapGesture {
//            isInputActive = false
//        }.navigationBarBackButtonHidden(true)
//            .onChange(of: isVerifyClicked) {
//                    isGetOtp = checkValidation()
//            }
//            .onChange(of: isOtpEntered) {
//                if isOtpEntered {
//                    let parameters: [String: Any] = [
//                        "user": ["phoneNumber":"+91" + txtPhone],
//                        "code": receivedOtp
//                    ]
//                    
//                    viewModel.verifyOTPRequest(params: parameters)
//                    
//                }
//                
//            }
//            .onChange(of: isGetOtp) {
//                if isGetOtp {
//                    let number = "+91" + txtPhone
//                    let params = ["phoneNumber":number]
//                    viewModel.getOTPRequest(params: params)
//                }
//            }
//            .onChange(of: viewModel.isOTPReceived) { oldValue, newValue in
//                if newValue {
//                   isOtpOpen = true
//                }
//            }
//            .onChange(of: viewModel.isUseridReceived) { oldValue, newValue in
//                if newValue {
//                    showAlert = true
//                }
//            }
//            .alert("Save this as your UserID", isPresented: $showAlert) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text(viewModel.userId!)
//            }
//        
//    }
    
    // MARK: - Button Color

    private var continueButtonColor: Color {
        viewModel.isOTPVerified ? Color.customBlue : Color.customBlue.opacity(0.3)
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 10)
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
    }

    private var chooseLabel: some View {
        HStack {
            Text("Choose")
                .padding(.leading, 15)
                .font(.subheadline)
            Spacer()
        }
    }

    private var chooseSegmentControl: some View {
        CustomSegmentControl(
            items: forgotTypes,
            itemLabel: { $0 },
            selection: $selectedType,
            backgroundColor: Color.gray.opacity(0.1),
            selectedBackgroundColor: .customBlue,
            selectedTextColor: .white,
            unselectedTextColor: .primary,
            onSelectionChange: { tab in
                if tab == "Forgot Password" {
                    isUserId = true
                } else {
                    isUserId = false
                }
            }
        )
        .padding(.horizontal, 20)
    }

    private var userIdField: some View {
        Group {
            if isUserId {
                CustomTextfield(title: "UserID", placeholder: "Enter your userID", text: $txtUserId)
                    .focused($isInputActive)
                    .autocapitalization(.allCharacters)
            }
        }
    }

    private var verifyLabel: some View {
        HStack {
            Text("Verify")
                .font(.subheadline)
                .padding(.horizontal)
            Spacer()
        }
    }

    private var verifySegmentControl: some View {
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
                segmentHeight: 20,
                onSelectionChange: { tab in
                    isMobile = (tab == "Mobile")
                }
            )
            .padding(.horizontal)
            Spacer()
        }
    }

    private var inputField: some View {
        Group {
            if isMobile {
                PhoneTextField(textPhone: $txtPhone, isVerifyClicked: $isVerifyClicked)
                    .focused($isInputActive)
            } else {
                EmailTextField(textEmail: $txtEmail, otpviewOpened: $isVerifyClicked)
                    .focused($isInputActive)
            }
        }
    }

    private var otpField: some View {
        Group {
            if isOtpOpen {
                customOTPView(isOtpEntered: $isOtpEntered, receivedOTP: $receivedOtp)
                    .focused($isInputActive)
            }
        }
    }

    private var continueButton: some View {
        Button("Continue") {
            if !isUserId {
                if isMobile {
                    getUseridRequest()
                }
            } else {
                router.navigate(to: .resetPassword(userid: txtUserId, phone: txtPhone))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(continueButtonColor)
        .foregroundColor(.white)
        .cornerRadius(5)
        .padding(15)
        .font(Font.system(size: 16, weight: .semibold))
        .disabled(!viewModel.isOTPVerified)
    }

    private var backToLoginButton: some View {
        Button("BACK TO LOGIN") {
            router.navigateToRoot()
        }
        .underline()
        .font(Font.system(size: 14, weight: .semibold))
        .foregroundColor(Color.customBlue)
    }

    private var scrollContent: some View {
        VStack(spacing: 15) {
            headerSection
            Spacer().frame(height: 10)
            chooseLabel
            chooseSegmentControl
            userIdField
            verifyLabel
            verifySegmentControl
            inputField
            otpField
            continueButton
            backToLoginButton
            Spacer()
        }
    }

    // MARK: - onChange Handlers (extracted to reduce body complexity)

    private var mainContent: some View {
        VStack {
            HeaderviewAuthentication()
            ScrollView {
                scrollContent
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
        }
        .onTapGesture {
            isInputActive = false
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Body

    var body: some View {
        mainContent
            .onChange(of: isVerifyClicked) {
                isGetOtp = checkValidation()
            }
            .onChange(of: isOtpEntered) {
                if isOtpEntered {
                    let parameters: [String: Any] = [
                        "user": ["phoneNumber": "+91" + txtPhone],
                        "code": receivedOtp
                    ]
                    viewModel.verifyOTPRequest(params: parameters)
                }
            }
            .onChange(of: isGetOtp) {
                if isGetOtp {
                    let number = "+91" + txtPhone
                    let params = ["phoneNumber": number]
                    viewModel.getOTPRequest(params: params)
                }
            }
            .onChange(of: viewModel.isOTPReceived) { oldValue, newValue in
                if newValue {
                    isOtpOpen = true
                }
            }
            .onChange(of: viewModel.isUseridReceived) { oldValue, newValue in
                if newValue {
                    showAlert = true
                }
            }
            .alert("Save this as your UserID", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.userid)
            }
    }
    

    private func checkValidation() -> Bool {
        
        let validEmailError = validationsModel.validateEmail(txtEmail)
        let validMobileError = validationsModel.validateMobileNumber(txtPhone)
        
        if  isUserId {
            
            let validUserIdError = validationsModel.validateUserId(txtUserId)
            
            if validUserIdError == nil {
                
                if isMobile {
                    
                    if validMobileError == nil {
                        
                        return true
                    }else {
                        
                        toast.show(message:validMobileError! , style:.error)
                        
                        return false
                        
                    }
                } else {
                    
                    if validEmailError == nil {
                        
                        return true
                        
                    } else {
                        
                        toast.show(message:validEmailError!, style:.error)
                        
                        return false
                    }
                    
                }
                
            } else {
                
                toast.show(message:validUserIdError!, style:.error)
                
                return false
            }
            
        } else {
            
            if isMobile {
                
                if validMobileError == nil {
                    
                    return true
                }else {
                    
                    toast.show(message:validMobileError! , style:.error)
                    
                    return false
                    
                }
            } else {
                
                if validEmailError == nil {
                    
                    return true
                    
                } else {
                    
                    toast.show(message:validEmailError!, style:.error)
                    
                    return false
                }
                
            }
            
        }
    }
    
    
    private func getUseridRequest() {
        
        let parameters: [String: Any] = [
            "PhoneNumber": "+91" + txtPhone]
        
        viewModel.getUseridRequest(params: parameters)
        
    }
    
}

#Preview {
    ForgetPasswordView()
}
