//
//  APIConstants.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 16/02/26.
//

import Foundation


struct APIConstants {
    
    // PORT: 8000
    struct AuthenticationServices {
        
        static let GETOTP = "/otp"
        static let VERIFYOTP = "/verifyOTP"
        static let AuthenticationEndpoints = [GETOTP,VERIFYOTP]
    }
    
    // PORT: 9000
    struct ManagementServices {
        static let SIGNUP = "/users/signup"
        static let LOGIN = "/users/login"
        static let LOGINOTP = "/users/login/otp"
        static let VERIFYUSER = "/users/verifyUser"
        static let FORGOTUSERID = "/users/forgotUserID"
        static let FORGOTPASSWORD = "/users/forgotPassword"
        static let REFRESHTOKEN = "/users/refreshToken"
        static let UPDATEPHONENUMBER = "/users/updatePhoneNumber"
        static let UPDATEEMAIL = "/users/updateEmail"
        static let ADDADDRESS =  "/users/addAddress"
        static let UPDATEADDRESS = "/users/updateAddress"
        static let GETADDRESS = "/users/getAddresses"
        static let DELETEADDRESS = "/users/deleteAddress"
        static let CHANGEPRIMARYADDRESS = "/users/changePrimaryAddress"
        static let VERIFYPAN = "/users/verifyPAN"
        static let TOGGLEBIOMETRICS = "/users/trustedDevice/toggleBiometrics"
        static let GETPROFILE = "/users/"
        static let LOGOUT = "/users/logout"
        
     
        /// Computed property for GETPROFILE to always get the latest userID
//            static var GETPROFILE: String {
//                let userID = CredentialManager.shared.getUserID() ?? ""
//                return "/users/\(userID)"
//            }
        
        static let ManagementEndpoints = [SIGNUP,LOGIN,VERIFYUSER,FORGOTUSERID,FORGOTPASSWORD,REFRESHTOKEN,UPDATEPHONENUMBER,UPDATEEMAIL,ADDADDRESS,UPDATEADDRESS,GETADDRESS,DELETEADDRESS,CHANGEPRIMARYADDRESS,VERIFYPAN,GETPROFILE,LOGINOTP,TOGGLEBIOMETRICS,LOGOUT]
        
    }
    
    
    // PORT: 8999
    
    struct TransactionServices {
        
        static let GETMUTUALFUND = "/accounts/getSecurities/mutualfund"
        static let STARTSIP =    "/transactions/invest/sipMF"
       
        static let MODIFYSIP = "/transactions/sip/modify"
        static let DELETESIP =  "/transactions/sip/cancel"
        static let GETTRANSACTION = "/transactions/GetTransaction/:user_id".replacingOccurrences(of: ":user_id", with: CredentialManager.shared.getUserID() ?? "")
        static let GETSIPDETAILS =  "/sips/GetSipDetails/:user_id".replacingOccurrences(of: ":user_id", with: CredentialManager.shared.getUserID() ?? "")
        
        
        static var GETWATCHLIST: String {
            let userID = CredentialManager.shared.getUserID() ?? ""
            return "/watchlist/\(userID)"
        }
        
        static let TOGGLEWATCHLIST = "/watchlist/toggle"
        static let GETFUNDDETAILS = "/getSecurities/full-details"
        static var GETINVESTEMENT: String {
            let userID = CredentialManager.shared.getUserID() ?? ""
            return  "/investments/user/\(userID)"
        }
       
        static var GETPORTFOLIO: String {
            let userID = CredentialManager.shared.getUserID() ?? ""
            return  "/portfolios/GetUserPortfolio/\(userID)"
        }
        
        static let GETDIGITALGOLD = "/accounts/getSecurities/digitalgold"
        
        static let STARTGOLDSIP = "/transactions/invest/sipDG"
        
        static let TransactionEndpoints = [GETMUTUALFUND,STARTSIP,DELETESIP,MODIFYSIP,GETTRANSACTION,GETSIPDETAILS,GETWATCHLIST,TOGGLEWATCHLIST,GETFUNDDETAILS,GETINVESTEMENT,GETPORTFOLIO,GETDIGITALGOLD,STARTGOLDSIP]
    }
    
}
