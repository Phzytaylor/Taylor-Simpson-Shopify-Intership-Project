//
//  CustomCollectionsCollectionViewCell.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/17/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import UIKit

class CustomCollectionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customCollectionsLabel: UILabel!
    @IBOutlet weak var customCollectionsImage: UIImageView!
     @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(red: 0.5, green: 0.47, blue: 0.25, alpha: 1.0).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customCollectionsImage.image = nil
        customCollectionsLabel.text = ""
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! FlexableCollectionLayoutAttributes
        imageViewHeightConstraint.constant = attributes.imageHeight
    }
}
