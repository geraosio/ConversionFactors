//
//  ConversionStep.swift
//  Unit Conversion
//
//  Created by Eduardo de la Garza on 10/22/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ConversionStep: NSObject {
    
    // MARK: - Properties
    
    var magnitude : Float
    var numeratorName : String
    var denominatorName : String
    
    // MARK: - Initializers
    
    init (magnitude: Float, numeratorName: String, denominatorName: String) {
        self.magnitude = magnitude
        self.numeratorName = numeratorName
        self.denominatorName = denominatorName
    }
    
    // MARK: - Methods
    
    func asString () -> String {
        return String(self.magnitude) + " " + self.numeratorName + " " + self.denominatorName
    }
}
