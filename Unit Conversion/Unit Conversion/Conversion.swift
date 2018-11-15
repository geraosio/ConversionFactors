//
//  Conversion.swift
//  Unit Conversion
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class Conversion {
    
    class var sharedManager: Conversion {
        struct Static {
            static let instance: Conversion = Conversion()
        }
        
        return Static.instance
    }
    
    func convert(magnitude: Float, initialNumerator: Unidad, initialDenominator: Unidad?, resultNumerator: Unidad, resultDenominator: Unidad?) -> [ConversionStep] {
        
        var result = [ConversionStep]()
        
        if let unwrappedInitialDenominator = initialDenominator,
            let unwrappedResultDenominator = resultDenominator {
            
            // Get the numerator part of the result
            let initialNumeratorMeasurement = Measurement.init(value: Double(magnitude), unit: initialNumerator.type)
            let resultNumeratorMeasurement = initialNumeratorMeasurement.converted(to: resultNumerator.type)
            
            // Get the denominator part of the result
            let initialDenominatorMeasurement = Measurement.init(value: 1, unit: unwrappedResultDenominator.type)
            let resultDenominatorMeasurement = initialDenominatorMeasurement.converted(to: unwrappedInitialDenominator.type)
            
            // Get the result of the converion by multipliying the numerator part and denominator part
            let resultValue: Double = resultNumeratorMeasurement.value * resultDenominatorMeasurement.value
            
            // STEPS
            // 1st Step
            // Construct the numerator conversion factor
            let numeratorConversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: ceilf(Float(resultNumeratorMeasurement.value) / magnitude), numeratorUnitName: resultNumerator.name, denominatorMagnitude: ceilf(magnitude / Float(resultNumeratorMeasurement.value)), denominatorUnitName: initialNumerator.name)
            
            result.append(ConversionStep(magnitude: magnitude, numeratorName: initialNumerator.name, denominatorName: unwrappedInitialDenominator.name, conversionFactor: numeratorConversionFactor))
            
            // 2nd Step
            // Construct the denominator conversion factor
            let denominatorConversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: Float(ceil(resultDenominatorMeasurement.value)), numeratorUnitName: unwrappedInitialDenominator.name, denominatorMagnitude: ceilf(1.0 / Float(resultDenominatorMeasurement.value)), denominatorUnitName: unwrappedResultDenominator.name)
            
            result.append(ConversionStep(magnitude: Float(resultNumeratorMeasurement.value), numeratorName: resultNumerator.name, denominatorName: unwrappedInitialDenominator.name, conversionFactor: denominatorConversionFactor))
            
            // 3rd Step
            result.append(ConversionStep(magnitude: Float(resultValue), numeratorName: resultNumerator.name, denominatorName: unwrappedResultDenominator.name, conversionFactor: nil))
        } else {
            
            // Calculate the result using Measurements and its converted(to:) function
            let initialMeasurement = Measurement.init(value: Double(magnitude), unit: initialNumerator.type)
            let resultMeasurement: Measurement = initialMeasurement.converted(to: resultNumerator.type)
            let resultMeasurementValue: Float = Float(resultMeasurement.value)
            
            // 1st Step
            // Construct the conversion factor using the initial and result values
            let conversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: ceilf(resultMeasurementValue / magnitude), numeratorUnitName: resultNumerator.name, denominatorMagnitude: ceilf(magnitude / resultMeasurementValue), denominatorUnitName: initialNumerator.name)
            
            result.append(ConversionStep(magnitude: magnitude, numeratorName: initialNumerator.name, denominatorName: nil, conversionFactor: conversionFactor))
            
            // 2nd Step
            result.append(ConversionStep(magnitude: Float(resultMeasurement.value), numeratorName: resultNumerator.name, denominatorName: nil, conversionFactor: nil))
        }
        
        return result;
    }
}
