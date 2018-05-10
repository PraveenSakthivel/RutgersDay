//
//  About.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/30/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit
import StoreKit

class About: UITableViewController, SKStoreProductViewControllerDelegate {

    var index = 0
    let titles = ["About Rutgers Day","Social Media","Rutgers App","About Rutgers", "Switch Campus", "Rutgers Day Survey"]
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! AboutCell
        let title = titles[indexPath.row]
        let img = UIImage.init(named: title)
        cell.img.image = img
        cell.img.contentMode = UIViewContentMode.scaleAspectFit
        cell.textLabel?.text = title
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 80))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        if(indexPath.row == 5){
            whiteRoundedView.backgroundColor = UIColor.red
        }
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        whiteRoundedView.layer.shadowPath = UIBezierPath(rect: whiteRoundedView.bounds).cgPath
        whiteRoundedView.layer.shouldRasterize = true
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        cell.selectionStyle = .none
        return cell
    }

    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                self?.present(storeViewController, animated: true, completion: nil)
                self?.activityIndicator.stopAnimating()
                self?.effectView.removeFromSuperview()
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        switch indexPath.row{
        case 0:
           performSegue(withIdentifier: "aboutRutgersSegue", sender: self)
           break;
        case 1:
            performSegue(withIdentifier: "socialMediaSegue", sender: self)
            break;
        case 2:
            activityIndicator("Loading")
            self.openStoreProductWithiTunesItemIdentifier(identifier: "494594693")
            break;
        case 3:
            performSegue(withIdentifier: "aboutRutgersSegue", sender: self)
            break;
        case 4:
            performSegue(withIdentifier: "changeCampus", sender: self)
            break;
        case 5:
            UIApplication.shared.open(URL(string: "https://rutgers.ca1.qualtrics.com/jfe/form/SV_byl6QWjT9pq4gpT")!, options: [:], completionHandler: nil)
        default:
            assert(true)
        }
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "aboutRutgersSegue"){
            if(index != 5){
            if(index == 0){
                let destination = segue.destination as! AboutWebpages
                destination.survey = false
                destination.page = 2
            }
            else{
                let destination = segue.destination as! AboutWebpages
                destination.survey = false
                destination.page = 1
            }
            }
        }
        else if(segue.identifier == "changeCampus"){
            let destination = segue.destination as! startScreen
            destination.campusChange = true
        }
    }

}
