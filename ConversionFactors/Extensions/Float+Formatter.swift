//
//  FloatExtension.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 11/20/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

func exponentize(numberAsString: String) -> String {
    
    let superCodes = [
        "\u{2070}", // 0
        "\u{00B9}", // 1
        "\u{00B2}", // 2
        "\u{00B3}", // 3
        "\u{2074}", // 4
        "\u{2075}", // 5
        "\u{2076}", // 6
        "\u{2077}", // 7
        "\u{2078}", // 8
        "\u{2079}"  // 9
    ]
    
    var exponentized = ""
    var caretFound = false
    
    for digitAsChar in numberAsString {
        
        if digitAsChar == "^" {
            caretFound = true
        } else {
            if caretFound {
                let key = Int(String(digitAsChar)) ?? -1
                if key > -1 && key < 10 {
                    exponentized.append(superCodes[key])
                } else if digitAsChar == "-" {
                    exponentized.append("\u{207B}")
                } else {
                    caretFound = false
                    exponentized.append(digitAsChar)
                }
            } else {
                exponentized.append(digitAsChar)
            }
        }
    }
    
    return exponentized
}

extension Float {
    static let fourFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter
    }()
    
    static let scientificNotation: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.minimumSignificantDigits = 4
        formatter.maximumSignificantDigits = 4
        return formatter
    }()
    
    var formatted: String {
        
        if self > 0.0001 && self < 1_000_000_000 {
            // Return the float as string rounded to maximum 4 decimal digits with comma separation each 3 integers.
            return Float.fourFractionDigits.string(for: self) ?? ""
        } else {
            // Get the float as string rounded to 4 significant digits in scientific notation (ex. "4.223E12")
            let formattedNumber = Float.scientificNotation.string(for: self) ?? ""
            var returnString = String()
            
            // Change the E sign to "x 10^"
            for digit in formattedNumber {
                digit == "E" ? returnString.append(" x 10^") : returnString.append(digit)
            }
            
            // Return the string with the exponents as superscripts
            return exponentize(numberAsString: returnString)
        }
    }
}
