//
//  ApiServiceManager.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 08/01/26.
//
import Foundation
import Alamofire

// MARK: - API Service Manager
class ApiServiceManager {
    
    static let shared = ApiServiceManager()
    private init() {}
    private var port:Int?
    fileprivate var finalstring:String?
    
    enum Environment {
        case LOCAL
        case QA
        case PRODUCTION
        case DEV
    }
    
    private var environment: Environment?
    private var isEncryptionActive = true
    
    
    func isEndpointInManagementServices(_ endpoint: String) -> Bool {
        return APIConstants.ManagementServices.ManagementEndpoints.contains { prefix in
            endpoint.hasPrefix(prefix)
        }
    }
    
    func isEndpointAuthenticationServices(_ endpoint: String) -> Bool {
        return APIConstants.AuthenticationServices.AuthenticationEndpoints.contains(endpoint)
    }
    
    func isEndpointTransactionServices(_ endpoint: String) -> Bool {
        return APIConstants.TransactionServices.TransactionEndpoints.contains(endpoint)
    }
    
    
    func getPort(path:String) -> Int {
        if isEndpointInManagementServices(path) {
            port = 9000
        }
        else if isEndpointAuthenticationServices(path){
            port = 8000
        }else if isEndpointTransactionServices(path){
            port = 8999
        }
        return port!
    }
    
    
    func endpoint(forPath path: String, port: Int) -> URL {
        let baseURLString: String
        var urlComponents: URLComponents?
        
        environment = .DEV
        
        switch environment {
        case .LOCAL:
            baseURLString = "http://localhost:"
            urlComponents = URLComponents(string: baseURLString)!
            urlComponents?.port = port
        case .DEV:
            baseURLString = "http://13.203.236.15:"
            urlComponents = URLComponents(string: baseURLString)!
            urlComponents?.port = port
        case .PRODUCTION:
            baseURLString = "http://13.203.236.15:"
            urlComponents = URLComponents(string: baseURLString)!
            // No port for production
        case .QA:
            baseURLString = "http://13.203.236.15:"
            urlComponents = URLComponents(string: baseURLString)!
            urlComponents?.port = port
        case .none:
            break
        }
        
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            fatalError("Failed to construct URL")
        }
        
        return url
    }
    
    
    
    // MARK: - Network Error
    enum NetworkError: Error {
        case networkError(Error, [String: Any]?)
        case invalidData
    }
    
    // MARK: POST Request with Parameters
    func postData(forPath path: String, parameters: [String: Any], completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        request(method: .post, path: path, parameters: parameters, completion: completion)
    }
    
    // MARK: GET Request
    func getData(forPath path: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        request(method: .get, path: path, parameters: nil, completion: completion)
    }
    
    // MARK: - Shared Request Handler
    private func request(method: HTTPMethod, path: String, parameters: [String: Any]?, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        //  let fullURL = baseURL + path
        
        let fullURL = endpoint(forPath: path, port: getPort(path:path))
        
        print("URL: \(fullURL)")
        
        var params:[String: Any] = parameters ?? [:]
        
        if let parameters {
            print("Request Parameters: \(parameters)")
            if (isEncryptionActive){
                
                let (encryptedData, aesKey, error) = EncryptionData.shared.encryptDataWithAES(data:parameters)
                
                let encryptedAesKey = EncryptionData.shared.paramAESEncryption(params:aesKey ?? "")
                let encryptedParams = ["EncryptedData":encryptedData,"EncryptedKey":encryptedAesKey]
                
                print("encryptedParams:\(encryptedParams)")
                
                params = encryptedParams as [String : Any]
                
            }
            
        }
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        
        AF.request(fullURL, method: method, parameters: params, encoding: encoding)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if(self.isEncryptionActive) {
                            let dataString = self.convertToJsonstring(data: data)
                            
                            if let signature = jsonObject["Signature"] as? String {
                                print("signature as String: \(signature)")
                                
                                let isValid = SignatureValidation.shared.generaliseSignatureValidation(jsonstring: dataString, sign: signature)
                                
                                print(isValid)
                                
                            }
                        }
                        
                        print("✅ API Response: \(jsonObject)")
                        
                        completion(.success(jsonObject))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure(let error):
                    
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if (self.isEncryptionActive){
                            let signature = json["Signature"] as? String
                            let dataString = self.convertToJsonstring(data: data)
                            let isValid = SignatureValidation.shared.generaliseSignatureValidation(jsonstring: dataString, sign: signature!)
                            print(isValid)
                        }
                        print("❌ API Error: \(error)")
                        
                        completion(.failure(.networkError(error, json)))
                    }
                }
            }
    }
    
}

// MARK: Converting JSONResponce to JSONString Methods
extension ApiServiceManager {
    
    func convertToJsonstring(data:Data) -> String {
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON: \(jsonString)")
            
            // Find the start of "ResponseData"
            if let range = jsonString.range(of: "ResponseData") {
                // Extract everything after the start of "ResponseData"
                let responseDataSubstring = jsonString[range.upperBound...]
                
                // Trim leading colon if it exists
                let trimmedResponseDataJson = responseDataSubstring.trimmingCharacters(in: .whitespacesAndNewlines)
                
                var finalResponseDataJson = trimmedResponseDataJson
                
                // Now remove the "Signature" field and everything after it
                if let signatureRange = finalResponseDataJson.range(of: "Signature") {
                    let responseDataWithoutSignature = finalResponseDataJson[..<signatureRange.lowerBound]
                    
                    let clearedString =             self.removeExtraCharacters(from:String(responseDataWithoutSignature))
                    
                    let cleanString = self.removeExtraQuotes(from: clearedString)
                    print("ResponseData without 'Signature': \(cleanString)")
                    finalstring = cleanString
                    
                } else {
                    // If no "Signature" key is found, print the response data as is
                    print("ResponseData without 'Signature': \(finalResponseDataJson)")
                }
            } else {
                print("Couldn't find 'ResponseData' in the JSON")
            }
        } else {
            print("Failed to convert data to string.")
        }
        
        return finalstring ?? ""
    }
    
    
    func removeExtraCharacters(from string: String) -> String {
        var cleanedString = string
        
        // Remove unwanted characters like trailing commas or colons outside the curly braces
     //   cleanedString = cleanedString.replacingOccurrences(of: ":{", with: "{")
        
        cleanedString = removeFirstOccurrence(of: ":{", with: "{", in: cleanedString)
       // cleanedString = cleanedString.replacingOccurrences(of: "},", with: "}")
        cleanedString = replaceLastOccurrence(of: "},", with: "}", in: cleanedString)
        
        // Optionally trim leading or trailing whitespace or newlines
        cleanedString = cleanedString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleanedString
    }
    
    func removeFirstOccurrence(of target: String, with replacement: String, in string: String) -> String {
        if let range = string.range(of: target) {
            var modifiedString = string
            modifiedString.replaceSubrange(range, with: replacement)
            return modifiedString
        }
        return string
    }
    
    func replaceLastOccurrence(of target: String, with replacement: String, in string: String) -> String {
        if let range = string.range(of: target, options: .backwards) {
            var modifiedString = string
            modifiedString.replaceSubrange(range, with: replacement)
            return modifiedString
        }
        return string
    }

    
    func removeExtraQuotes(from string: String) -> String {
        // Replace incorrect quotes pattern outside of brackets
        var cleanedString = string.replacingOccurrences(of: "\"{", with: "{")
        cleanedString = cleanedString.replacingOccurrences(of: "}\"", with: "}")
        
        return cleanedString
    }
    
}
