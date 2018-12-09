//
//  UnitWrapper.swift
//  ConversionFactors
//
//  Created by Eduardo de la Garza on 10/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class UnitWrapper {
    
    // MARK: - Properties
    
    var type: Dimension
    var name: String
    var coefficient: Float
    var baseUnitName: String
    
    // MARK: - Initializers
    
    init (type: Dimension, name: String, coefficient: Float, baseUnitName: String) {
        self.type = type
        self.name = name
        self.coefficient = coefficient
        self.baseUnitName = baseUnitName
    }
}
