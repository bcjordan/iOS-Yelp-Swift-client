//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.title = "Yelp"
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var businessesDict = response["businesses"] as NSArray
            self.businesses = Business.businessesWithDictionaries(businessesDict)
            self.tableView.reloadData()
            print(businessesDict)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("businesscell") as BusinessCellTableViewCell
        cell.setBusiness(self.businesses![indexPath.row] as Business)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses == nil {
            return 0
        }
        return self.businesses!.count
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

