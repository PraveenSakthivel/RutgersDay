//
//  searchList.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/4/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class searchList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet var loadingIcon: NVActivityIndicatorView!
    
    let url = "REDACTED"
    var ext = "0"
    var data = [event]()
    var titles = [String]()
    var searchResults = [String]()
    var index = 0
    let searchBar = UISearchController.init(searchResultsController: nil)
    var refreshControl: UIRefreshControl!
    var code = 0
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIcon.type = .ballClipRotatePulse
        loadingIcon.color = UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1)
        loadingIcon.startAnimating()
        ext = "l\(UserDefaults.standard.integer(forKey: "campus"))"
        getData()
        searchBar.searchResultsUpdater = self
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.dimsBackgroundDuringPresentation = false
        table.tableHeaderView = searchBar.searchBar
        setUpItinerary()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc
    func refresh( _ sender: AnyObject){
        titles = [String]()
        data = [event]()
        getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchResults.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (titles as NSArray).filtered(using: searchPredicate)
        searchResults = array as! [String]
        if searchResults.count == 0
        {
            searchResults = titles
        }
        
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchBar.isActive){
            return searchResults.count
        }
        return data.count
    }
    
    func getData(){
        let headers: HTTPHeaders = ["REDACTED"]
        Alamofire.request(url + ext + "?UID=IOS-\(code)",headers: headers).responseJSON { response in
                let json = (response.result.value as! NSArray)
                if(json.count != 0){
                    for i in 0...json.count - 1{
                        let dict = json[i] as! [String: Any]
                        print(dict)
                        var newEvent = event()
                        if(dict["name"] != nil){
                        newEvent.title = dict["name"] as! String
                        }
                        newEvent.eventID = Int(dict["sid"] as! String)!
                        self.titles.append(newEvent.title)
                        let time = dict["time"] as! String
                        if(time == "continuous"){
                            newEvent.time = 0
                        }
                        else{
                            if(time == ""){
                                newEvent.time = 1200
                            }else{
                                newEvent.time = Int(time.prefix(time.count - 2))!
                                if(time.contains("pm")){
                                    newEvent.time += 1200
                                }
                            }
                        }
                        self.data.append(newEvent)
                    }
                    self.data = self.data.sorted{return $0.title < $1.title }
                    self.loadingIcon.stopAnimating()
                    self.loadingIcon.isHidden = true
                    self.table.reloadData()
                }
            }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        if(searchBar.isActive){
            cell.label.text = searchResults[indexPath.row]
        }
        else{
            cell.label.text = data[indexPath.row].title
        }
        if(cell.titlelabel.tag == 0){
            cell.titlelabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 50))
            cell.titlelabel.tag = 1
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let time = Int(formatter.string(from: NSDate() as Date))!
        let eventTime = data[indexPath.row].time
        if(eventTime == 0){
            cell.titlelabel.text = "All Day"
        }
        else{
            var offset = 0
            var isPM = false
            if(data[indexPath.row].time >= 1200){
                isPM = true
                if(data[indexPath.row].time >= 1300){
                    offset = 12
                }
            }
            let minute = eventTime % 100
            let minuteS: String
            if(minute < 10){
                minuteS = "0\(minute)"
            }
            else{
                minuteS = "\(minute)"
            }
            cell.titlelabel.text = "\(eventTime / 100 - offset):\(minuteS)"
            if(!isPM){
                cell.titlelabel.text = cell.titlelabel.text! + " AM"
            }
            else{
                cell.titlelabel.text = cell.titlelabel.text! + " PM"
            }
        }
        cell.titlelabel.textAlignment = NSTextAlignment.center
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        if cell.tag != 1{
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 80))
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 2.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.2
            whiteRoundedView.layer.shadowPath = UIBezierPath(rect: whiteRoundedView.bounds).cgPath
            whiteRoundedView.layer.shouldRasterize = true
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            cell.selectionStyle = .none
            let yellowRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
            if(eventTime == 0){
                yellowRoundedView.layer.backgroundColor = UIColor.green.cgColor
            }
            else{
                if(time > eventTime){
                    yellowRoundedView.layer.backgroundColor = UIColor.red.cgColor
                }
                else if (eventTime - time <= 100){
                    yellowRoundedView.layer.backgroundColor = UIColor.yellow.cgColor
                }
                else{
                    yellowRoundedView.layer.backgroundColor = UIColor.green.cgColor
                }
            }
            yellowRoundedView.layer.masksToBounds = false
            yellowRoundedView.layer.cornerRadius = 2.0
            yellowRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            yellowRoundedView.layer.shadowOpacity = 0.2
            yellowRoundedView.layer.shadowPath = UIBezierPath(rect: yellowRoundedView.bounds).cgPath
            yellowRoundedView.layer.shouldRasterize = true
            cell.color = yellowRoundedView
            cell.time.addSubview(yellowRoundedView)
            cell.time.sendSubview(toBack: yellowRoundedView)
            cell.time.insertSubview(cell.titlelabel, aboveSubview: yellowRoundedView)
            cell.tag = 1
        }
        else{
            if(eventTime == 0){
                cell.color.layer.backgroundColor = UIColor.green.cgColor
            }
            else{
                if(time > eventTime){
                    cell.color.layer.backgroundColor = UIColor.red.cgColor
                }
                else if (eventTime - time <= 100){
                    cell.color.layer.backgroundColor = UIColor.yellow.cgColor
                }
                else{
                    cell.color.layer.backgroundColor = UIColor.green.cgColor
                }
            }
        }
        let dayOf = Date.init()
        let cal = Calendar.current
        let month = cal.component(.month, from: dayOf)
        let day = cal.component(.day, from: dayOf)
        if(month != 4 || day != 28){
            cell.color.layer.backgroundColor = UIColor.green.cgColor
        }
        return cell
    }
    

    /*
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
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.isActive = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.isActive = false
        let destination = segue.destination as! FullEventView
        destination.titleString = data[index].title
        destination.eventID = data[index].eventID
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchBar.isActive){
            for i in 0...data.count{
                if(searchResults[indexPath.row] == data[i].title){
                    index = i
                    searchBar.isActive = false
                    break;
                }
            }
        }
        else{
        index = indexPath.row
        }
        performSegue(withIdentifier: "searchEventView", sender: self)
    }
}
