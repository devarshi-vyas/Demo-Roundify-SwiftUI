//
//  ProfileView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 25/03/26.
//

import SwiftUI

// MARK: - Menu Item Model
struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
}

// MARK: - Profile View
struct ProfileView: View {
    
    let menuItems: [ProfileMenuItem] = [
        ProfileMenuItem(icon: "person.circle", title: "Profile", subtitle: "Personal Information"),
        ProfileMenuItem(icon: "building.columns", title: "Bank Details", subtitle: "Add or remove bank account"),
        ProfileMenuItem(icon: "checkmark.circle", title: "Orders", subtitle: "Check open orders and filled orders"),
        ProfileMenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Logout", subtitle: "")]
    
    @State private var selectedTab: Int = 4
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Page Title
                    Text("Profile")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                    
                    // Account Detail Card
                    accountDetailCard
                        .padding(.horizontal, 12)
                    
                    // Menu List
                    menuListSection
                        .padding(.horizontal, 12)
                        .padding(.top, 16)
                }
                .padding(.bottom, 20)
            }
            .padding(.bottom, 70)
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - Account Detail Card
    private var accountDetailCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Detail")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Andrew Ansley")
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.primary)
            
            // Client ID Box
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("User ID:- H49364")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("AndrewAnsley@gmail.com")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Avatar
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.1, green: 0.38, blue: 0.2))
                        .frame(width: 48, height: 48)
                    
                    Text("AA")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.separator), lineWidth: 0.5)
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Menu List
    private var menuListSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: 0) {
                    menuRow(item: item)
                    
                    if index < menuItems.count - 1 {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Menu Row
    private func menuRow(item: ProfileMenuItem) -> some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                
                Image(systemName: item.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if item.subtitle != "" {
                    
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                       .lineLimit(1)
                }
                
               
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color(.tertiaryLabel))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
    
}

// MARK: - Preview
#Preview {
    ProfileView()
}
