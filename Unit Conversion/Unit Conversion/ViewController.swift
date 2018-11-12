//
//  ViewController.swift
//  Unit Conversion
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//  https://developer.apple.com/documentation/foundation/dimension

// TODO: - TODO -
// TODO: Add Scroll View to move content up when displaying keyboard hides content in smaller screens
// TODO: Update "Deployment Information", support more iOS versions
// TODO: OPTIONAL Make custom transition from DimensionSelection to UnitSelection
// TODO: -

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    // Labels
    @IBOutlet weak var originUnitHelperLabel: UILabel!
    @IBOutlet weak var destinationUnitHelperLabel: UILabel!
    @IBOutlet weak var valueHelperLabel: UILabel!
    // Buttons
    @IBOutlet weak var selectOriginUnitButton: UIButton!
    @IBOutlet weak var selectOriginUnitDenominatorButton: UIButton!
    @IBOutlet weak var selectDestinationUnitButton: UIButton!
    @IBOutlet weak var selectDestinationUnitDenominatorButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    // Text Fields
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var finishEnteringValueButton: UIButton!
    
    var selectedDimension: String!
    var requiresCompoundUnit: Bool!
    // Unit Lists
    var selectedUnitList: [Unidad]!
    var complementaryUnitList: [Unidad]? // For compound units
    // Selected Units
    var selectedOriginUnit: Unidad?
    var selectedOriginUnitDenominator: Unidad?
    var selectedDestinationUnit: Unidad?
    var selectedDestinationUnitDenominator: Unidad?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make View Controller as the value text field delegate
        valueTextField.delegate = self
        
        // Set NavigationBarTitle to the selected dimension
        self.title = selectedDimension.capitalized
        
        // Set the selected unit list
        selectedUnitList = getUnitListFor(selectedDimension)
        
        // Set complementary list if dimension requires a compound unit
        if requiresCompoundUnit {
            complementaryUnitList = getUnitListFor("tiempo")
        }
        
        // Setup the view's elements
        setupViewElements()
    }
    
    // MARK: - Actions
    
    @IBAction func selectOriginUnit(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "Seleccionar unidad de origen", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for unit in selectedUnitList {
            let selectUnitAction = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.selectedOriginUnit = unit
                self.selectOriginUnitButton.backgroundColor = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
                self.selectOriginUnitButton.setTitle(unit.name, for: .normal)
                if !self.requiresCompoundUnit {
                    self.animateHideLabel(self.originUnitHelperLabel, duration: 0.3)
                }
            }
            alertController.addAction(selectUnitAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectOriginUnitDenominator(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "Seleccionar el denominador de la unidad de origen", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        guard let unitList = complementaryUnitList else {
            let errorAlert = UIAlertController(title: "Algo paso 😕", message: "Por favor intenta de nuevo seleccionando la dimension que deseas.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
            return
        }
        
        for unit in unitList {
            let selectUnitAction = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.selectedOriginUnitDenominator = unit
                self.selectOriginUnitDenominatorButton.backgroundColor = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
                self.selectOriginUnitDenominatorButton.setTitle(unit.name, for: .normal)
                self.animateHideLabel(self.originUnitHelperLabel, duration: 0.3)
            }
            alertController.addAction(selectUnitAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectDestinationUnit(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "Seleccionar unidad destino", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        for unit in selectedUnitList {
            let action = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.selectedDestinationUnit = unit
                self.selectDestinationUnitButton.backgroundColor = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
                self.selectDestinationUnitButton.setTitle(unit.name, for: .normal)
                if !self.requiresCompoundUnit {
                    self.animateHideLabel(self.destinationUnitHelperLabel, duration: 0.3)
                }
            }
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectDestinationUnitDenominator(_ sender: Any) {
        
        let alertController = UIAlertController.init(title: "Seleccionar el denominador de la unidad de origen", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        guard let unitList = complementaryUnitList else {
            let errorAlert = UIAlertController(title: "Algo paso 😕", message: "Por favor intenta de nuevo seleccionando la dimension que deseas.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
            return
        }
        
        for unit in unitList {
            let selectUnitAction = UIAlertAction.init(title: unit.name, style: .default) { (completed) in
                self.selectedDestinationUnitDenominator = unit
                self.selectDestinationUnitDenominatorButton.backgroundColor = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
                self.selectDestinationUnitDenominatorButton.setTitle(unit.name, for: .normal)
                self.animateHideLabel(self.destinationUnitHelperLabel, duration: 0.3)
            }
            alertController.addAction(selectUnitAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func finishEnteringValue(_ sender: Any) {
        
        // Remove keyboard
        valueTextField.resignFirstResponder()
        
        // Enable convert button and change color background
        convertButton.isEnabled = true
        convertButton.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func showConversion(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        if let inputValue = Float(valueTextField.text!),
           let originUnit = selectedOriginUnit,
           let destinationUnit = selectedDestinationUnit {
            
            var results = [ConversionStep]()
            
            if let originUnitDenominator = selectedOriginUnitDenominator,
                let destinationUnitDenominator = selectedDestinationUnitDenominator {
                print("\(originUnitDenominator.baseUnitName) & \(destinationUnitDenominator.baseUnitName)")
                results = Conversion.sharedManager.convert(magnitude: inputValue, initialNumerator: originUnit, initialDenominator: originUnitDenominator, resultNumerator: destinationUnit, resultDenominator: destinationUnitDenominator)
            } else {
                results = Conversion.sharedManager.convert(magnitude: inputValue, initialNumerator: originUnit, initialDenominator: destinationUnit, resultNumerator: destinationUnit, resultDenominator: destinationUnit)
            }
            
            var message = ""
            for step in results {
                message = message + step.asString() + "\n"
            }
            
            alertController.title = "Resultado"
            alertController.message = message
        } else {
            alertController.title = "Falto ingresar un dato"
            alertController.message = "Para obtener un resultado asegurate de haber seleccionado la unidad origen, la unidad destino e ingresado un valor"
        }

        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Code
    }
    
    // MARK: - Private Methods
    
    private func animateHideLabel(_ label: UILabel, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            label.alpha = 0.0
        })
    }
    
    private func setupViewElements() {
        
        let cornerRadiusValue: CGFloat = 8.0
        
        selectOriginUnitButton.layer.cornerRadius = cornerRadiusValue
        selectOriginUnitButton.setTitle(selectedUnitList[0].name, for: .normal)
        selectDestinationUnitButton.layer.cornerRadius = cornerRadiusValue
        selectDestinationUnitButton.setTitle(selectedUnitList[0].name, for: .normal)
        finishEnteringValueButton.layer.cornerRadius = cornerRadiusValue / 2
        convertButton.layer.cornerRadius = cornerRadiusValue
        
        if self.requiresCompoundUnit {
            
            guard let unitList = complementaryUnitList else {
                let errorAlert = UIAlertController(title: "Algo paso 😕", message: "Por favor intenta de nuevo seleccionando la dimension que deseas.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                return
            }
            
            selectOriginUnitDenominatorButton.isHidden = false
            selectOriginUnitDenominatorButton.layer.cornerRadius = cornerRadiusValue
            selectOriginUnitDenominatorButton.setTitle(unitList[0].name, for: .normal)
            
            selectDestinationUnitDenominatorButton.isHidden = false
            selectDestinationUnitDenominatorButton.layer.cornerRadius = cornerRadiusValue
            selectDestinationUnitDenominatorButton.setTitle(unitList[0].name, for: .normal)
        }
    }
    
    private func getUnitListFor(_ unitListName: String) -> [Unidad] {
        
        // Initialize lists
        let areaList = [ Unidad(type: UnitArea.squareMeters, name: "m\u{00B2}", coefficient: 1, baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareKilometers, name: "km\u{00B2}", coefficient: 1000000,baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareCentimeters, name: "cm\u{00B2}", coefficient: 0.0001, baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareMillimeters, name: "mm\u{00B2}", coefficient: 0.000001, baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareInches, name: "in\u{00B2}", coefficient: 0.00064516, baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareFeet, name: "ft\u{00B2}", coefficient: 0.092903, baseUnitName: "square meters"),
                         Unidad(type: UnitArea.squareYards, name: "yd\u{00B2}", coefficient: 0.836127, baseUnitName: "square meters")]
        
        let lengthList = [ Unidad(type: UnitLength.meters, name: "m", coefficient: 1, baseUnitName: "meters"),
                       Unidad(type: UnitLength.kilometers, name: "km", coefficient: 1000, baseUnitName: "meters"),
                       Unidad(type: UnitLength.centimeters, name: "cm", coefficient: 0.01, baseUnitName: "meters"),
                       Unidad(type: UnitLength.millimeters, name: "mm", coefficient: 0.001, baseUnitName: "meters"),
                       Unidad(type: UnitLength.inches, name: "in", coefficient: 0.0254, baseUnitName: "meters"),
                       Unidad(type: UnitLength.feet, name: "ft", coefficient: 0.3048, baseUnitName: "meters"),
                       Unidad(type: UnitLength.yards, name: "yd", coefficient: 0.9144, baseUnitName: "meters"),
                       Unidad(type: UnitLength.miles, name: "mi", coefficient: 1609.34, baseUnitName: "meters"),
                       Unidad(type: UnitLength.lightyears, name: "ly", coefficient: 9461000000000000, baseUnitName: "meters")]
        
        let timeList = [ Unidad(type: UnitDuration.seconds, name: "s", coefficient: 1, baseUnitName: "seconds"),
                         Unidad(type: UnitDuration.minutes, name: "min", coefficient: 60, baseUnitName: "seconds"),
                         Unidad(type: UnitDuration.hours, name: "hr", coefficient: 3600, baseUnitName: "seconds")]
        
        let volumeList = [Unidad(type: UnitVolume.liters, name: "L", coefficient: 1, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.deciliters, name: "dL", coefficient: 0.1, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.centiliters, name: "cL", coefficient: 0.01, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.milliliters, name: "mL", coefficient: 0.001, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.cubicKilometers, name: "km\u{00B3}", coefficient: 1000000000000, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.cubicMeters, name: "m\u{00B3}", coefficient: 1000, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.cubicMillimeters, name: "mm\u{00B3}", coefficient: 0.000001, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.cubicInches, name: "in\u{00B3}", coefficient: 0.0163871, baseUnitName: "liters"),
                          Unidad(type: UnitVolume.cubicFeet, name: "ft\u{00B3}", coefficient: 28.3168, baseUnitName: "liters")]
        
        let weightList = [Unidad(type: UnitMass.kilograms, name: "kg", coefficient: 1, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.grams, name: "g", coefficient: 0.001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.centigrams, name: "cg", coefficient: 0.00001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.milligrams, name: "mg", coefficient: 0.000001, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.ounces, name: "oz", coefficient: 0.0283495, baseUnitName: "kilograms"),
                    Unidad(type: UnitMass.pounds, name: "lb", coefficient: 0.453592, baseUnitName: "kilograms")]
        
        switch unitListName {
        case "area":
            return areaList
        case "distancia":
            return lengthList
        case "peso":
            return weightList
        case "tiempo":
            return timeList
        case "volumen":
            return volumeList
        default:
            return lengthList
        }
    }
    
}

// MARK: - Text Field Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        finishEnteringValueButton.alpha = 0.0
        finishEnteringValueButton.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.finishEnteringValueButton.alpha = 1.0
        }) { (isCompleted) in
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        animateHideLabel(valueHelperLabel, duration: 0.3)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.finishEnteringValueButton.alpha = 0.0
        }) { (isCompleted) in
            self.finishEnteringValueButton.isHidden = true
        }
    }
}

