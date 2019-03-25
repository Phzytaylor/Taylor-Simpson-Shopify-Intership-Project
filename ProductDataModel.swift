//
//  ProductDataStruct.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/19/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewCompatible {
    
    var reuseIdentifier: String { get }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
    
}
class ProductDataModel: CollectionViewCompatible {
    
    var reuseIdentifier: String {
        return "product"
    }
    
    var title: String
    var collectionTitle: String
    var inventoryCount: [Int]
    var imageURL: String
    var downloadedImage: UIImage?
    var bodyText: String
    
    init(title: String, collectionTitle: String, inventoryCount:[Int],imageURL:String,bodyText:String) {
        self.title = title
        self.collectionTitle = collectionTitle
        self.inventoryCount = inventoryCount
        self.imageURL = imageURL
        self.bodyText = bodyText
    }
    
    func cellForCollectionView(collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? ProductsCollectionViewCell else {
            return UICollectionViewCell()
        }
        var totalCount = 0
        for count in self.inventoryCount{
            totalCount += count
        }
        cell.totalInventoryLabel.text = "Count: " + String(totalCount)
        
        if let imageURL = URL(string: imageURL){
            cell.productImage.imageFromServerURL(imageURL: imageURL) { (image) -> Void in
                self.downloadedImage = image
            }
        }
        
        cell.titleLabel.text = self.title
        cell.collectionNameLabel.text = self.collectionTitle
        cell.bodyTextLabel.text = self.bodyText
        
        return cell
    }
}
