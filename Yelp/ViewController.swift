//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var client: YelpClient!
    var businesses: NSArray?
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    // Place your keys in secrets.plist
    var yelpConsumerKey: String?
    var yelpConsumerSecret: String?
    var yelpToken: String?
    var yelpTokenSecret: String?
    
    required init(coder aDecoder: NSCoder) {
        var myDict: NSDictionary?
        var path: String?
        path = NSBundle.mainBundle().pathForResource("secrets", ofType: "plist")
        myDict = NSDictionary(contentsOfFile: path!)
        if let dict = myDict {
            yelpConsumerKey = myDict?["yelpConsumerKey"] as NSString
            yelpConsumerSecret = myDict?["yelpConsumerSecret"] as NSString
            yelpToken = myDict?["yelpToken"] as NSString
            yelpTokenSecret = myDict?["yelpTokenSecret"] as NSString
        }
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var businessesDict = response["businesses"] as NSArray
            self.businesses = Business.businessesWithDictionaries(businessesDict)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

