//
//  DimensionCollectionViewCell.swift
//  ConversionFactors
//
//  Created by Gerardo Osio on 11/8/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class DimensionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var dimension: UILabel!
    var dimensionName: DimensionName! {
        didSet {
            self.dimension.text = dimensionName.localizedString().capitalized
        }
    }
}
