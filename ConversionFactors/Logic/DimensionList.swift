//
//  DimensionList.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 12/9/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class DimensionList {
    var dimensionName: DimensionName
    var list: [UnitWrapper]
    
    init(dimensionName: DimensionName) {
        self.dimensionName = dimensionName
        
        switch dimensionName {
        case .area:
            self.list = [UnitWrapper(type: UnitArea.squareMeters, name: "m\u{00B2}", coefficient: 1, baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareKilometers, name: "km\u{00B2}", coefficient: 1000000,baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareCentimeters, name: "cm\u{00B2}", coefficient: 0.0001, baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareMillimeters, name: "mm\u{00B2}", coefficient: 0.000001, baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareInches, name: "in\u{00B2}", coefficient: 0.00064516, baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareFeet, name: "ft\u{00B2}", coefficient: 0.092903, baseUnitName: "m\u{00B2}"),
                        UnitWrapper(type: UnitArea.squareYards, name: "yd\u{00B2}", coefficient: 0.836127, baseUnitName: "m\u{00B2}")]
        case .length, .speed:
            self.list = [UnitWrapper(type: UnitLength.meters, name: "m", coefficient: 1, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.kilometers, name: "km", coefficient: 1000, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.centimeters, name: "cm", coefficient: 0.01, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.millimeters, name: "mm", coefficient: 0.001, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.inches, name: "in", coefficient: 0.0254, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.feet, name: "ft", coefficient: 0.3048, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.yards, name: "yd", coefficient: 0.9144, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.miles, name: "mi", coefficient: 1609.34, baseUnitName: "m"),
                          UnitWrapper(type: UnitLength.lightyears, name: "ly", coefficient: 9461000000000000, baseUnitName: "m")]
        case .mass:
            self.list = [UnitWrapper(type: UnitMass.kilograms, name: "kg", coefficient: 1, baseUnitName: "kg"),
                         UnitWrapper(type: UnitMass.grams, name: "g", coefficient: 0.001, baseUnitName: "kg"),
                         UnitWrapper(type: UnitMass.centigrams, name: "cg", coefficient: 0.00001, baseUnitName: "kg"),
                         UnitWrapper(type: UnitMass.milligrams, name: "mg", coefficient: 0.000001, baseUnitName: "kg"),
                         UnitWrapper(type: UnitMass.ounces, name: "oz", coefficient: 0.0283495, baseUnitName: "kg"),
                         UnitWrapper(type: UnitMass.pounds, name: "lb", coefficient: 0.453592, baseUnitName: "kg")]
        case .time:
            self.list = [UnitWrapper(type: UnitDuration.seconds, name: "s", coefficient: 1, baseUnitName: "s"),
                        UnitWrapper(type: UnitDuration.minutes, name: "min", coefficient: 60, baseUnitName: "s"),
                        UnitWrapper(type: UnitDuration.hours, name: "hr", coefficient: 3600, baseUnitName: "s")]
        case .volume:
            self.list = [UnitWrapper(type: UnitVolume.liters, name: "L", coefficient: 1, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.deciliters, name: "dL", coefficient: 0.1, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.centiliters, name: "cL", coefficient: 0.01, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.milliliters, name: "mL", coefficient: 0.001, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.cubicKilometers, name: "km\u{00B3}", coefficient: 1000000000000, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.cubicMeters, name: "m\u{00B3}", coefficient: 1000, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.cubicMillimeters, name: "mm\u{00B3}", coefficient: 0.000001, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.cubicInches, name: "in\u{00B3}", coefficient: 0.0163871, baseUnitName: "L"),
                         UnitWrapper(type: UnitVolume.cubicFeet, name: "ft\u{00B3}", coefficient: 28.3168, baseUnitName: "L")]
        }
    }
}
