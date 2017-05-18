//
//  TabelViewCell2.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 05. 18..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//


import UIKit

class TableViewCell2: UITableViewCell {
    
    
    @IBOutlet var column4: UILabel!
    
    @IBOutlet var column5: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
