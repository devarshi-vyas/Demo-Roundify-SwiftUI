//
//  Item.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 17/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
