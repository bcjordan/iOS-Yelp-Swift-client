//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Brian Jordan on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersViewController:FiltersViewController, filters: [String: String])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: FiltersViewControllerDelegate?
    var filters: NSDictionary? = NSDictionary()
    
    var categories: [[String: String]]?
    var sorts: [[String: String]] = [
        ["name": "Best Match", "code": "sort", "value": "0"],
        ["name": "Distance", "code": "sort", "value": "1"],
        ["name": "Highest Rated", "code": "sort", "value": "2"]
    ]
    var distances: [[String: String]] = [
        ["name": "Half mile", "code": "radius_filter", "value": "804.67200"],
        ["name": "1 mile", "code": "radius_filter", "value": "1609.344"],
        ["name": "2 miles", "code": "radius_filter", "value": "3218.688"]
    ]
    var deals: [[String: String]] = [
        ["name": "Deals only", "code": "deals_filter", "value": "true"]
    ]
    
    var selectedCategories: NSMutableSet?
    var selectedSorts: NSMutableSet?
    var selectedDistances: NSMutableSet?
    var selectedDeals: NSMutableSet?
    
    let nameCategories = "Categories"
    let nameSort = "Sort"
    let nameDistance = "Distance"
    let nameDeals = "Deals"
    let sectionNames = ["Categories", "Sort", "Distance", "Deals"]
    
    func getFilters() -> [String: String] {
        var filters = [String: String]()
        filters["ll"] = "37.774866,-122.394556"
        var names = [String]()
        
        if (self.selectedCategories!.count >= 0) {
            for category in selectedCategories! {
                names.append((category as NSDictionary)["code"] as NSString)
            }
            var categoryFilter: String = ",".join(names)
            filters["category_filter"] = categoryFilter
        }
        
        if (self.selectedSorts!.count >= 0) {
            for item in selectedSorts! {
                let value = item["value"] as NSString
                let key = item["code"] as NSString
                filters[key] = "\(value)"
            }
        }
        
        if (self.selectedDistances!.count >= 0) {
            for item in selectedDistances! {
                let value = item["value"]  as NSString
                let key = item["code"] as NSString
                filters[key] = "\(value)"
            }
        }
        
        if (self.selectedDeals!.count >= 0) {
            for item in selectedDeals! {
                let value = item["value"]  as NSString
                let key = item["code"] as NSString
                filters[key] = "\(value)"
            }
        }
        return filters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedCategories = NSMutableSet()
        self.selectedSorts = NSMutableSet()
        self.selectedDistances = NSMutableSet()
        self.selectedDeals = NSMutableSet()
        
        self.initCategories()
    }
    
    func initCategories() {
        self.categories = [
            ["name": "African", "code": "african"],
            ["name": "American (New)", "code": "newamerican"],
            ["name": "Barbeque", "code": "bbq"],
            ["name": "Brazilian", "code": "brazilian"]
        ]
    }
    
    
    @IBAction func onApplyPress(sender: AnyObject) {
        self.delegate?.filtersViewController(self, filters: self.getFilters())
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancelPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Switch cell delegate
    
    func switchCell(cell: SwitchTableViewCell, updatedValue: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        switch (sectionNames[indexPath.section]) {
        case nameCategories:
            if (updatedValue) {
                self.selectedCategories!.addObject(self.categories![indexPath.row])
            } else {
                self.selectedCategories!.removeObject(self.categories![indexPath.row])
            }
        case nameSort:
            if (updatedValue) {
                self.selectedSorts!.addObject(self.sorts[indexPath.row])
            } else {
                self.selectedSorts!.removeObject(self.sorts[indexPath.row])
            }
        case nameDistance:
            if (updatedValue) {
                self.selectedDistances!.addObject(self.distances[indexPath.row])
            } else {
                self.selectedDistances!.removeObject(self.distances[indexPath.row])
            }
        case nameDeals:
            if (updatedValue) {
                self.selectedDeals!.addObject(self.deals[indexPath.row])
            } else {
                self.selectedDeals!.removeObject(self.deals[indexPath.row])
            }
        default:
            print("Default")
        }
    }
    
    // Table View
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let switchCell: SwitchTableViewCell = tableView.dequeueReusableCellWithIdentifier("switchcell") as SwitchTableViewCell
        switchCell.delegate = self
        switch (sectionNames[indexPath.section]) {
        case nameCategories:
            switchCell.setOn(self.selectedCategories!.containsObject(self.categories![indexPath.row]))
            switchCell.titleLabel.text = self.categories![indexPath.row]["name"]
        case nameSort:
            switchCell.setOn(self.selectedSorts!.containsObject(self.sorts[indexPath.row]))
            switchCell.titleLabel.text = self.sorts[indexPath.row]["name"]
        case nameDistance:
            switchCell.setOn(self.selectedDistances!.containsObject(self.distances[indexPath.row]))
            switchCell.titleLabel.text = self.distances[indexPath.row]["name"]
        case nameDeals:
            switchCell.setOn(self.selectedDeals!.containsObject(self.deals[indexPath.row]))
            switchCell.titleLabel.text = self.deals[indexPath.row]["name"]
        default:
            return switchCell
        }
        return switchCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (sectionNames[section]) {
        case nameCategories:
            return self.categories!.count
        case nameSort:
            return self.sorts.count
        case nameDistance:
            return self.distances.count
        case nameDeals:
            return self.deals.count
        default:
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

}
