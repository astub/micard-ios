//
//  InputCell.swift
//  MiCard
//
//  Created by Jake on 7/19/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//
import UIKit

class InputCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var input: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}