//
//  CustomCollectionDataLoader.swift
//  shopify-intern-challange-Taylor-Simpson
//
//  Created by Taylor Simpson on 3/15/19.
//  Copyright © 2019 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit

// To use in the completion handler
typealias CustomCollectionCompletion = ([collection], HTTPURLResponse) -> Void
//handles the loading of  cast data.
class CustomCollectionLoader {
    private var collectionTask: URLSessionTask?
    private var session: URLSession {
        return URLSession.shared
    }
    // fetches the cast member data
    func fetchCollectionData(_ endPoint: URL?, completion: @escaping CustomCollectionCompletion)-> Void {
        guard let url = endPoint else {
            return
        }
        
       
        
        if let task = collectionTask , task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
       collectionTask = session.dataTask(with: url, completionHandler: { data, responce, error in
            
            var infoArray:[collection] = []
            guard let serverResponce = responce as? HTTPURLResponse else {
                return
            }
            guard let data = data else {
                return
            }
            defer {
                DispatchQueue.main.async {
                    completion(infoArray, serverResponce)
                }
            }
            
            // handles JSON decoding of data to use in collectionView
            
            do {
                let resultResponce = try
                    JSONDecoder().decode(custom_collections.self, from: data)
                
                
                
                guard let resultsArray = resultResponce.custom_collections else {return}
                for result in resultsArray {
                    infoArray.append(result)
                }
            } catch {
               
                print(error.localizedDescription)
                
                
            }
        })
        collectionTask?.resume()
        
    }
    
}
