//
//  Untitled.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 27/03/26.
//

import Foundation
import SwiftUI
import Combine
import Alamofire


class ProfileViewModel: ObservableObject {
    
    
    private let toast = ToastManager.shared
    
    private let apiService = ApiServiceManager.shared
    
    
    func getProfileData() {
        let path = "/users/:userID"
        let userID = CredentialManager.shared.getUserID() ?? ""
        let fullPath = path.replacingOccurrences(of: ":userID", with: userID)
        
        apiService.getData(forPath: fullPath) { [weak self] result in
            switch result {
            case .success(let json):
                if let json = json as? [String: Any]{
                    
                    let responseData = json["ResponseData"] as? [String: Any]
                    let data = responseData?["data"] as? [String: Any]
                   
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
