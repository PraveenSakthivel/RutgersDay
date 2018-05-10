//
//  TabBarController.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/23/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1)
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect.init(x: 0, y: 0, width: 150, height: 80)
        imageView.contentMode = .scaleAspectFit
        imageView.center = CGPoint.init(x: (self.navigationController?.navigationBar.frame.width)! / 2, y: ((self.navigationController?.navigationBar.frame.height)! / 2) + 8)
        let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(displayCredits))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longpress)
        self.navigationController?.navigationBar.addSubview(imageView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc
    func displayCredits(){
        let alert = UIAlertController(title: "Rutgers Day App Designed by Praveen Sakthivel", message: "Rutgers University CS/ECE 2021", preferredStyle:  UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIViewController{
    func setUpItinerary(){
        let navicon = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        navicon.setImage(defaultMenuImage(), for: UIControlState.normal)
        let menu = UIBarButtonItem(customView: navicon)
        self.tabBarController?.navigationItem.rightBarButtonItem = menu
        self.navigationItem.rightBarButtonItem = menu
        navicon.addTarget(self, action: #selector(displayItinerary), for: .touchUpInside)
    }
    
    func camNewCoordinate(campus: Int) -> CLLocation{
        if(campus == 2){
            return CLLocation.init(latitude: 40.742092, longitude: -74.174915)
        }
        else{
            return CLLocation.init(latitude: 39.948664, longitude: -75.122630)
        }
    }
    
    @objc
    func displayItinerary(){
        if (self.isKind(of: searchList.classForCoder())){
            (self as! searchList).searchBar.isActive = false
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "itin") as! Itinerary
        popoverContent.parentController = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popover?.sourceView = self.view
        nav.navigationBar.barTintColor = UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1)
        self.present(nav, animated: true, completion: nil)
    }
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
    }
}
