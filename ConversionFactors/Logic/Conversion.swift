//
//  Conversion.swift
//  ConversionFactors
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class Conversion {
    
    class var sharedManager: Conversion {
        struct Static {
            static let instance: Conversion = Conversion()
        }
        
        return Static.instance
    }
    
    func convert(magnitude: Float, initialNumerator: UnitWrapper, initialDenominator: UnitWrapper?, resultNumerator: UnitWrapper, resultDenominator: UnitWrapper?) -> [ConversionStep] {
        
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
            var numeratorConversionFactorNumeratorMagnitude: Float = Float(resultNumeratorMeasurement.value) / magnitude
            var numeratorConversionFactorDenominatorMagnitude: Float = magnitude / Float(resultNumeratorMeasurement.value)
            
            numeratorConversionFactorNumeratorMagnitude = numeratorConversionFactorNumeratorMagnitude < 1 ? 1 : numeratorConversionFactorNumeratorMagnitude
            numeratorConversionFactorDenominatorMagnitude = numeratorConversionFactorDenominatorMagnitude < 1 ? 1 : numeratorConversionFactorDenominatorMagnitude
            
            let numeratorConversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: numeratorConversionFactorNumeratorMagnitude, numeratorUnitName: resultNumerator.name, denominatorMagnitude: numeratorConversionFactorDenominatorMagnitude, denominatorUnitName: initialNumerator.name)
            
            result.append(ConversionStep(magnitude: magnitude, numeratorName: initialNumerator.name, denominatorName: unwrappedInitialDenominator.name, conversionFactor: numeratorConversionFactor))
            
            // 2nd Step
            // Construct the denominator conversion factor
            var denominatorConversionFactorNumeratorMagnitude: Float = Float(resultDenominatorMeasurement.value)
            var denominatorConversionFactorDenominatorMagnitude: Float = 1.0 / Float(resultDenominatorMeasurement.value)
            
            denominatorConversionFactorNumeratorMagnitude = denominatorConversionFactorNumeratorMagnitude < 1 ? 1 : denominatorConversionFactorNumeratorMagnitude
            denominatorConversionFactorDenominatorMagnitude = denominatorConversionFactorDenominatorMagnitude < 1 ? 1 : denominatorConversionFactorDenominatorMagnitude
            
            let denominatorConversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: denominatorConversionFactorNumeratorMagnitude, numeratorUnitName: unwrappedInitialDenominator.name, denominatorMagnitude: denominatorConversionFactorDenominatorMagnitude, denominatorUnitName: unwrappedResultDenominator.name)
            
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
            var conversionFactorNumeratorMagnitude: Float = resultMeasurementValue / magnitude
            var conversionFactorDenominatorMagnitude: Float = magnitude / resultMeasurementValue
            
            conversionFactorNumeratorMagnitude = conversionFactorNumeratorMagnitude < 1 ? 1 : conversionFactorNumeratorMagnitude
            conversionFactorDenominatorMagnitude = conversionFactorDenominatorMagnitude < 1 ? 1 : conversionFactorDenominatorMagnitude
            
            let conversionFactor: ConversionFactor = ConversionFactor(numeratorMagnitude: conversionFactorNumeratorMagnitude, numeratorUnitName: resultNumerator.name, denominatorMagnitude: conversionFactorDenominatorMagnitude, denominatorUnitName: initialNumerator.name)
            
            result.append(ConversionStep(magnitude: magnitude, numeratorName: initialNumerator.name, denominatorName: nil, conversionFactor: conversionFactor))
            
            // 2nd Step
            result.append(ConversionStep(magnitude: Float(resultMeasurement.value), numeratorName: resultNumerator.name, denominatorName: nil, conversionFactor: nil))
        }
        
        return result;
    }
}
