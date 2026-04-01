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
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
              //  ContentView()
                LoginView()
                    .navigationDestination(for: Router.AuthFlow.self) { destination in
                        switch destination {
                        case .login:
                           // ContentView()
                            LoginView()
                        case .signup1:
                            SignUpFirstView()
                        case .signup2(let mobile):
                            SignUpSecondView(mobileNumber: mobile)
                        case .forgotPassword:
                            ForgetPasswordView()
                        case .resetPassword(let userid,let phone):
                            ResetPasswordView(userID: userid, phone: phone)
                        case .tabBarView:
                            MainTabView()
                       
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(viewModel)
            .toast(
                show: $toastManager.showToast,
                message: toastManager.toastData?.message ?? "",
                style: toastManager.toastData?.style ?? .info,
                duration: 5.0
            )
        }.modelContainer(sharedModelContainer)
    }
    
    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }

}
