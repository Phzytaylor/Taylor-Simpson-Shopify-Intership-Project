//
//  CustomCillectionsCollectionViewController.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/17/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "customCollectionsCell"

class CustomCollectionsCollectionViewController: UICollectionViewController {

    @IBOutlet weak var downloadProgressIndi: UIActivityIndicatorView!
    let customCollectionDataLoader = CustomCollectionLoader()
    var customCollectionArray = [collection]()
    var dataArray:[CustomCollectionCellModel] = [CustomCollectionCellModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Custom Collections"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1934024394, green: 0.5127763152, blue: 0.2884690166, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        downloadProgressIndi.startAnimating()
        let layout = collectionViewLayout as! FlexableCollectionLayout
        layout.delegate = self
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            layout.numberOfColumns = 3
            layout.cellPadding = 5
        } else if UIApplication.shared.statusBarOrientation.isPortrait {
            layout.numberOfColumns = 2
            layout.cellPadding = 5
        }
        customCollectionDataLoader.fetchCollectionData(CustomCollectionURLConstructor()?.absoluteURL) { (collection, responce) in
           
            if responce.statusCode == 200 {
            self.dataArray = self.fetchProduct(modelArray: collection)
            self.collectionView.reloadData()
            self.downloadProgressIndi.stopAnimating()
                self.downloadProgressIndi.isHidden = true
                
            } else {
                self.downloadProgressIndi.stopAnimating()
                self.downloadProgressIndi.isHidden = true
                
                let Alert = UIAlertController(title: "Server Error", message: "The server responded \(responce.statusCode) Try again later", preferredStyle: .alert)
                
                Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(Alert, animated: true, completion: nil)
            }
        }

    }
    
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProducts"{
            guard let destinationVC = segue.destination as? ProductCollectionViewController else {
                return
            }
            if let cell = sender as? CustomCollectionsCollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                
                let id = dataArray[indexPath.row].collectionID
                let name = dataArray[indexPath.row].collectionTitle
                
                destinationVC.collectionID = String(id)
                destinationVC.productsArray.removeAll()
                destinationVC.collectionName = name
            }
            
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let model = dataArray[indexPath.item]
        
        
        return model.cellForCollectionView(collectionView:collectionView,atIndexPath:indexPath)
    }
    
    func fetchProduct(modelArray: [collection])->[CustomCollectionCellModel]{
        
        var returnArray = [CustomCollectionCellModel]()
        
        for model in modelArray {
            let title = model.title ?? "No Title"
            let productImageURL = model.image?.src ?? "No Link"
            let body = model.body_html ?? "No Information"
            let id = model.id ?? 0
            
            returnArray.append(CustomCollectionCellModel(collectionTitle: title, imageURL: productImageURL, bodyText: body, collectionID: id))
        }
        
        return returnArray
    }

    // MARK: UICollectionViewDelegate

}

extension CustomCollectionsCollectionViewController: FlexableLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = dataArray[indexPath.item]
        let image = character.collectionImage
        
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: image?.size ?? CGSize(width: 100, height: 100), insideRect: boundingRect)
        
        return rect.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let character = dataArray[indexPath.item]
        let collectionTitleHeight = heightForText(character.collectionTitle, width: width, fontStyle: .headline)
        
        let height =  collectionTitleHeight + 40
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
