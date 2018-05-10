//
//  clockCell.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 2/19/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class clockCell: UITableViewCell {
    
    
    @IBOutlet var titleBox: UILabel!
    
    @IBOutlet var DistanceMeter: UILabel!
    var color = UIView()
    var label = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        label.tag = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
