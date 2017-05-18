//
//  TableViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 01. 30..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var column1: UILabel!
    
    @IBOutlet var column2: UILabel!
    
    @IBOutlet var column3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
