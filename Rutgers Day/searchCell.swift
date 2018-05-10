//
//  searchCell.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/4/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    
    @IBOutlet var time: UILabel!
    var color = UIView()
    var titlelabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.tag = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
