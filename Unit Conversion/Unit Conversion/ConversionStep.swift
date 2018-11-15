//
//  ConversionStep.swift
//  Unit Conversion
//
//  Created by Eduardo de la Garza on 10/22/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

struct ConversionFactor {
    var numeratorMagnitude: Float
    var numeratorUnitName: String
    var denominatorMagnitude: Float
    var denominatorUnitName: String
    
    init(numeratorMagnitude: Float, numeratorUnitName: String, denominatorMagnitude: Float, denominatorUnitName: String) {
        self.numeratorMagnitude = numeratorMagnitude
        self.numeratorUnitName = numeratorUnitName
        self.denominatorMagnitude = denominatorMagnitude
        self.denominatorUnitName = denominatorUnitName
    }
    
    func description() -> String {
        return "\(numeratorMagnitude.formatted) \(numeratorUnitName) = \(denominatorMagnitude.formatted) \(denominatorUnitName)"
    }
}

class ConversionStep: NSObject {
    
    // MARK: - Properties
    
    var magnitude: Float
    var numeratorName: String
    var denominatorName: String?
    var conversionFactor: ConversionFactor?
    
    // MARK: - Initializers
    
    init (magnitude: Float, numeratorName: String, denominatorName: String?, conversionFactor: ConversionFactor?) {
        self.magnitude = magnitude
        self.numeratorName = numeratorName
        self.denominatorName = denominatorName == numeratorName ? nil : denominatorName
        self.conversionFactor = conversionFactor
    }
    
}
