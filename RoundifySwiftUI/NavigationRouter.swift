//
//  NavigationRouter.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 18/12/25.
//

import Foundation
import SwiftUI
import Combine

final class Router: ObservableObject {
   
    enum AuthFlow: Codable, Hashable {
        case login
        case signup1
        case signup2
        case forgotPassword
        case resetPassword
        
    }

    @Published var navPath = NavigationPath()

    func navigate(to destination: AuthFlow) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

