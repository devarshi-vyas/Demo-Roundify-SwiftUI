//
//  LoginViewModel.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 09/01/26.
//

import Foundation
import SwiftUI
import Combine
import Alamofire

// MARK: - ViewModel
@MainActor
class LoginViewModel: ObservableObject {
    @Published var loginData: LoginData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccess = false
    @Published var isDeviceIdSucess: Bool = false
    @Published var deviceId: String?
    
    
    private let apiService = ApiServiceManager.shared
    
    func login(params: [String: Any]) {
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        // Replace "/login" with your actual login endpoint path
        apiService.postData(forPath: "9000/users/login", parameters: params) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let json):
                    print("✅ Login Response: \(json)")
                    
                    // Parse the response
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let decoder = JSONDecoder()
                        let loginResponse = try decoder.decode(LoginData.self, from: jsonData)
                        
                        self.loginData = loginResponse
                        
                        // Check if login was successful
                        if loginResponse.responseData.status == 200 {
                            self.isSuccess = true
                            
                            // Save token and user data
                            if let token = loginResponse.responseData.data.token {
                                UserDefaults.standard.set(token, forKey: "authToken")
                            }
                            
                            if let refreshToken = loginResponse.responseData.data.refreshToken {
                                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                            }
                            
                            if let userID = loginResponse.responseData.data.userID {
                                UserDefaults.standard.set(userID, forKey: "userID")
                            }
                            
                            if let email = loginResponse.responseData.data.email {
                                UserDefaults.standard.set(email, forKey: "userEmail")
                            }
                            
                            if let name = loginResponse.responseData.data.name {
                                UserDefaults.standard.set(name, forKey: "userName")
                            }
                            
                        } else {
                            self.errorMessage = loginResponse.responseData.message
                        }
                        
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        self.errorMessage = "Failed to parse response. Please try again."
                    }
                    
                case .failure(let error):
                    switch error {
                    case .networkError(let afError, _):
                        print("❌ Network Error: \(afError)")
                        self.errorMessage = "Login failed. Please check your credentials and try again."
                    case .invalidData:
                        print("❌ Invalid Data")
                        self.errorMessage = "Invalid response from server. Please try again."
                    }
                }
            }
        }
    }
    
    
    func getDeviceID() {
        let path = "9000/users/generateDeviceID"
        apiService.getData(forPath: path) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? [String: Any]
                    let deviceid = data?["DeviceID"] as? String
                    
                    self?.isDeviceIdSucess = true
                    
                    self?.deviceId = deviceid
                    
                }
                
            case .failure(let error):
              // self?.handleFailureResponse(error: error)
                switch error {
                case .networkError(let afError, _):
                    print("❌ Network Error: \(afError)")
                    self?.errorMessage = "Error fetching deviceId. Please try again."
                case .invalidData:
                    print("❌ Invalid Data")
                    self?.errorMessage = "Invalid response from server. Please try again."
                }
            }
        }
    }

}
