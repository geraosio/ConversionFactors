//
//  ConversionStep.swift
//  Unit Conversion
//
//  Created by Eduardo de la Garza on 10/22/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ConversionStep: NSObject {
    var magnitude : Float
    var numeratorName : String
    var denominatorName : String
    var temp : String
    
    init (magnitude: Float, numeratorName: String, denominatorName: String, temp: String) {
        self.magnitude = magnitude
        self.numeratorName = numeratorName
        self.denominatorName = denominatorName
        self.temp = temp
    }
    
    func asString () -> String {
        return String(self.magnitude) + " " + self.numeratorName + " " + self.denominatorName + " " + temp
    }
}
