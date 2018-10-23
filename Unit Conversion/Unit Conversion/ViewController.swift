//
//  ViewController.swift
//  Unit Conversion
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//  https://developer.apple.com/documentation/foundation/dimension

import UIKit

class ViewController: UIViewController {

    var initNumberator: Unidad?
    var initDenominator: Unidad?
    var resultNumberator: Unidad?
    var resultDenominator: Unidad?
    
    @IBOutlet weak var initNumberatorButton: UIButton!
    @IBOutlet weak var initDenominatorButton: UIButton!
    
    @IBOutlet weak var resultNumberatorButton: UIButton!
    @IBOutlet weak var resultDenominatorButton: UIButton!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    var lengthList = [Unidad]()
    var areaList = [Unidad]()
    var durationList = [Unidad]()
    var massList = [Unidad]()
    var volumeList = [Unidad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lengthList = [ Unidad(type: UnitLength.meters, name: "meters", coefficient: 1, baseUnitName: "meters"),
                       Unidad(type: UnitLength.kilometers, name: "kilometers", coefficient: 1000, baseUnitName: "meters"),
                       Unidad(type: UnitLength.centimeters, name: "centimeter", coefficient: 0.01, baseUnitName: "meters"),
                       Unidad(type: UnitLength.millimeters, name: "milimiters", coefficient: 0.001, baseUnitName: "meters"),
                       Unidad(type: UnitLength.inches, name: "inches", coefficient: 0.0254, baseUnitName: "meters"),
                       Unidad(type: UnitLength.feet, name: "feet", coefficient: 0.3048, baseUnitName: "meters"),
                       Unidad(type: UnitLength.yards, name: "yards", coefficient: 0.9144, baseUnitName: "meters"),
                       Unidad(type: UnitLength.miles, name: "miles", coefficient: 1609.34, baseUnitName: "meters"),
                       Unidad(type: UnitLength.lightyears, name: "light years", coefficient: 9461000000000000, baseUnitName: "meters")]
        
        areaList = [ Unidad(type: UnitArea.squareMeters, name: "square meters", coefficient: 1, baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareKilometers, name: "square kilometers", coefficient: 1000000,baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareCentimeters, name: "square centimeters", coefficient: 0.0001, baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareMillimeters, name: "square milimeters", coefficient: 0.000001, baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareInches, name: "square inches", coefficient: 0.00064516, baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareFeet, name: "square feet", coefficient: 0.092903, baseUnitName: "square meters"),
                     Unidad(type: UnitArea.squareYards, name: "square yards", coefficient: 0.836127, baseUnitName: "square meters")]
        
        durationList = [ Unidad(type: UnitDuration.seconds, name: "seconds", coefficient: 1, baseUnitName: "seconds"),
                         Unidad(type: UnitDuration.minutes, name: "minutes", coefficient: 60, baseUnitName: "seconds"),
                         Unidad(type: UnitDuration.hours, name: "hours", coefficient: 3600, baseUnitName: "seconds")]

        massList = [Unidad(type: UnitMass.kilograms, name: "kilograms", coefficient: 1, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.grams, name: "grams", coefficient: 0.001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.centigrams, name: "centimeters", coefficient: 0.00001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.milligrams, name: "miligrams", coefficient: 0.000001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.ounces, name: "ounces", coefficient: 0.0283495, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.pounds, name: "pounds", coefficient: 0.453592, baseUnitName: "kilograms")]
        
        volumeList = [Unidad(type: UnitVolume.liters, name: "liters", coefficient: 1, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.deciliters, name: "deciliters", coefficient: 0.1, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.centiliters, name: "centiliters", coefficient: 0.01, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.milliliters, name: "milimeters", coefficient: 0.001, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.cubicKilometers, name: "cubic kilometers", coefficient: 1000000000000, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.cubicMeters, name: "cubic meters", coefficient: 1000, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.cubicMillimeters, name: "cubic milimeters", coefficient: 0.000001, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.cubicInches, name: "cubic inches", coefficient: 0.0163871, baseUnitName: "liters"),
                      Unidad(type: UnitVolume.cubicFeet, name: "cubic feet", coefficient: 28.3168, baseUnitName: "liters")]
    }

    @IBAction func convertButtonClicked(_ sender: Any) {
        if let input = Float(inputTextField.text!), let iNumerator = initNumberator, let iDenominator = initDenominator, let  rNumerator = resultNumberator, let rDenominator =  resultDenominator  {
            let results = Conversion.sharedManager.convert(magnitude: input, initialNumerator: iNumerator, initialDenominator: iDenominator, resultNumerator: rNumerator, resultDenominator: rDenominator)
            
            var message = ""
            for step in results {
                message = message + step.asString() + "\n"
            }
            let alertController = UIAlertController.init(title: "Result", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func initNumberatorClicked(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Select a unit", message: nil, preferredStyle: .actionSheet)
        for unit in lengthList {
            let action = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.initNumberator = unit
                self.initNumberatorButton.setTitle(unit.name, for: .normal)
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func initDenominatorClicked(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Select a unit", message: nil, preferredStyle: .actionSheet)
        for unit in durationList {
            let action = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.initDenominator = unit
                self.initDenominatorButton.setTitle(unit.name, for: .normal)
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resultNumberatorClicked(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Select a unit", message: nil, preferredStyle: .actionSheet)
        for unit in lengthList {
            let action = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.resultNumberator = unit
                self.resultNumberatorButton.setTitle(unit.name, for: .normal)
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resultDenominatorClicked(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Select a unit", message: nil, preferredStyle: .actionSheet)
        for unit in durationList {
            let action = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.resultDenominator = unit
                self.resultDenominatorButton.setTitle(unit.name, for: .normal)
            }
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}

