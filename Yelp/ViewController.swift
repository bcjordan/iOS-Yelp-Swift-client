//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var client: YelpClient!
    var businesses: NSArray?
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    // Place your keys in secrets.plist
    var yelpConsumerKey: String?
    var yelpConsumerSecret: String?
    var yelpToken: String?
    var yelpTokenSecret: String?
    var yelpClient: YelpClient?
    
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
        self.yelpClient = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        self.updateSearchWithParams(["term": "thai", "ll": "37.774866,-122.394556"])
        
        var searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.text = ""
        self.navigationItem.titleView = searchBar
            
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "onFilterButton")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.updateSearchWithParams(["term": searchBar.text, "ll": "37.774866,-122.394556"])
        searchBar.resignFirstResponder()
    }
    
    func updateSearchWithParams(params: [String: String]) {
        self.yelpClient!.searchWithTerm(params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var businessesDict = response["businesses"] as NSArray
            self.businesses = Business.businessesWithDictionaries(businessesDict)
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openFilterView" {
            let filtersViewController = segue.destinationViewController as FiltersViewController
            filtersViewController.delegate = self
        }
    }
    
    func onFilterButton() {
        self.performSegueWithIdentifier("openFilterView", sender: self)
//        var vc: FiltersViewController = FiltersViewController()
//        var nvc: UINavigationController = UINavigationController(rootViewController: vc)
//        vc.delegate = self
//        self.presentViewController(nvc, animated: true, completion: nil)
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
    
    
    // FiltersViewControllerDelegate
    
    func filtersViewController(filtersViewController: FiltersViewController, filters: [String: String]) {

        self.updateSearchWithParams(filters)
    }
}

