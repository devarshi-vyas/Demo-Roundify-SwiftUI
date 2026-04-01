//
//  MainTabView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 23/03/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Image("HomeIcon")
                        .renderingMode(.template)
                    Text("Home")
                }
                .tag(0)
            
            InvestView()
                .tabItem {
                    Image("InvestIcon")
                        .renderingMode(.template)
                    Text("Invest")
                      
                }
                .tag(1)
            
            TransactionView()
                .tabItem {
                    Image("TransactionIcon")
                        .renderingMode(.template)
                    Text("Transaction")
                        
                }
                .tag(2)
            
           ProfileView()
                .tabItem {
                    Image("ProfileIcon")
                    Text("Profile")
                }
                .tag(3)
        } .tint(.customBlue)
            .bold()
            .navigationBarBackButtonHidden(true)
    }
}

