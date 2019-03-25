//
//  CollectsJSONDecoder.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/17/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation

struct collectsInfo:Decodable {
    let collects: [collects]?
}

struct collects:Decodable {
    let id: Int?
    let collection_id: Int?
    let product_id: Int?
    let featured: Bool?
    let created_at: String?
    let updated_at: String?
    let position: Int?
    let sort_value: String?
}


