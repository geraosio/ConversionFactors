//
//  UnitSelectionViewController.swift
//  ConversionFactors
//
//  Created by Administrator on 9/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//  https://developer.apple.com/documentation/foundation/dimension

import UIKit

class UnitSelectionViewController: UIViewController {
    
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
    
    var selectedDimension: DimensionName!
    var requiresCompoundUnit: Bool!
    // Unit Lists
    var selectedUnitList: [UnitWrapper]!
    var complementaryUnitList: [UnitWrapper]? // For compound units
    // Selected Units
    var selectedOriginUnit: UnitWrapper?
    var selectedOriginUnitDenominator: UnitWrapper?
    var selectedDestinationUnit: UnitWrapper?
    var selectedDestinationUnitDenominator: UnitWrapper?
    // Conversion Steps
    var results = [ConversionStep]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make View Controller as the value text field delegate
        valueTextField.delegate = self
        
        // Set the selected unit list
        selectedUnitList = DimensionList(dimensionName: selectedDimension).list
        
        // Set complementary list if dimension requires a compound unit
        if requiresCompoundUnit {
            complementaryUnitList = DimensionList(dimensionName: .time).list
        }
        
        // Move content up if keyboard hides content
        registerForKeyboardNotification()
        
        // Dismiss keyboard when tapping outside of it
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UnitSelectionViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        // Setup the view's elements
        setupViewElements()
    }
    
    // MARK: - Actions
    
    @IBAction func selectOriginUnit(_ sender: Any) {
        
        let alertControlText = NSLocalizedString("Select origin unit", comment: "To select the unit in a menu")
        let cancelText = NSLocalizedString("Cancel", comment: "To close a menu")
        
        let alertController = UIAlertController.init(title: alertControlText, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
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
        
        let alertControlText = NSLocalizedString("Select the denominator of the origin unit", comment: "To select the unit in a menu")
        let cancelText = NSLocalizedString("Cancel", comment: "To close a menu")
        
        let alertController = UIAlertController.init(title: alertControlText, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        guard let unitList = complementaryUnitList else {
            let errorTitleText = NSLocalizedString("Something happened 😕", comment: "Error title text")
            let errorMessageText = NSLocalizedString("Please try again selecting the dimension you want to make conversions of", comment: "Error message text")
            
            let errorAlert = UIAlertController(title: errorTitleText, message: errorMessageText, preferredStyle: .alert)
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
        
        let alertControlText = NSLocalizedString("Select destiny unit", comment: "To select the unit in a menu")
        let cancelText = NSLocalizedString("Cancel", comment: "To close a menu")
        
        let alertController = UIAlertController.init(title: alertControlText, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
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
        
        let alertControlText = NSLocalizedString("Select the denominator of the destiny unit", comment: "To select the unit in a menu")
        let cancelText = NSLocalizedString("Cancel", comment: "To close a menu")
        
        let alertController = UIAlertController.init(title: alertControlText, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        guard let unitList = complementaryUnitList else {
            let errorTitleText = NSLocalizedString("Something happened 😕", comment: "Error title text")
            let errorMessageText = NSLocalizedString("Please try again selecting the dimension you want to make conversions of", comment: "Error message text")
            
            let errorAlert = UIAlertController(title: errorTitleText, message: errorMessageText, preferredStyle: .alert)
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
                let alertTitleText = NSLocalizedString("Data is missing", comment: "Alert title text")
                let alertMessageText = NSLocalizedString("To convert the units you must have selected the origin unit, the destiny unit and entered a value.", comment: "Alert message text")
                
                let alertController = UIAlertController(title: alertTitleText, message: alertMessageText, preferredStyle: .alert)
                
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
            stepView.titleLabelText = NSLocalizedString("Conversion", comment: "Physics conversion of units")
            
            let unitToUnitSeparationText = NSLocalizedString("to", comment: "Example of use: km to mi")
            
            if let originUnitDenominatorName = selectedOriginUnitDenominator?.name,
                let destinationUnitDenominatorName = selectedDestinationUnitDenominator?.name {
                stepView.unitsTitleLabelText = "\(selectedOriginUnit?.name ?? "")/\(originUnitDenominatorName) \(unitToUnitSeparationText) \(selectedDestinationUnit?.name ?? "")/\(destinationUnitDenominatorName)"
            } else {
                stepView.unitsTitleLabelText = "\(selectedOriginUnit?.name ?? "") \(unitToUnitSeparationText) \(selectedDestinationUnit?.name ?? "")"
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
        selectDestinationUnitButton.layer.cornerRadius = cornerRadiusValue
        finishEnteringValueButton.layer.cornerRadius = cornerRadiusValue / 2
        convertButton.layer.cornerRadius = cornerRadiusValue
        
        if self.requiresCompoundUnit {
            
            selectOriginUnitDenominatorButton.isHidden = false
            selectOriginUnitDenominatorButton.layer.cornerRadius = cornerRadiusValue
            
            selectDestinationUnitDenominatorButton.isHidden = false
            selectDestinationUnitDenominatorButton.layer.cornerRadius = cornerRadiusValue
        }
    }
    
}

// MARK: - Text Field Delegate

extension UnitSelectionViewController: UITextFieldDelegate {
    
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
