//
//  FullEventView.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 2/20/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class FullEventView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    let locationManager = CLLocationManager()
    
    var first = 0

    @IBOutlet var map: MKMapView!
    
    @IBOutlet var titlebox: UILabel!
    
    @IBOutlet var descbox: UITextView!
    
    @IBOutlet var interestsTable: UITableView!
    
    var coordinate = CLLocationCoordinate2D.init(latitude: 40.505, longitude: -74.45)
    
    var titleString = "Sample Title"
    
    var descString = "Program information unavailable at this time"
    
    var interests = ["Food"]
    
    let url = "https://api.rutgersday.rutgers.edu/item/"
    
    var eventID = 0
    
    var time = 0
    
    var Campus = 0
    
    var eventCampus = 0
    
    var code = 0
    let isEvent = true
    override func viewDidLoad() {
        super.viewDidLoad()
        code = UserDefaults.standard.integer(forKey: "UID")
        Campus = UserDefaults.standard.integer(forKey: "campus")
        titlebox.text = titleString
        titlebox.textAlignment = NSTextAlignment.center
        descbox.text = descString
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        let defaults = UserDefaults.standard
        var added = false
        
        if let itin = defaults.value(forKey: "intinerary"){
        let temp = NSKeyedUnarchiver.unarchiveObject(with: itin as! Data) as! [[String: Any]]
        let events = temp.map {
            event.init(dictionary: $0)!
        }
        for item in events{
            if(self.eventID == item.eventID){
                added = true
            }
        }
        }
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        if(added){
            button.setTitle("✔", for: UIControlState.normal)
            button.titleLabel?.textColor = UIColor.white
            let addItem = UIBarButtonItem.init(customView: button)
            self.navigationItem.rightBarButtonItem = addItem
        }else{
            button.setTitle("+", for: UIControlState.normal)
            button.titleLabel?.font = UIFont.init(name: "Bodoni 72", size: 50)
            button.titleLabel?.textColor = UIColor.white
            button.backgroundColor = UIColor.clear
            let addItem = UIBarButtonItem.init(customView: button)
            button.addTarget(self, action: #selector(self.addItem(_:)), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = addItem
        }
        getData()
        // Do any additional setup after loading the view.
    }
    @objc
    func addItem(_ sender: UIButton) {
        var item = event()
        item.title = self.titleString
        item.time = self.time
        item.eventID = self.eventID
        item.coordinate = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        item.campus = eventCampus
        let defaults = UserDefaults.standard
        var itin = [event]()
        if let temp =
            defaults.value(forKey: "intinerary"){
            let temp2 = NSKeyedUnarchiver.unarchiveObject(with: temp as! Data) as! [[String:Any]]
            itin = temp2.map {
                event.init(dictionary: $0)!
            }
        }
        if time == 0{
        itin.append(item);
        }
        else{
            if(itin.count == 0){
                itin.append(item);
            }
            else{
            for i in 0...itin.count - 1{
                if(time < itin[i].time || itin[i].time == 0){
                    itin.insert(item, at: i)
                    break;
                }
                else if(i == itin.count - 1){
                    itin.insert(item, at: i)
                    break;
                }
            }
            }
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: itin.map{ $0.propertyListRepresentation})
        defaults.setValue(data, forKey: "intinerary")
        let alert = UIAlertController(title: "Event Added to Intinerary", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        defaults.synchronize()
        sender.setTitle("✔", for: UIControlState.normal)
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        sender.isEnabled = false

    }
    
    func getData(){
        let headers: HTTPHeaders = ["REDACTED"]
        Alamofire.request(url + "\(eventID)" + "?UID=IOS-\(code)",headers: headers).responseJSON { response in
            let json = response.result.value
            let dict = json as! [String: Any]
            self.descString = (dict["program_description"] as! String) + "\nHosted By: " + (dict["name_of_department_unit_center_student_organization___to_be_listed_in_promotional_materials"] as! String) + "\nTime: " + (dict["program_timing"] as! String) + "\nType: " + (dict["select_which_best_describes_your_program"] as! String)
            print(dict)
            let itemTime = dict["program_timing"] as! String
            if(itemTime == "continuous"){
                self.time = 0
            }
            else{
            if(itemTime == ""){
                self.time = 1200
            }else{
                self.time = Int(itemTime.prefix(itemTime.count - 2))!
                if(itemTime.contains("pm")){
                    self.time += 1200
                }
            }
            }
            self.descbox.text = self.descString
            if((dict["latitude"] as! String) != "" && dict["longitude"] as! String != ""){
                let latitude = (dict["latitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                let longitude = (dict["longitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                self.coordinate = CLLocationCoordinate2D.init(latitude: Double.init(latitude)!, longitude: Double.init(longitude)! * -1)
            }
            else if(self.Campus == 2 || self.Campus == 7){
                self.coordinate = self.camNewCoordinate(campus: self.Campus).coordinate
            }
            //Spelled as 'catagories' [sic] in database
            if(dict["catagories"] != nil){
                self.interests = dict["catagories"] as! [String]
                self.interestsTable.reloadData()
            }
            if(self.Campus == 2 || self.Campus == 7){
                self.eventCampus = self.Campus
            }
            else{
            let campusString = dict["campus"] as! String
            if(campusString == "Cook/Douglass"){
                self.eventCampus = 5
            }
            else if(campusString == "College Avenue"){
                self.eventCampus = 6
                }
            else{
                self.eventCampus = 8
                }
            }
            let annotation = MKPointAnnotation()  // <-- new instance here
            annotation.coordinate = self.coordinate
            annotation.title = self.titleString
            self.map.addAnnotation(annotation)
            let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:0.01)
            let region = MKCoordinateRegion.init(center: self.coordinate, span: span)
            self.map.setRegion(region, animated: true)
            self.map.showsUserLocation = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestCell", for: indexPath) as! EventCell
        cell.textLabel?.text = interests[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        if(cell.tag != 1){
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 60))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        whiteRoundedView.layer.shadowPath = UIBezierPath(rect: whiteRoundedView.bounds).cgPath
        whiteRoundedView.layer.shouldRasterize = true
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
            cell.tag = 1
        }
        cell.selectionStyle = .none
        return cell
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
