//
//  SignatureValidation.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 17/02/26.
//

import Foundation


class SignatureValidation {
    
    // Shared instance
    static let shared = SignatureValidation()
    
    // Private initializer to prevent instantiation from outside
    private init() {}
    
    let publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwlSSrAigtbxBb1BX7cM7OmbU0NLSGYhdjXAB1YL0Y9y8iz9UDMEi47MPMwfe96Pym8taKFctI4BG+fJolrW8afIxym4ucJcFx0OzhU1YDvnYsHaApOLF9coA7ufpxh0Yy0Uytr7eN1yMo3yqbQHxgx8Jh6bMHzmcBKH7ZPif9jGx6IVsUinT6UAOPmxw05CQP20yQ1Izv0MULtFSY8hoUMNxCg4mdTnQ5vVKLy2O4U5WVew+lmaUcBB+nq9ctCNL5xRcik03Vug+lWW2MsVFoAnnJhDXotW/RjNTQ/JZuj62UXQdswztYVGjUopsHzs/d9dt4gWjEGsZhlEIwsHDbwIDAQAB"
    
    
    func generaliseSignatureValidation(jsonstring:String,sign:String) -> Bool {
        
        let jsonBytesArray = Array(jsonstring.utf8)
        let jsonDataArray = Data(jsonBytesArray)
        
        let publicKey = SignatureValidation.shared.publicKey
        
        let isValid = SignatureValidation.shared.validateSignature(publicKey: publicKey, data: jsonDataArray, signature: sign)
        
        return isValid
    }
    
    func validateSignature(publicKey: String, data: Data, signature: String) -> Bool {
        
        // public key string to Dataguard
        guard let keyData = Data(base64Encoded: publicKey) else { fatalError("Invalid base64 string for public key") }
        
        
        guard let publicKeyxx = getPublicKey(from: keyData) else {
            fatalError("Failed to generate public key")
        }
        
        guard let signatureData = decodeSignature(signature) else {
            print("Failed to decode base64 signature")
            return false
        }
        
        // Create a signature verification request
        let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA256
        
        // Verify the signature
        var error: Unmanaged<CFError>?
        let isValid = SecKeyVerifySignature(publicKeyxx, algorithm,data as CFData, signatureData as CFData, &error)
        
        if let error = error?.takeRetainedValue() {
            print("Signature verification failed: \(error.localizedDescription)")
        }
        
        return isValid
    }
    
    func getPublicKey(from keyData: Data) -> SecKey? {
        let keyDict: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 2048,
            kSecReturnPersistentRef as String: true
        ]
        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error) else {
            print("Error creating public key: \(error!.takeRetainedValue() as Error)")
            return nil
        }
        return publicKey
    }
    
    
    func decodeSignature(_ signature: String) -> Data? {
        var modifiedSignature = signature.replacingOccurrences(of: "-", with: "+")
        modifiedSignature = modifiedSignature.replacingOccurrences(of: "_", with: "/")
        modifiedSignature = modifiedSignature.replacingOccurrences(of: "=", with: "=")
        return Data(base64Encoded: modifiedSignature)
    }
    
    
    func manualCommonJSONBuilder(responseData: CommonResponseData) -> String {
        return """
{"status":\(responseData.status),"message":"\(responseData.message)","data":"\(responseData.data)"}
"""}

}

// MARK: - ResponseData
class CommonResponseData: Codable {
    let status: Int
    let message: String
    let data: String

    init(status: Int, message: String, data: String) {
        self.status = status
        self.message = message
        self.data = data
    }

}
