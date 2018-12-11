//
//  DimensionsViewController.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 11/8/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ButtonCell"

class DimensionsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    @IBOutlet weak var buttonsCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var dimensionNames: [DimensionName]!
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsCollectionView.dataSource = self
        
        // Get all dimension names from DimensionName to identify the selected DimensionName from the indexPath
        dimensionNames = DimensionName.allCases
        
        // Sort dimensions names by the localized name
        dimensionNames.sort { (dimensionNameLeft, dimensionNameRight) -> Bool in
            dimensionNameLeft.localizedString() < dimensionNameRight.localizedString()
        }
        
        addCreditsBarButtonItem()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let inset: CGFloat = 16.0
        buttonsCollectionViewFlowLayout.itemSize = CGSize(width: buttonsCollectionView.frame.size.width / 2.5, height: buttonsCollectionView.frame.size.height / 6)
        buttonsCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        buttonsCollectionViewFlowLayout.minimumInteritemSpacing = inset
        buttonsCollectionViewFlowLayout.minimumLineSpacing = inset
    }
    
    // MARK: - Actions
    @IBAction func showAboutInformation(_ sender: Any) {
        performSegue(withIdentifier: "showAbout", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedDimension" {
            guard let conversionView = segue.destination as? UnitSelectionViewController else {
                fatalError("Could not cast UIViewController to UnitSelectionViewController")
            }
            
            guard let tappedCell = sender as? DimensionCollectionViewCell else {
                fatalError("Could not cast Any to DimensionCollectionViewCell")
            }
            
            if let tappedCellDimensionName = tappedCell.dimensionName {
                
                // Set the navigation bar title to the localized dimension
                conversionView.title = tappedCell.dimension.text
                
                conversionView.selectedDimension = tappedCellDimensionName
                
                switch tappedCellDimensionName {
                case .speed:
                    conversionView.requiresCompoundUnit = true
                default:
                    conversionView.requiresCompoundUnit = false
                }
            }
        }
    }
    
    // MARK: - Private Methods
    func addCreditsBarButtonItem() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(showAboutInformation(_:)), for: .touchUpInside)
        let infoBarButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = infoBarButton
    }
    
}

// MARK: - Collection View Data Source

extension DimensionsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dimensionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DimensionCollectionViewCell
        
        cell.dimensionName = dimensionNames[indexPath.row]
        cell.layer.cornerRadius = 16.0
        
        return cell
    }
    
}
