//
//  Business.swift
//  Yelp
//
//  Created by Brian Jordan on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

class Business {
    var imageUrl: String?
    var name: String?
    var ratingImageUrl: String?
    var numReviews: Int?
    var address: String?
    var categories: String?
    var distance: Int?
    
    init(fromDictionary: NSDictionary) {
        self.imageUrl = fromDictionary["image_url"] as? String
        self.name = fromDictionary["name"] as? String
        self.ratingImageUrl = fromDictionary["rating_img_url"] as? String
        self.numReviews = fromDictionary["review_count"] as? Int

        var categoryArray = fromDictionary["categories"]?[0] as? NSArray
        var categoriesStrings: [String] = []
        for category in categoryArray! {
            categoriesStrings.append(category as String)
        }
        self.categories = ", ".join(categoriesStrings)
        
        var street: String = fromDictionary.valueForKeyPath("location.address")![0] as String
        var neighborhood: String = fromDictionary.valueForKeyPath("location.neighborhoods")![0] as String
        self.address = "\(street), \(neighborhood)"
        
        self.distance = fromDictionary["distance"] as? Int
    }
    
    class func businessesWithDictionaries(dictionaries: NSArray) -> NSArray {
        var businesses = NSMutableArray()
        for businessDictionary in dictionaries {
            var newBusiness = Business(fromDictionary: businessDictionary as NSDictionary)
            newBusiness.address = businessDictionary["address"] as? String
            businesses.addObject(newBusiness)
        }
        return businesses
    }
}
