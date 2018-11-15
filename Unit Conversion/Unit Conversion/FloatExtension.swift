//
//  FloatExtension.swift
//  Unit Conversion
//
//  Created by Gerardo Osio on 11/20/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

extension Float {
    static let fourFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter
    }()
    
    var formatted: String {
        return Float.fourFractionDigits.string(for: self) ?? ""
    }
}
