//
//  SocialMedia.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/30/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit

class SocialMedia: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedFacebook(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/RutgersDay/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func clickedTwitter(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://twitter.com/RutgersU")!, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func clickedInstagram(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/rutgersu/?hl=en")!, options: [:], completionHandler: nil)
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
