//
//  Validations.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 06/02/26.
//

import Foundation
import Combine


class Validations:ObservableObject {
 
    @Published var isValid:Bool = false
    @Published var emailError:String? = nil
    
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
    
    func isValidMobileNumber(_ number: String) -> Bool {
        let mobileNumberRegex = #"^\d{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex).evaluate(with: number)
    }
    
    func isValidIndianFullName(_ name: String) -> Bool {
        // Regular expression to match the criteria
        let regex = "^[a-zA-Z]+([ '-][a-zA-Z]+)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        // Check the length of the name
        let length = name.count
        if length < 2 || length > 50 {
            return false
        }
        
        // Check if the name starts or ends with a space
        if name.hasPrefix(" ") || name.hasSuffix(" ") {
            return false
        }
        
        // Validate the name using the regular expression
        return predicate.evaluate(with: name)
    }
    
    
    func isValidUserId(_ userId: String) -> Bool {
        let pattern = "^[A-Za-z]{3}[0-9]{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: userId)
    }
    
    
    
    func validateUserId(_ userId: String) -> String? {
        
        if userId.isEmpty {
            return "User ID is required"
        } else if !isValidUserId(userId) {
            return "Invalid User ID format"
        }
        
        return nil
    }
    
    
    func validateEmail(_ email: String) -> String? {
        
        if email.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(email) {
            emailError = "Invalid email format"
        } else {
            emailError = nil
        }
        
        return emailError
    }
    
    func validateMobileNumber(_ number: String) -> String? {
        
        if number.isEmpty {
            return "Mobile number is required"
        } else if !isValidMobileNumber(number) {
            return "Invalid mobile number"
        }
        
        return nil
    }
    
    func validateName(_ name: String) -> String? {
        
        if name.isEmpty {
            return "Name is required"
        } else if !isValidIndianFullName(name) {
            return "Invalid name format"
        }
        
        return nil
    }
    
    
    func validatePassword(_ password: String) -> String? {
        
        if password.isEmpty {
            return "Password is required"
        }
        
        return nil
    }
    

}



