//
//  DimensionsViewController.swift
//  Unit Conversion
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
    var dimensions: [String]!
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsCollectionView.dataSource = self
        
        dimensions = ["Area", "Distancia", "Peso", "Tiempo", "Velocidad", "Volumen"]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let inset: CGFloat = 16.0
        buttonsCollectionViewFlowLayout.itemSize = CGSize(width: buttonsCollectionView.frame.size.width / 2.5, height: buttonsCollectionView.frame.size.height / 6)
        buttonsCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        buttonsCollectionViewFlowLayout.minimumInteritemSpacing = inset
        buttonsCollectionViewFlowLayout.minimumLineSpacing = inset
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let conversionView = segue.destination as? ViewController else {
            fatalError("Could not cast UIViewController to ViewController")
        }
        
        guard let tappedCell = sender as? DimensionCollectionViewCell else {
            fatalError("Could not cast Any to DimensionCollectionViewCell")
        }
        
        conversionView.selectedDimension = tappedCell.dimension.text
    }
    
    // MARK: - Private Methods

}

// MARK: - Collection View Data Source

extension DimensionsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dimensions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DimensionCollectionViewCell
        
        cell.dimension.text = dimensions[indexPath.row]
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
    
}
