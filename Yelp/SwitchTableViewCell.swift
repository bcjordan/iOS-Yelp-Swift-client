//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Brian Jordan on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchCell(cell: SwitchTableViewCell, updatedValue: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet var toggleSwitch: UISwitch!
    @IBOutlet var titleLabel: UILabel!
    
    var delegate: SwitchCellDelegate?
    var on: Bool?
    
    func setOn(nowOn: Bool) {
        self.on = nowOn
        self.toggleSwitch.on = nowOn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }

    @IBAction func switchValueChanged(sender: UISwitch) {
        self.delegate?.switchCell(self, updatedValue: sender.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
