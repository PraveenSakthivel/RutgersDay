//
//  startScreen.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/3/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "startCell"

class startScreen: UICollectionViewController, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
   let sectionInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 50.0, right: 20.0)
    var campusChange = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        if (!campusChange){
        let code = Int(arc4random_uniform(1000000000))
        UserDefaults.standard.set(code, forKey: "UID")
        UserDefaults.standard.synchronize()
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect.init(x: 0, y: 0, width: 150, height: 80)
        imageView.contentMode = .scaleAspectFit
        imageView.center = CGPoint.init(x: (self.navigationController?.navigationBar.frame.width)! / 2, y: (self.navigationController?.navigationBar.frame.height)! / 2)
        self.navigationController?.navigationBar.addSubview(imageView)
        }
        self.collectionView?.backgroundColor = UIColor.init(red: 249/255, green: 245/255, blue: 237/255, alpha: 1)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! startCell
        switch indexPath.row{
        case 0:
            cell.label.text = "New Brunswick"
            cell.img.image = UIImage.init(named: "new brunswick")
            break;
        case 1:
            cell.label.text = "Newark"
            cell.img.image = UIImage.init(named: "Rutgers Newark")
            break;
        case 2:
            cell.label.text = "Camden"
            cell.img.image = UIImage.init(named: "Rutgers Camden")
            break;
        default:
            break;
        }
        cell.img.contentMode = UIViewContentMode.scaleToFill
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (1 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth
        return CGSize(width: 270, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    override func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "startHeader",for: indexPath) as! startScreenHeader
            headerView.label.text = "Welcome to Rutgers Day! Select a Campus"
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        switch(indexPath.row){
        case 0:
            defaults.set(0, forKey: "campus")
            break;
        case 1:
            defaults.set(2, forKey: "campus")
            break;
        case 2:
            defaults.set(7, forKey: "campus")
            break;
        default:
            break;
        }
        defaults.set(true, forKey: "launchedBefore")
        defaults.synchronize()
        if(campusChange){
            let alert = UIAlertController(title: "Campus Selection Changed", message: "Please restart the app for changes to take effect", preferredStyle:  UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        performSegue(withIdentifier: "tutorial", sender: self)
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
