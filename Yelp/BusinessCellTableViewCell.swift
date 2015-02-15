//
//  BusinessCellTableViewCell.swift
//  Yelp
//
//  Created by Brian Jordan on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCellTableViewCell: UITableViewCell {

    var business: Business?
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var moneyAmountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setBusiness(newBusiness:Business) {
        self.business = newBusiness;
        self.thumbImageView.setImageWithURL(NSURL(string: newBusiness.imageUrl!))
        self.nameLabel.text = newBusiness.name
        self.ratingImageView.setImageWithURL(NSURL(string: newBusiness.ratingImageUrl!))
        self.ratingLabel.text = "\(newBusiness.numReviews!) reviews"
        self.addressLabel.text = "\(newBusiness.address!)"
        self.distanceLabel.text =  NSString(format: "%.2f mi", newBusiness.distance!)
    }
    
}
