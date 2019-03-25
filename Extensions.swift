//
//  Extensions.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/17/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit
// This extention allows an image to be set by downloading it from a url
extension UIImageView {
    public func imageFromServerURL(imageURL: URL, imageForSize: @escaping (UIImage)->Void) {
        self.image = nil
        URLSession.shared.dataTask(with:imageURL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
            return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                
                self.image = image
                
                if let dlImage = image {
                    imageForSize(dlImage)
                }
            })
            
        }).resume()
        
        
    }
    
}
