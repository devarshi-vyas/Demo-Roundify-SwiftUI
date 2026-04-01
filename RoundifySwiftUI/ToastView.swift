//
//  ToastView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 10/02/26.
//

import Foundation
import UIKit
import SwiftUI
import Combine

enum ToastStyle {
    case success
    case error
    case warning
    case info

    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green.opacity(0.9)
        case .error:
            return Color.red.opacity(0.9)
        case .warning:
            return Color.orange.opacity(0.9)
        case .info:
            return Color.blue.opacity(0.9)
        }
    }
}

struct ToastView: View {
    let message: String
    let style: ToastStyle

    var body: some View {
        Text(message)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(style.backgroundColor) // 🎨 dynamic color
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}


struct ToastModifier: ViewModifier {
    @Binding var show: Bool
    let message: String
    let style: ToastStyle
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content

            if show {
                ToastView(message: message, style: style)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 40)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                show = false
                            }
                        }
                    }
            }
        }
    }
}

extension View {
    func toast(
        show: Binding<Bool>,
        message: String,
        style: ToastStyle = .info,
        duration: Double = 2
    ) -> some View {
        modifier(
            ToastModifier(
                show: show,
                message: message,
                style: style,
                duration: duration
            )
        )
    }
}



struct ToastData {
    let message: String
    let style: ToastStyle
}

@MainActor
final class ToastManager: ObservableObject {

    static let shared = ToastManager()

    @Published var showToast: Bool = false
    @Published var toastData: ToastData?

    private init() {}

    func show(
        message: String,
        style: ToastStyle = .info
    ) {
        toastData = ToastData(message: message, style: style)
        showToast = true
    }
}
