//
//  RoundifySwiftUIApp.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 17/11/25.
//

import SwiftUI
import SwiftData

@main
struct RoundifySwiftUIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
  //  @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var router = Router()
    @StateObject var viewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.AuthFlow.self) { destination in
                        switch destination {
                        case .login:
                            ContentView()
                        case .signup1:
                            SignUpFirstView()
                        case .signup2:
                            SignUpSecondView()
                        case .forgotPassword:
                            ForgetPasswordView()
                        case .resetPassword:
                            ResetPasswordView()
                       
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(viewModel)
        }.modelContainer(sharedModelContainer)
    }
    
    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }

}
