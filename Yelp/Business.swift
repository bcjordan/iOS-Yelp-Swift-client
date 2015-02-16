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
    var distance: CGFloat?
    
    init(fromDictionary: NSDictionary) {
        self.imageUrl = fromDictionary["image_url"] as? String
        self.name = fromDictionary["name"] as? String
        self.ratingImageUrl = fromDictionary["rating_img_url"] as? String
        self.numReviews = fromDictionary["review_count"] as? Int

        if let categoryArray = fromDictionary["categories"] as? NSArray {
            var categoriesStrings: [String] = []
            for category in categoryArray {
                if (category.length > 0) {
                    categoriesStrings.append(category[0] as String)
                }
            }
            self.categories = ", ".join(categoriesStrings)
        } else {
            self.categories = ""
        }
        
        if let streetArray: AnyObject = fromDictionary.valueForKeyPath("location.address") {
            var street: String = fromDictionary.valueForKeyPath("location.address")![0] as String
            var neighborhood: String = fromDictionary.valueForKeyPath("location.neighborhoods")![0] as String
            self.address = "\(street), \(neighborhood)"
        } else {
            self.address = ""
        }
        
        var metersPerMile: CGFloat = 0.000621371

        self.distance = metersPerMile * (fromDictionary["distance"] as? CGFloat)!
    }
    
    class func businessesWithDictionaries(dictionaries: NSArray) -> NSArray {
        var businesses = NSMutableArray()
        for businessDictionary in dictionaries {
            var newBusiness = Business(fromDictionary: businessDictionary as NSDictionary)
            businesses.addObject(newBusiness)
        }
        return businesses
    }
}
