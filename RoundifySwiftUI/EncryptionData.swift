//
//  EncryptionData.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 17/02/26.
//

import Foundation
import Foundation
import CryptoKit


class EncryptionData {
    
    // Shared instance
    static let shared = EncryptionData()
    
    // Private initializer to prevent instantiation from outside
    private init() {}
    
   
    private func publicKeyData() -> SecKey? {
        let publicKeyBase64 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwlSSrAigtbxBb1BX7cM7OmbU0NLSGYhdjXAB1YL0Y9y8iz9UDMEi47MPMwfe96Pym8taKFctI4BG+fJolrW8afIxym4ucJcFx0OzhU1YDvnYsHaApOLF9coA7ufpxh0Yy0Uytr7eN1yMo3yqbQHxgx8Jh6bMHzmcBKH7ZPif9jGx6IVsUinT6UAOPmxw05CQP20yQ1Izv0MULtFSY8hoUMNxCg4mdTnQ5vVKLy2O4U5WVew+lmaUcBB+nq9ctCNL5xRcik03Vug+lWW2MsVFoAnnJhDXotW/RjNTQ/JZuj62UXQdswztYVGjUopsHzs/d9dt4gWjEGsZhlEIwsHDbwIDAQAB"
        
        // Decode the Base64 public key string into Data
        guard let publicKeyData = Data(base64Encoded: publicKeyBase64) else {
            print("Failed to decode base64 public key")
            return nil
        }
        
        // Use getPublicKeyFromBytes to load the public key
        if let publicKey = getPublicKeyFromBytes(publicKeyData) {
            print("Public key loaded successfully: \(publicKey)")
            return publicKey
        } else {
            print("Failed to load public key")
            return nil
        }
    }
    
    func getPublicKeyFromBytes(_ publicKeyBytes: Data) -> SecKey? {
        let keyDict: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048,
            kSecAttrIsPermanent as String: false
        ]
        
        let publicKey = SecKeyCreateWithData(publicKeyBytes as CFData, keyDict as CFDictionary, nil)
        return publicKey
    }
    
    
    func encryptData(publicKey: SecKey, data: String) -> String? {
        guard let dataToEncrypt = data.data(using: .utf8) else {
            print("Failed to convert string to data")
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256
        
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            print("Algorithm not supported for the provided public key")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, algorithm, dataToEncrypt as CFData, &error) as Data? else {
            print("Encryption failed: \(error!.takeRetainedValue() as Error)")
            return nil
        }
        
        
        return base64URLEncodingEncode(data: encryptedData)
        
    }

    
    func base64URLEncodingEncode(data: Data) -> String {
        // Standard Base64 encoding with padding
        let base64String = data.base64EncodedString()
        
        // Replace characters for URL-safe encoding
        let urlEncodedString = base64String
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "=")
           
        return urlEncodedString
    }
    
    
    func paramEncryption(params: [String: Any]) -> String? {
        // Convert dictionary to JSON string
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            // Assuming you have your publicKey loaded already
            if let publicKey = publicKeyData() {
                if let encryptedString = encryptData(publicKey: publicKey, data: jsonString) {
                    print("Encrypted Data: \(encryptedString)")
                    return encryptedString
                } else {
                    print("Failed to encrypt data")
                }
            } else {
                print("Failed to load public key")
            }
        } else {
            print("Failed to serialize JSON")
        }
        return nil
    }
    
    
    func paramAESEncryption(params:String) -> String? {
        
        // Assuming you have your publicKey loaded already
        if let publicKey = publicKeyData() {
            if let encryptedString = encryptData(publicKey: publicKey, data: params) {
                print("Encrypted AES Key: \(encryptedString)")
                return encryptedString
            } else {
                print("Failed to encrypt AES Key")
            }
        } else {
            print("Failed to load public key")
        }
        
        return nil
    }
    
   
    
    func encryptDataWithAES(data: [String: Any]) -> (String?, String?, Error?) {
        // Convert the dictionary to JSON Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return (nil, nil, NSError(domain: "EncryptionError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize dictionary to JSON"]))
        }
        // Generate a random AES key (256-bit)
        let aesKey = SymmetricKey(size: .bits256)
        // Generate a random nonce
        guard let nonce = try? AES.GCM.Nonce() else {
            return (nil, nil, NSError(domain: "EncryptionError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to generate nonce"]))
        }
        do {
            // Encrypt the JSON data using AES-GCM
            let sealedBox = try AES.GCM.seal(jsonData, using: aesKey, nonce: nonce)
            // Convert nonce to Data
            let nonceData = Data(nonce)
            // Combine nonce, ciphertext, and tag
            let encryptedDataWithNonce = nonceData + sealedBox.ciphertext + sealedBox.tag
            //            // Encode the encrypted data and AES key using Base64
            //            let encryptedDataString = encryptedDataWithNonce.base64EncodedString()
            //            let aesKeyString = aesKey.withUnsafeBytes { Data($0).base64EncodedString() }
            
            let encryptedDataString = base64URLEncodingEncode(data:encryptedDataWithNonce)
            
            let aesKeyString = base64URLEncodingEncode(data:  Data(aesKey.withUnsafeBytes { Data($0) }))
            
            return (encryptedDataString, aesKeyString, nil)
        } catch {
            return (nil, nil, error)
        }
    }

}
