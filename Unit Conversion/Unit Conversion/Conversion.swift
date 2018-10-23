//
//  Conversion.swift
//  Unit Conversion
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit

//extension Double {
//    func rounded(toPlaces places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//}

extension String {
    func unitFromDescription() -> String {
        return components(separatedBy: ">")[1].replacingOccurrences(of: " ", with: "")
    }
}

class Conversion {
    
    class var sharedManager: Conversion {
        struct Static {
            static let instance: Conversion = Conversion()
        }
        return Static.instance
    }
    
    func convert(magnitude: Float, initialNumerator: Unidad, initialDenominator: Unidad, resultNumerator: Unidad, resultDenominator: Unidad) -> [ConversionStep] {
        var result = [ConversionStep]()
        
        result.append(ConversionStep(magnitude: magnitude, numeratorName: initialNumerator.name, denominatorName: initialDenominator.name))
        
        if (initialNumerator.name != resultNumerator.name) {
            if (initialNumerator.coefficient != 1 && resultNumerator.coefficient != 1) {
                result.append(ConversionStep(magnitude: magnitude * initialNumerator.coefficient, numeratorName: initialNumerator.baseUnitName, denominatorName: initialDenominator.name))
            }
        }
        
        let initNumeratorMeasurement = Measurement.init(value: Double(magnitude), unit: initialNumerator.type)
        let resultNumeratorMeasurement = initNumeratorMeasurement.converted(to: resultNumerator.type)
        
        let initDenominatorMeasurement = Measurement.init(value: 1, unit: resultDenominator.type)
        let resultDenominatorMeasurement = initDenominatorMeasurement.converted(to: initialDenominator.type)
        let resultValue = resultNumeratorMeasurement * resultDenominatorMeasurement.value
        
        result.append(ConversionStep(magnitude: Float(resultNumeratorMeasurement.value), numeratorName: resultNumerator.name, denominatorName: initialDenominator.name))
        
        if (initialDenominator.name != resultDenominator.name) {
            if (initialDenominator.coefficient != 1 && resultDenominator.coefficient != 1) {
                result.append(ConversionStep(magnitude: Float(resultNumeratorMeasurement.value) / initialDenominator.coefficient, numeratorName: resultNumerator.name, denominatorName: initialDenominator.baseUnitName))
            }
        }

        result.append(ConversionStep(magnitude: Float(resultValue.value), numeratorName: resultNumerator.name, denominatorName: resultDenominator.name))

        return result;
    }
}
