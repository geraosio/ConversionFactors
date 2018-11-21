//
//  ConversionFactor.swift
//  Unit Conversion
//
//  Created by Gerardo Osio on 11/21/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class ConversionFactor {
    
    // MARK: - Properties
    
    var numeratorMagnitude: Float
    var numeratorUnitName: String
    var denominatorMagnitude: Float
    var denominatorUnitName: String
    
    // MARK: - Initializers
    
    init(numeratorMagnitude: Float, numeratorUnitName: String, denominatorMagnitude: Float, denominatorUnitName: String) {
        self.numeratorMagnitude = numeratorMagnitude
        self.numeratorUnitName = numeratorUnitName
        self.denominatorMagnitude = denominatorMagnitude
        self.denominatorUnitName = denominatorUnitName
    }
    
    // MARK: - Methods
    
    func description() -> String {
        return "\(denominatorMagnitude.formatted) \(denominatorUnitName) = \(numeratorMagnitude.formatted) \(numeratorUnitName)"
    }
}
