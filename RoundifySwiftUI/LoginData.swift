//
//  LoginData.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 06/01/26.
//

import Foundation


// MARK: - LoginData
class LoginData: Codable {
    let responseData: LoginResponseData
    let signature: String?  // Optional to handle its absence in some responses

    enum CodingKeys: String, CodingKey {
        case responseData = "ResponseData"
        case signature = "Signature"
    }

    init(responseData: LoginResponseData, signature: String) {
        self.responseData = responseData
        self.signature = signature
    }

}

// MARK: - ResponseData
class LoginResponseData: Codable {
    let status: Int
    let message: String
    let data: LoginUserData

    init(status: Int, message: String, data: LoginUserData) {
        self.status = status
        self.message = message
        self.data = data
    }

}

// MARK: - DataClass
class LoginUserData: Codable {
    let userID, name, email, token: String?
    let refreshToken: String?
    let isNewDevice:Bool?

    enum CodingKeys: String,CodingKey {
        case userID = "UserID"
        case name = "Name"
        case email = "Email"
        case token = "Token"
        case refreshToken = "RefreshToken"
        case isNewDevice = "IsNewDevice"
    }

    init(userID: String?, name: String?, email: String?, token: String?, refreshToken: String?, isNewDevice:Bool?) {
        self.userID = userID
        self.name = name
        self.email = email
        self.token = token
        self.refreshToken = refreshToken
        self.isNewDevice = isNewDevice
    }

}
