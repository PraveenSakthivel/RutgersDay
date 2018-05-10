//
//  parkingCell.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/9/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class parkingCell: UITableViewCell {

    
    @IBOutlet var label: UILabel!
    @IBOutlet var distanceMeter: UILabel!
    
    var color = UIView()
    var distance = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
