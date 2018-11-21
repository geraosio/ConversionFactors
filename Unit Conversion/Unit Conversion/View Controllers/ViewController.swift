//
//  ViewController.swift
//  Unit Conversion
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//  https://developer.apple.com/documentation/foundation/dimension

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
    @IBOutlet weak var finishEnteringValueButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    // Text Fields
    @IBOutlet weak var valueTextField: UITextField!
    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    // Conversion Steps
    var results = [ConversionStep]()
    
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
        
        // Move content up if keyboard hides content
        registerForKeyboardNotification()
        
        // Dismiss keyboard when tapping outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
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
                self.selectOriginUnitButton.backgroundColor = UIColor(red: 190.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
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
                self.selectOriginUnitDenominatorButton.backgroundColor = UIColor(red: 190.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
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
                self.selectDestinationUnitButton.backgroundColor = UIColor(red: 190.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
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
                self.selectDestinationUnitDenominatorButton.backgroundColor = UIColor(red: 190.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
                self.selectDestinationUnitDenominatorButton.setTitle(unit.name, for: .normal)
                self.animateHideLabel(self.destinationUnitHelperLabel, duration: 0.3)
            }
            alertController.addAction(selectUnitAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func finishEnteringValue(_ sender: Any) {
        self.dismissKeyboard()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showSteps" {
            if let inputValue = Float(valueTextField.text!),
                let originUnit = selectedOriginUnit,
                let destinationUnit = selectedDestinationUnit {
                
                results = Conversion.sharedManager.convert(magnitude: inputValue, initialNumerator: originUnit, initialDenominator: selectedOriginUnitDenominator, resultNumerator: destinationUnit, resultDenominator: selectedDestinationUnitDenominator)
            } else {
                let alertController = UIAlertController(title: "Falto ingresar un dato", message: "Para obtener un resultado asegurate de haber seleccionado la unidad origen, la unidad destino e ingresado un valor.", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stepView = segue.destination as? StepsViewController {
            stepView.results = results
            stepView.titleLabelText = "Conversión"
            
            if let originUnitDenominatorName = selectedOriginUnitDenominator?.name,
                let destinationUnitDenominatorName = selectedDestinationUnitDenominator?.name {
                stepView.unitsTitleLabelText = "\(selectedOriginUnit?.name ?? "")/\(originUnitDenominatorName) a \(selectedDestinationUnit?.name ?? "")/\(destinationUnitDenominatorName)"
            } else {
                stepView.unitsTitleLabelText = "\(selectedOriginUnit?.name ?? "") a \(selectedDestinationUnit?.name ?? "")"
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func animateHideLabel(_ label: UILabel, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            label.alpha = 0.0
        })
    }
    
    @objc private func dismissKeyboard() {
        // Make view or embedded subviews to resign first responder and return to background
        self.view.endEditing(true)
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWasShown(notification: NSNotification) {
        
        // Get the keyboard size from the info dictionary of the notification
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize: CGSize = keyboardInfo.cgRectValue.size
        
        // Adjust the bottom content inset of the scroll view by the height of the keyboard
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
        let areaList = [ Unidad(type: UnitArea.squareMeters, name: "m\u{00B2}", coefficient: 1, baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareKilometers, name: "km\u{00B2}", coefficient: 1000000,baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareCentimeters, name: "cm\u{00B2}", coefficient: 0.0001, baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareMillimeters, name: "mm\u{00B2}", coefficient: 0.000001, baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareInches, name: "in\u{00B2}", coefficient: 0.00064516, baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareFeet, name: "ft\u{00B2}", coefficient: 0.092903, baseUnitName: "m\u{00B2}"),
                         Unidad(type: UnitArea.squareYards, name: "yd\u{00B2}", coefficient: 0.836127, baseUnitName: "m\u{00B2}")]
        
        let lengthList = [ Unidad(type: UnitLength.meters, name: "m", coefficient: 1, baseUnitName: "m"),
                       Unidad(type: UnitLength.kilometers, name: "km", coefficient: 1000, baseUnitName: "m"),
                       Unidad(type: UnitLength.centimeters, name: "cm", coefficient: 0.01, baseUnitName: "m"),
                       Unidad(type: UnitLength.millimeters, name: "mm", coefficient: 0.001, baseUnitName: "m"),
                       Unidad(type: UnitLength.inches, name: "in", coefficient: 0.0254, baseUnitName: "m"),
                       Unidad(type: UnitLength.feet, name: "ft", coefficient: 0.3048, baseUnitName: "m"),
                       Unidad(type: UnitLength.yards, name: "yd", coefficient: 0.9144, baseUnitName: "m"),
                       Unidad(type: UnitLength.miles, name: "mi", coefficient: 1609.34, baseUnitName: "m"),
                       Unidad(type: UnitLength.lightyears, name: "ly", coefficient: 9461000000000000, baseUnitName: "m")]
        
        let timeList = [ Unidad(type: UnitDuration.seconds, name: "s", coefficient: 1, baseUnitName: "s"),
                         Unidad(type: UnitDuration.minutes, name: "min", coefficient: 60, baseUnitName: "s"),
                         Unidad(type: UnitDuration.hours, name: "hr", coefficient: 3600, baseUnitName: "s")]
        
        let volumeList = [Unidad(type: UnitVolume.liters, name: "L", coefficient: 1, baseUnitName: "L"),
                          Unidad(type: UnitVolume.deciliters, name: "dL", coefficient: 0.1, baseUnitName: "L"),
                          Unidad(type: UnitVolume.centiliters, name: "cL", coefficient: 0.01, baseUnitName: "L"),
                          Unidad(type: UnitVolume.milliliters, name: "mL", coefficient: 0.001, baseUnitName: "L"),
                          Unidad(type: UnitVolume.cubicKilometers, name: "km\u{00B3}", coefficient: 1000000000000, baseUnitName: "L"),
                          Unidad(type: UnitVolume.cubicMeters, name: "m\u{00B3}", coefficient: 1000, baseUnitName: "L"),
                          Unidad(type: UnitVolume.cubicMillimeters, name: "mm\u{00B3}", coefficient: 0.000001, baseUnitName: "L"),
                          Unidad(type: UnitVolume.cubicInches, name: "in\u{00B3}", coefficient: 0.0163871, baseUnitName: "L"),
                          Unidad(type: UnitVolume.cubicFeet, name: "ft\u{00B3}", coefficient: 28.3168, baseUnitName: "L")]
        
        let weightList = [Unidad(type: UnitMass.kilograms, name: "kg", coefficient: 1, baseUnitName: "kg"),
                    Unidad(type: UnitMass.grams, name: "g", coefficient: 0.001, baseUnitName: "kg"),
                    Unidad(type: UnitMass.centigrams, name: "cg", coefficient: 0.00001, baseUnitName: "kg"),
                    Unidad(type: UnitMass.milligrams, name: "mg", coefficient: 0.000001, baseUnitName: "kg"),
                    Unidad(type: UnitMass.ounces, name: "oz", coefficient: 0.0283495, baseUnitName: "kg"),
                    Unidad(type: UnitMass.pounds, name: "lb", coefficient: 0.453592, baseUnitName: "kg")]
        
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
        
        // Enable convert button and change color background
        convertButton.isEnabled = true
        convertButton.backgroundColor = UIColor(red: 9.0/255.0, green: 71.0/255.0, blue: 107.0/255.0, alpha: 1.0)
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
