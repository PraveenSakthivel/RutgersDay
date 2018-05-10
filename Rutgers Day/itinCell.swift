//
//  itinCell.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/21/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit



class itinCell: UITableViewCell {

    
    @IBOutlet var titleBox: UILabel!
    
    @IBOutlet var clockDisplay: UILabel!
    var color = UIView()
    var label = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
