//
//  StepsViewController.swift
//  Unit Conversion
//
//  Created by Gerardo Osio on 11/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class StepsViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unitsTitleLabel: UILabel!
    @IBOutlet weak var titleDividerView: UIView!
    @IBOutlet weak var stepsScrollView: UIScrollView!
    @IBOutlet weak var stepsPageControl: UIPageControl!
    @IBOutlet weak var closeStepsViewButton: UIButton!
    
    var steps = [Step]()
    var results: [ConversionStep]!
    var titleLabelText: String!
    var unitsTitleLabelText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change title to dimension
        titleLabel.text = titleLabelText.capitalized
        unitsTitleLabel.text = unitsTitleLabelText
        
        // Get the step's information from the results ConversionStep's array
        loadSteps()
        
        // Set the scroll view's content
        setupScrollView()
        
        // Setup page control
        stepsPageControl.numberOfPages = steps.count
        stepsPageControl.currentPage = 0
        
        // Setup view elements
        titleDividerView.layer.cornerRadius = 1.5
        closeStepsViewButton.layer.cornerRadius = 8.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set the scroll view's content every time the device position changes
        setupScrollView()
    }
    
    // MARK: - Actions
    
    @IBAction func closeStepsView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Set the current page in the page control, calculating the position of the current step
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        stepsPageControl.currentPage = Int(pageIndex)
    }
    
    // MARK: - Private Methods
    
    private func loadSteps() {
        
        for i in 0..<results.count {
            
            // Get the UIView from Step.xib
            let step: Step = Bundle.main.loadNibNamed("Step", owner: self, options: nil)?.first as! Step
            
            // Set the step number
            step.stepTitleLabel.text = "Paso \(i + 1)"
            
            // Show the conversion factor title, multiplication sign and stack view if present, hide if not
            if let stepConversionFactor = results[i].conversionFactor {
                
                // Show conversion factor elements and multiplication sign
                step.conversionFactorTitleLabel.isHidden = false
                step.multiplicationSignImageView.isHidden = false
                step.conversionFactorStackView.isHidden = false
                step.conversionFactorDividerLineView.layer.cornerRadius = 1.0
                
                // Set the title text to the conversion factor as equation
                step.conversionFactorTitleLabel.text = stepConversionFactor.description()
                
                // Set the conversion factor values in numerator and denominator labels
                step.conversionFactorNumeratorLabel.text = "\(stepConversionFactor.numeratorMagnitude.formatted) \(stepConversionFactor.numeratorUnitName)"
                step.conversionFactorDenominatorLabel.text = "\(stepConversionFactor.denominatorMagnitude.formatted) \(stepConversionFactor.denominatorUnitName)"
            } else {
                
                // Hide conversion factor elements and multiplication sign
                step.conversionFactorTitleLabel.isHidden = true
                step.multiplicationSignImageView.isHidden = true
                step.conversionFactorStackView.isHidden = true
            }
            
            // Set the magnitude with at most four decimal digits
            step.magnitudeLabel.text = results[i].magnitude.formatted
            
            // Setup the step's unit(s)
            step.magnitudeNumeratorUnitLabel.text = results[i].numeratorName
            
            // Show the divider line and denominator label if present, hide if not
            if let unwrappedDenominatorName = results[i].denominatorName {
                
                // Show unit divider line and denominator label
                step.magnitudeUnitFractionDividerLineView.isHidden = false
                step.magnitudeUnitFractionDividerLineView.layer.cornerRadius = 1.0
                step.magnitudeDenominatorUnitLabel.isHidden = false
                
                // Set the denominator label text as the denominator unit name of the step
                step.magnitudeDenominatorUnitLabel.text = unwrappedDenominatorName
            } else {
                
                // Hide the unit divider and denominator label
                step.magnitudeUnitFractionDividerLineView.isHidden = true
                step.magnitudeDenominatorUnitLabel.isHidden = true
            }
            
            // Store in the steps array
            steps.append(step)
        }
    }
    
    private func setupScrollView() {
        
        // Set the view controller as the scroll view's delegate
        self.stepsScrollView.delegate = self
        
        // Set the scroll view's size the same as the view controller
        self.stepsScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        // Enable moving between pages
        self.stepsScrollView.isPagingEnabled = true
        
        // Place each step in one line horizontally with view.frame.width separation
        for i in 0 ..< steps.count {
            steps[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            self.stepsScrollView.addSubview(steps[i])
        }
        
        // Set the scroll view's horizontal size as the total steps multiplied by the view frame's width
        self.stepsScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(steps.count), height: view.frame.height)
    }

}
