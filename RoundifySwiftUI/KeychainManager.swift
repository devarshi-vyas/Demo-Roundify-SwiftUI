//
//  KeychainManager.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 28/01/26.
//

import Foundation

class KeychainHelper {

    static let shared = KeychainHelper()

    private init() {}

    func save(service: String, account: String, value: String) {
            guard let data = value.data(using: .utf8) else { return }

            // Define the keychain query for delete
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account
            ]
            
            // Delete any existing item
            let deleteStatus = SecItemDelete(query as CFDictionary)
            print("Delete status: \(deleteStatus)") // Useful for debugging

            // Add the new item
            let addQuery: [String: Any] = query.merging([
                kSecValueData as String: data
            ]) { (_, new) in new }

            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            print("Add status: \(addStatus)") // Should be 0 if successful
        }
        
    
    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}


class DeviceUUIDManager {
    private let service = "com.Roundify.deviceUUIDService"
    private let account = "deviceID"

    static let shared = DeviceUUIDManager()

    private init() {}
    
    func getDeviceUUID() -> String {
        guard let existingUUID = KeychainHelper.shared.read(service: service, account: account) else { return "" }
            return existingUUID
    }
    
    func existingDeviceID() -> Bool {
        if let existingUUID = KeychainHelper.shared.read(service: service, account: account) {
            return true
        }else{
           return false
        }
        
    }
    
    func saveNewDeviceID(_ value: String) {
        KeychainHelper.shared.save(service: service, account: account, value: value)
    }

    func resetUUID() {
        KeychainHelper.shared.delete(service: service, account: account)
    }
}

class CredentialManager {
    private let service = "com.Roundify.credentialService"
    
    static let shared = CredentialManager()
    
    private init() {}

    private let emailAccount = "userEmail"
    private let passwordAccount = "userPassword"
    private let useridAccount = "userID"

    // MARK: - Email
    func getEmail() -> String? {
        return KeychainHelper.shared.read(service: service, account: emailAccount)
    }

    
    func setEmail(_ email: String?) {
        if let email = email {
            let existing = KeychainHelper.shared.read(service: service, account: emailAccount)
            if existing == nil {
                KeychainHelper.shared.save(service: service, account: emailAccount, value: email)
            }
        } else {
            KeychainHelper.shared.delete(service: service, account: emailAccount)
        }
    }

    // MARK: - Password
    func getPassword() -> String? {
        return KeychainHelper.shared.read(service: service, account: passwordAccount)
    }

    
    
    func setPassword(_ password: String?) {
        if let password = password {
            let existing = KeychainHelper.shared.read(service: service, account: passwordAccount)
            if existing == nil {
                KeychainHelper.shared.save(service: service, account: passwordAccount, value: password)
            }
        } else {
            KeychainHelper.shared.delete(service: service, account: passwordAccount)
        }
    }
    

    // MARK: - UserID
    func getUserID() -> String? {
        return KeychainHelper.shared.read(service: service, account: useridAccount)
    }
    
   
    func setUserID(_ userid: String?) {
        if let userid = userid {
            let existing = KeychainHelper.shared.read(service: service, account: useridAccount)
            if existing != userid {
                KeychainHelper.shared.save(service: service, account: useridAccount, value: userid)
            }
        } else {
            KeychainHelper.shared.delete(service: service, account: useridAccount)
        }
    }
    
    
    // Optional: clear all credentials
    func clearCredentials() {
        KeychainHelper.shared.delete(service: service, account: emailAccount)
        KeychainHelper.shared.delete(service: service, account: passwordAccount)
        KeychainHelper.shared.delete(service: service, account: useridAccount)
    }
    
}


class TokenManager {
    private let service = "com.Roundify.tokenService"

    static let shared = TokenManager()

    private init() {}

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    // MARK: - Access Token
    func getAccessToken() -> String? {
        return KeychainHelper.shared.read(service: service, account: accessTokenKey)
    }

    func setAccessToken(_ token: String?) {
        if let token = token {
            KeychainHelper.shared.save(service: service, account: accessTokenKey, value: token)
        } else {
            KeychainHelper.shared.delete(service: service, account: accessTokenKey)
        }
    }

    // MARK: - Refresh Token
    func getRefreshToken() -> String? {
        return KeychainHelper.shared.read(service: service, account: refreshTokenKey)
    }

    func setRefreshToken(_ token: String?) {
        if let token = token {
            KeychainHelper.shared.save(service: service, account: refreshTokenKey, value: token)
        } else {
            KeychainHelper.shared.delete(service: service, account: refreshTokenKey)
        }
    }

    // MARK: - Clear Tokens
    func clearTokens() {
        KeychainHelper.shared.delete(service: service, account: accessTokenKey)
        KeychainHelper.shared.delete(service: service, account: refreshTokenKey)
    }
}


