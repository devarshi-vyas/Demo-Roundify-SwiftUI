//
//  SignupViewModel.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 18/02/26.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

@MainActor
class SignupViewModel:ObservableObject {
    
    @Published var isUserVerified:Bool = false
    @Published var isOTPReceived:Bool = false
    @Published var isOTPVerified:Bool = false
    @Published var isUseridReceived:Bool = false
    @Published var userid:String = ""
    
    private let toast = ToastManager.shared
    private let apiService = ApiServiceManager.shared
   
    func verifyUser(params:[String:Any]) {
        let path = "/users/verifyUser"
       
        apiService.postData(forPath: path, parameters: params) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    let statuscode = responseData?["status"] as? Int
                    
                    if statuscode == 200 {
                        self?.isUserVerified = true
                        self?.toast.show(message: data ?? "", style: .success)
                        
                    }else {
                        self?.isUserVerified = false
                        
                        self?.toast.show(message: data ?? "", style: .error)
                        
                    }
                    
                }
                
            case .failure(let error):
              // self?.handleFailureResponse(error: error)
                switch error {
                case .networkError(let afError, let json):
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                   
                case .invalidData:
                    print("❌ Invalid Data")
                  
                }
            }
        }
    }

   
    func getOTPRequest(params:[String:Any]) {
       
        let path = "/otp"

        apiService.postData(forPath: path, parameters: params){ [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    self?.toast.show(message: data ?? "", style:.success)
                }
               
                self?.isOTPReceived = true
                
            case .failure(let error):
                
                switch error {
                case .networkError(let afError, let json):
                    
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                    
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.toast.show(message:"Invalid Data", style:.error)
                    
                }
                
            }
        }
    }
    
    
    func verifyOTPRequest(params:[String:Any]) {
        
        let path = "/verifyOTP"
        
        apiService.postData(forPath: path, parameters:params) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    
                    self?.toast.show(message: data ?? "", style:.success)
                }
                
                self?.isOTPVerified = true
                
            case .failure(let error):
                switch error {
                case .networkError(let afError, let json):
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                    
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.toast.show(message:"Invalid Data", style:.error)
                    
                }
                
            }
        }
    }
    
    
    func signUpRequest(params:[String:Any]) {
        
        apiService.postData(forPath: "/users/signup", parameters:params) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    
                    self?.toast.show(message: data ?? "", style:.success)
                }
                
                
            case .failure(let error):
                switch error {
                case .networkError(let afError, let json):
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                   
                    
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.toast.show(message:"Invalid Data", style:.error)
                    
                }
               
            }
        }
    }
    
    func resetPasswordRequest(params:[String:Any]) {
        
        apiService.postData(forPath: "/users/forgotPassword", parameters:params) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    
                    self?.toast.show(message: data ?? "", style:.success)
                }
                
                
            case .failure(let error):
                switch error {
                case .networkError(let afError,let json):
                    
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                    
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.toast.show(message:"Invalid Data", style:.error)
                    
                }
               
            }
        }
    }
    
    
    func getUseridRequest(params:[String:Any]) {
        
        apiService.postData(forPath: "/users/forgotUserID", parameters:params) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? String
                    
                    self?.userid = data ?? ""
                    
                    self?.toast.show(message: data ?? "", style:.success)
                    
                    self?.isUseridReceived = true
                }
                
                
            case .failure(let error):
                switch error {
                case .networkError(let afError,let json):
                    
                    if let json = json as? [String: Any]{
                        
                        let responseData = json["ResponseData"] as? [String: Any]
                        let data = responseData?["data"] as? String
                        
                        self?.toast.show(message: data ?? "", style:.error)
                    }
                    
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.toast.show(message:"Invalid Data", style:.error)
                    
                }
               
            }
        }
    }
}
