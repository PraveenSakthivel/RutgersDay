//
//  TutorialImgNoButton.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 4/11/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class TutorialImgNoButton: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var img: UIImageView!
    var imgString = ""
    var index = 0
    var finished = false
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = UIImage.init(named: imgString)
        if(imgString == "t6"){
            finished = true
            button.setTitle("Continue", for: .normal)
            button.titleLabel?.font = UIFont(name: "Al Nile", size: 30)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.init(red: 81/255, green: 116/255, blue: 246/255, alpha: 1)
            button.layer.cornerRadius = 10; // this value vary as per your desire
            button.clipsToBounds = true
        }
        else{
            button.setTitle("", for: .normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clicked(_ sender: Any) {
        if(finished){
        performSegue(withIdentifier: "initial", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
