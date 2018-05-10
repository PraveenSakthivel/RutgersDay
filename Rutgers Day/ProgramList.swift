//
//  ProgramList.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 2/19/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import NVActivityIndicatorView

class ProgramList: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet var loadingIcon: NVActivityIndicatorView!
    
    @IBOutlet var table: UITableView!
    var result = event()
    let locationManager = CLLocationManager()
    var loc = CLLocation.init(latitude: 41, longitude: -75)
    var url = "REDACTED"
    let itemUrl = "REDACTED"
    var code = 0
    var ext = "8"
    var index = 0
    let sectionTitles = ["1", "A","B","C","D", "E", "F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var sectionData = [[event]].init(repeating: [event](), count: 27)
    var data = [event]()
    var selector = UISegmentedControl()
    var dataCA = [[event]].init(repeating: [event](), count: 27)
    var dataBusch = [[event]].init(repeating: [event](), count: 27)
    var dataCD = [[event]].init(repeating: [event](), count: 27)
    var refreshControl: UIRefreshControl!
    var campusSelect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(ext.count == 3){
            campusSelect = true
        }
        if(campusSelect){
            selector.insertSegment(withTitle: "Cook/Douglass", at: 0, animated: true)
            selector.insertSegment(withTitle: "College Avenue", at: 1, animated: true)
            selector.insertSegment(withTitle: "Busch", at: 2, animated: true)
            selector.addTarget(self, action: #selector(reloadData), for: .primaryActionTriggered)
            selector.frame = CGRect.init(x: 0, y: 0, width: table.frame.width, height: 30)
            selector.selectedSegmentIndex = 0
            table.tableHeaderView = selector
        }
        loadingIcon.type = .ballClipRotatePulse
        loadingIcon.color = UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1)
        loadingIcon.startAnimating()
        if(ext == "bigR" || ext == "scarletstage"){
            url = "https://api.rutgersday.rutgers.edu/"
        }
        code = UserDefaults.standard.integer(forKey: "UID")
        getData()
        refreshControl = UIRefreshControl()
        table.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ProgramList.refresh(_:)), for: UIControlEvents.valueChanged)
        setUpItinerary()
        // Do any additional setup after loading the view.
    }
    @objc
    func refresh( _ sender: AnyObject){
        getData()
        refreshControl.endRefreshing()
    }
    
    @objc
    func reloadData(){
        table.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(campusSelect){
            switch selector.selectedSegmentIndex{
            case 0:
                return dataCD[section].count
            case 1:
                return dataCA[section].count
            case 2:
                return dataBusch[section].count
            default:
                assert(true)
            }
        }
        return sectionData[section].count;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(campusSelect){
            switch selector.selectedSegmentIndex{
            case 0:
                data = dataCD[indexPath.section]
            case 1:
                data = dataCA[indexPath.section]
            case 2:
                data = dataBusch[indexPath.section]
            default:
                assert(true)
            }
        }else{
        data = sectionData[indexPath.section]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "clockCell", for: indexPath) as! clockCell
        if(cell.label.tag == 0){
        cell.label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 50))
        cell.label.tag = 1
        }
        cell.titleBox.text = data[indexPath.row].title
        cell.DistanceMeter.textAlignment = NSTextAlignment.right
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let time = Int(formatter.string(from: NSDate() as Date))!
        let eventTime = data[indexPath.row].time
        if(eventTime == 0){
            cell.label.text = "All Day"
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
        cell.label.text = "\(eventTime / 100 - offset):\(minuteS)"
        if(!isPM){
            cell.label.text = cell.label.text! + " AM"
        }
        else{
            cell.label.text = cell.label.text! + " PM"
        }
        }
        cell.label.textAlignment = NSTextAlignment.center
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
        cell.DistanceMeter.addSubview(yellowRoundedView)
        cell.DistanceMeter.sendSubview(toBack: yellowRoundedView)
        cell.DistanceMeter.insertSubview(cell.label, aboveSubview: yellowRoundedView)
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
    
    func getData(){
        let headers: HTTPHeaders = ["REDACTED"]
        Alamofire.request(url + ext + "?UID=IOS-\(code)",headers: headers).responseJSON { response in
                let json = (response.result.value as! NSArray)
            if(json.count != 0){
            self.data = [event]()
            for i in 0...json.count - 1{
                let dict = json[i] as! [String: Any]
                var newEvent = event()
                newEvent.title = dict["name"] as! String
                newEvent.eventID = Int(dict["sid"] as! String)!
                newEvent.campus = Int(dict["campus"] as! String)!
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
            self.insertData()
            self.loadingIcon.stopAnimating()
            self.loadingIcon.isHidden = true
            self.table.reloadData()
            }
            }
    }
    
    func insertData(){
        sectionData = [[event]].init(repeating: [event](), count: 27)
        dataCA = [[event]].init(repeating: [event](), count: 27)
        dataBusch = [[event]].init(repeating: [event](), count: 27)
        dataCD = [[event]].init(repeating: [event](), count: 27)
        if(campusSelect){
            for element in data{
                for i in 1...26{
                    if(element.title.prefix(1).uppercased() == sectionTitles[i]){
                        switch element.campus{
                        case 5:
                            dataCD[i].append(element)
                        case 6:
                            dataCA[i].append(element)
                        case 8:
                            dataBusch[i].append(element)
                        default:
                            assert(true)
                        }
                    }
                    else if(i == 26){
                        switch element.campus{
                        case 5:
                            dataCD[0].append(element)
                        case 6:
                            dataCA[0].append(element)
                        case 8:
                            dataBusch[0].append(element)
                        default:
                            assert(true)
                        }
                    }
                }
            }
        }
        else{
        for element in data{
            for i in 1...26{
                if(element.title.prefix(1).uppercased() == sectionTitles[i]){
                    sectionData[i].append(element)
                }
                else if(i == 26){
                    sectionData[0].append(element)
                }
            }
        }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FullEventView
        destination.titleString = result.title
        destination.eventID = result.eventID
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if campusSelect{
            switch selector.selectedSegmentIndex{
            case 0:
                result = dataCD[indexPath.section][indexPath.row]
            case 1:
                result = dataCA[indexPath.section][indexPath.row]
            case 2:
                result = dataBusch[indexPath.section][indexPath.row]
            default:
                assert(true)
            }
        }else{
        result = sectionData[indexPath.section][indexPath.row]
        }
        performSegue(withIdentifier: "showEvent", sender: self)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionTitles.startIndex.distance(to: sectionTitles.index(of: title)!)
    }

}
struct event{
        var title = ""
        var coordinate = CLLocation.init(latitude: 41, longitude: -75)
        var description = ""
        var time = 0
        var interests = ["maps"]
        var eventID = 0
        var campus = 0
        init(){
        }
        init?(dictionary : [String:Any]) {
            self.title = dictionary["title"] as! String
            self.time = dictionary["time"] as! Int
            self.eventID = dictionary["eventID"] as! Int
            self.coordinate = dictionary["coordinate"] as! CLLocation
            self.campus = dictionary["campus"] as! Int
        }
        var propertyListRepresentation : [String:Any] {
            return ["title" : title, "time" : time,"eventID" : eventID, "coordinate" : coordinate, "campus" : campus]
        }
}
