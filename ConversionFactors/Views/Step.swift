//
//  Step.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 11/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class Step: UIView {
    
    // MARK: - Properties
    
    // Titles
    @IBOutlet weak var stepTitleLabel: UILabel!
    @IBOutlet weak var conversionFactorTitleLabel: UILabel!
    // Value elements
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var magnitudeNumeratorUnitLabel: UILabel!
    @IBOutlet weak var magnitudeUnitFractionDividerLineView: UIView!
    @IBOutlet weak var magnitudeDenominatorUnitLabel: UILabel!
    // Multiplication sign
    @IBOutlet weak var multiplicationSignImageView: UIImageView!
    // Conversion factor elements
    @IBOutlet weak var conversionFactorStackView: UIStackView!
    @IBOutlet weak var conversionFactorNumeratorLabel: UILabel!
    @IBOutlet weak var conversionFactorDividerLineView: UIView!
    @IBOutlet weak var conversionFactorDenominatorLabel: UILabel!

}
