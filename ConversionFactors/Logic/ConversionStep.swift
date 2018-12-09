//
//  ConversionStep.swift
//  ConversionFactors
//
//  Created by Eduardo de la Garza on 10/22/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class ConversionStep {
    
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
