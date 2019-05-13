//
//  TableViewCell10.swift
//  ParPoApp
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//


import UIKit

class TableViewCell10: UITableViewCell {
    
    @IBOutlet weak var lblPri: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
