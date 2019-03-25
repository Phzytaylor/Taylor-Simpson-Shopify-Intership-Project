//
//  ViewController.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/15/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
let customCollectionDataLoader = CustomCollectionLoader()
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionDataLoader.fetchCollectionData(CustomCollectionURLConstructor()?.absoluteURL) { (collection, responce) in
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }


}

