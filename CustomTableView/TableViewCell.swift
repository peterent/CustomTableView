//
//  TableViewCell.swift
//  CustomTableView
//
//  Created by Peter Ent on 12/5/19.
//  Copyright © 2019 Peter Ent. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subheading: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
