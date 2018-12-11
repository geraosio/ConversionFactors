//
//  AboutViewController.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 11/28/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var creditsTextView: UITextView!
    @IBOutlet weak var dismissViewButton: UIButton!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTextView()
        
        dismissViewButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - Actions
    
    @IBAction func dismissAboutViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    func loadTextView() {
        
        let creditsText = NSLocalizedString("Conversion Factors is distributed as is for free. It's distribution and use for profit is prohibited. To learn more tap here.\n\nCreated by @edlgg and @geraosio.", comment: "License text")
        let creditsAttributedString = NSMutableAttributedString(string: creditsText)
        
        // Add hyperlink to Github profile page
        if let range = creditsText.range(of: "@edlgg") {
            let location = range.lowerBound.encodedOffset
            let length = range.upperBound.encodedOffset - location
            creditsAttributedString.addAttribute(.link, value: "https://github.com/edlgg", range: NSRange(location: location, length: length))
        }
        
        // Add hyperlink to Github profile page
        if let range = creditsText.range(of: "@geraosio") {
            let location = range.lowerBound.encodedOffset
            let length = range.upperBound.encodedOffset - location
            creditsAttributedString.addAttribute(.link, value: "https://github.com/geraosio", range: NSRange(location: location, length: length))
        }
        
        // Add hyperlink to Privacy Policy
        if let range = creditsText.range(of: NSLocalizedString("tap here", comment: "To open the Privacy Policy website in Safari")) {
            let location = range.lowerBound.encodedOffset
            let length = range.upperBound.encodedOffset - location
            creditsAttributedString.addAttribute(.link, value: "https://geraosio.github.io/ConversionFactors/", range: NSRange(location: location, length: length))
        }
        
        creditsTextView.attributedText = creditsAttributedString
        let newFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: 17.0)
        creditsTextView.font = newFont
    }

}

// MARK: - Text View Delegate Methods
extension AboutViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}
