//
//  Item.swift
//  frontend
//
//  Created by Ella Mohanram on 2/1/25.
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
