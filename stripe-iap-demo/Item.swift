//
//  Item.swift
//  stripe-iap-demo
//
//  Created by Amos Tan on 14/5/25.
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
