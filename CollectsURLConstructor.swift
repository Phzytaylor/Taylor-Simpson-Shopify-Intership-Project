//
//  CollectsURLConstructor.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/18/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation



func CollectsURLConstructor(collectionID: String) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "shopicruit.myshopify.com"
    components.path = "/admin/collects.json"
    components.queryItems = [URLQueryItem(name: "collection_id", value: collectionID),URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "access_token", value: "c32313df0d0ef512ca64d5b336a0d7c6")]
    
    // Getting a URL from our components is as simple as
    // accessing the 'url' property.
    let url = components.url
    
    return url
    
}
