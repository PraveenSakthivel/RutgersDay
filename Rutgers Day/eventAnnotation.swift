//
//  eventAnnotation.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/31/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class eventAnnotation: UIView {

    @IBOutlet var titleBox: UILabel!
    
    @IBOutlet var clock: UILabel!
    
    @IBOutlet var openButton: UIButton!
    
    var label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 50))
    
    var color = UIView()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
