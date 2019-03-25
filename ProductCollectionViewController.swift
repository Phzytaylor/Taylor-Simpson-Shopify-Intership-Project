//
//  ProductCollectionViewController.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/18/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "Cell"

class ProductCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var downloadProgressIndi: UIActivityIndicatorView!
    
    
    let collectsDataLoader = CollectsLoader()
    let productsDataLoader = ProductsLoader()
    var collectionID = ""
    var productsArray:[Products] = [Products]()
    var dataArray:[ProductDataModel] = [ProductDataModel]()
    var collectionName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = collectionName
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1934024394, green: 0.5127763152, blue: 0.2884690166, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.downloadProgressIndi.startAnimating()
        
        let layout = collectionViewLayout as! FlexableCollectionLayout
        layout.delegate = self
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            layout.numberOfColumns = 3
            layout.cellPadding = 5
        } else if UIApplication.shared.statusBarOrientation.isPortrait {
        layout.numberOfColumns = 2
            layout.cellPadding = 5
        }
        collectsDataLoader.fetchCollectionData(CollectsURLConstructor(collectionID: collectionID)) { (collectsArray, responce) in
            
            if responce.statusCode == 200 {
            var productIDS = [String]()
            for id in collectsArray{
                guard let productID = id.product_id else {
                    continue
                }
                
                let productIDString = String(productID)
               
               productIDS.append(productIDString)
                
                
            }
            
            self.productsDataLoader.fetchCollectionData(ProductsURLConstructor(collectionIDS: productIDS), completion: { (products, responce) in
                if responce.statusCode == 200 {
                self.productsArray = products
                self.dataArray = self.fetchProduct(modelArray: products)
                self.collectionView.reloadData()
                self.downloadProgressIndi.stopAnimating()
                    self.downloadProgressIndi.isHidden = true
                    
                } else{
                    let Alert = UIAlertController(title: "Server Error", message: "The server responded \(responce.statusCode). Please try again later", preferredStyle: .alert)
                    
                    Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                }
            })
            } else {
                let Alert = UIAlertController(title: "Server Error", message: "The server responded \(responce.statusCode). Please try again later", preferredStyle: .alert)
                
                Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(Alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    func fetchProduct(modelArray: [Products])->[ProductDataModel]{
        
        var returnArray = [ProductDataModel]()
       
        for model in modelArray {
          let title = model.title ?? "No Title"
            let collectionTitle = collectionName ?? "No Collection Title"
            let productImageURL = model.image?.src ?? "No Link"
            let varients = model.variants ?? []
            
            let stock = varients.compactMap({$0.inventory_quantity})
            let body = model.body_html ?? "No Information"
            
            returnArray.append(ProductDataModel(title: title, collectionTitle: collectionTitle, inventoryCount: stock, imageURL: productImageURL, bodyText: body))
        }
        
        return returnArray
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let model = dataArray[indexPath.row]
      
    
        return model.cellForCollectionView(collectionView:collectionView,atIndexPath:indexPath)
    }

}

extension ProductCollectionViewController: FlexableLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let character = dataArray[indexPath.item]
        let image = character.downloadedImage

        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: image?.size ?? CGSize(width: 100, height: 100), insideRect: boundingRect)
        
        return rect.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = dataArray[indexPath.item]
        let collectionTitleHeight = heightForText(character.collectionTitle, width: width, fontStyle: .headline)
        let titleHeight = heightForText(character.title, width: width, fontStyle: .headline)
        let countText = String(character.inventoryCount.reduce(0,+))
        let countHeight = heightForText(countText, width: width, fontStyle: .footnote)
        let bodyHeight = heightForText(character.bodyText, width: width, fontStyle: .body)
        
        let height = titleHeight + collectionTitleHeight + countHeight + bodyHeight + bodyHeight/2 + 25
        return height
    }
    
    func heightForText(_ text: String, width: CGFloat, fontStyle: UIFont.TextStyle) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: fontStyle)
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
        
        coordinator.animate(alongsideTransition: nil) { _ in
            let layout = FlexableCollectionLayout()
            layout.delegate = self
            
            if UIDevice.current.orientation.isLandscape {
            layout.numberOfColumns = 3
                layout.cellPadding = 5
                
                
                
            } else if UIDevice.current.orientation.isPortrait {
                layout.numberOfColumns = 2
                layout.cellPadding = 5
                
            }
            
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(layout, animated: true)
            self.collectionView.reloadData()
        }
        
       
    }
    
    
    
    
    
}
