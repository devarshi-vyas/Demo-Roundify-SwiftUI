//
//  ApiServiceManager.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 08/01/26.
//
import SwiftUI
import SwiftData
import Foundation
import Alamofire

// MARK: - API Service Manager
class ApiServiceManager {
    
    static let shared = ApiServiceManager()
    private init() {}
    
    // MARK: - Network Error
    enum NetworkError: Error {
        case networkError(Error, [String: Any]?)
        case invalidData
    }
    
    // MARK: POST Request with Parameters
    func postData(forPath path: String, parameters: [String: Any], completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        let baseURL = "http://13.203.236.15:" // Replace with your actual base URL
        
        let fullURL = baseURL + path
        
        AF.request(fullURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("✅ API Response: \(jsonObject)")
                        completion(.success(jsonObject))
                        
                    } else {
                        completion(.failure(.invalidData))
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    completion(.failure(.networkError(error, nil)))
                }
            }
    }
    
    // MARK: GET Request
    func getData(forPath path: String, completion: @escaping (Result<[String: Any], NetworkError>) -> Void) {
        
        let baseURL = "http://13.203.236.15:" // Replace with your actual base URL
        
        let fullURL = baseURL + path
        
        AF.request(fullURL, method: .get)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("✅ API Response: \(jsonObject)")
                        completion(.success(jsonObject))
                        
                    } else {
                        completion(.failure(.invalidData))
                    }
                    
                case .failure(let error):
                    print("❌ API Error: \(error)")
                    completion(.failure(.networkError(error, nil)))
                }
            }
    }
    
    
}
