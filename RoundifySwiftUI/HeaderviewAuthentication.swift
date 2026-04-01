//
//  HeaderviewAuthentication.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 12/02/26.
//

import SwiftUI

struct HeaderviewAuthentication: View {
    var body: some View {
        ZStack {
            Image("bgimage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
            
            Text("Roundifi")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        
    }
}

#Preview {
    HeaderviewAuthentication()
}
