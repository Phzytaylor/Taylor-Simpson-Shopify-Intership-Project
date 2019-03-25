//
//  CustomCollectionDecoder.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/15/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit

struct custom_collections: Decodable {
    let custom_collections: [collection]?
}

struct collection: Decodable {
    let id: Int?
    let handle: String?
    let title: String?
    let updated_at: String?
    let body_html:String?
    let published_at:String?
    let sort_order:String?
    let template_suffix: String?
    let published_scope: String?
    let admin_graphql_api_id:String?
    let image: image?
}

struct image: Decodable {

    let created_at:String?
    let alt: String?
    let width: Int?
    let height: Int?
    let src: String?
    
}
