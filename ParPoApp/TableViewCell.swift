//
//  TableViewCell.swift
//  ParPoApp
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCiudad: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
