//
//  CustomCollectionCellModel.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/24/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionCellModel : CollectionViewCompatible {
    var reuseIdentifier: String  {
        return "customCollectionsCell"
    }
    
    var collectionTitle: String
    var collectionImage: UIImage?
    var imageURL: String
    var bodyText: String
    var collectionID: Int
    
    init(collectionTitle: String, imageURL:String, bodyText: String, collectionID: Int) {
        self.collectionTitle = collectionTitle
        self.imageURL = imageURL
        self.bodyText = bodyText
        self.collectionID = collectionID
    }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? CustomCollectionsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let imageURL = URL(string: imageURL){
            cell.customCollectionsImage.imageFromServerURL(imageURL: imageURL) { (image) -> Void in
                self.collectionImage = image
            }
        }
        
        cell.customCollectionsLabel.text = self.collectionTitle
        cell.customCollectionsImage.image = self.collectionImage
        
        
        return cell
        
    }
    
    
}
