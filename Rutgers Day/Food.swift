 //
//  Food.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/30/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class Food: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    var dataCD = [lots]()
    var dataCA = [lots]()
    var dataBsch = [lots]()
    var dataNewark = [lots]()
    var dataCamden = [lots]()
    var selector = UISegmentedControl()
    let locationManager = CLLocationManager()
    var campus = 0
    var loc = CLLocation()
    var url = "REDACTED"
    let codes = ["l8","l6","l5","l2","l7"]
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        campus = UserDefaults.standard.integer(forKey: "campus")
        selector.insertSegment(withTitle: "Cook/Douglass", at: 0, animated: true)
        selector.insertSegment(withTitle: "College Avenue", at: 1, animated: true)
        selector.insertSegment(withTitle: "Busch", at: 2, animated: true)
        selector.addTarget(self, action: #selector(reloadData), for: .primaryActionTriggered)
        if(campus == 0){
            selector.frame = CGRect.init(x: 0, y: 0, width: self.table.frame.width, height: 30)
            selector.selectedSegmentIndex = 0
            table.tableHeaderView = selector
        }
        getData()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if(locationManager.location != nil){
            loc = locationManager.location!
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData(){
        let headers: HTTPHeaders = ["REDACTED"]
        for i in 0...4{
        url = "REDACTED" + codes[i] + "p76"
        Alamofire.request(url,headers: headers).responseJSON { response in
            let string = response.request?.url?.absoluteString
            let char = string![(string?.index((string?.startIndex)!, offsetBy: 42))!]
            let campusCode = Int.init("\(char)")!
            if let json = (response.result.value as? NSArray){
            print(json)
            if(json.count != 0){
                for i in 0...json.count - 1{
                    let dict = json[i] as! [String: Any]
                    var lot = lots()
                    lot.title = dict["name"] as! String
                    if((dict["latitude"] as! String) != "" && dict["longitude"] as! String != ""){
                        let latitude = (dict["latitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        let longitude = (dict["longitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        lot.latitude = Double.init(latitude)!
                        lot.longitude = Double.init(longitude)! * -1
                        switch campusCode{
                        case 8:
                            self.dataBsch.append(lot)
                            break;
                        case 6:
                            self.dataCA.append(lot)
                            break;
                        case 5:
                            self.dataCD.append(lot)
                            break;
                        case 7:
                            self.dataCamden.append(lot)
                            break;
                        case 2:
                            self.dataNewark.append(lot)
                            break;
                        default:
                            assert(true)
                        }

                    }
                }
            }
            else if(campusCode == 7){
                var temp = lots()
                temp.title = "Food Vendors Available Throughout The Area"
                self.dataCamden.append(temp)
            }
            else{
                var temp = lots()
                temp.title = "Food Vendors Available Throughout The Area"
                self.dataNewark.append(temp)
                }
                self.table.reloadData()
            }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(campus == 0){
        if(selector.selectedSegmentIndex == 0){
            return dataCD.count
        }
        else if selector.selectedSegmentIndex == 1{
            return dataCA.count
        }
        else{
            return dataBsch.count
        }
    }
        else if(campus == 2){
            return dataNewark.count
        }
        return dataCamden.count
    }
    @objc
    func reloadData(){
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingCell", for: indexPath) as! parkingCell
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 50))
        var data = [lots]()
        if(campus == 0){
        if(selector.selectedSegmentIndex == 0){
            data = dataCD
        }
        else if selector.selectedSegmentIndex == 1{
            data = dataCA
        }
        else{
            data = dataBsch
        }
        }
        else if(campus == 2){
            data = dataNewark
        }
        else{
            data = dataCamden
        }
        cell.label.text = data[indexPath.row].title
        let text = loc.distance(from: CLLocation.init(latitude: data[indexPath.row].latitude, longitude: data[indexPath.row].longitude)).description
        let distance = round(((Double(text)!                * 0.621371) / 1000) * 100) / 100
        cell.distanceMeter.textAlignment = NSTextAlignment.right
        label.text = distance.description + " Mi"
        label.textAlignment = NSTextAlignment.center
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        if (cell.tag != 1){
            let yellowRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 50))
            if(distance < 0.5){
                yellowRoundedView.layer.backgroundColor = UIColor.green.cgColor
            }
            else if (distance < 1.5){
                yellowRoundedView.layer.backgroundColor = UIColor.yellow.cgColor
            }
            else{
                yellowRoundedView.layer.backgroundColor = UIColor.red.cgColor
            }
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
            yellowRoundedView.layer.masksToBounds = false
            yellowRoundedView.layer.cornerRadius = 2.0
            yellowRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            yellowRoundedView.layer.shadowOpacity = 0.2
            yellowRoundedView.layer.shadowPath = UIBezierPath(rect: yellowRoundedView.bounds).cgPath
            yellowRoundedView.layer.shouldRasterize = true
            cell.color = yellowRoundedView
            cell.distance = label
            cell.distanceMeter.addSubview(yellowRoundedView)
            cell.distanceMeter.sendSubview(toBack: yellowRoundedView)
            cell.distanceMeter.insertSubview(label, aboveSubview: yellowRoundedView)
            cell.tag = 1
        }
        else{
            if(distance < 0.5){
                cell.color.layer.backgroundColor = UIColor.green.cgColor
            }
            else if (distance < 1.5){
                cell.color.layer.backgroundColor = UIColor.yellow.cgColor
            }
            else{
                cell.color.layer.backgroundColor = UIColor.red.cgColor
            }
            cell.distance.text = distance.description + " Mi"
        }
        return cell
    }
    func openMapForPlace(lat: Double, long: Double, name: String) {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: [lots]
        if(selector.selectedSegmentIndex == 0){
            data = dataCD
        }
        else if selector.selectedSegmentIndex == 1{
            data = dataCA
        }
        else{
            data = dataBsch
        }
        let index = indexPath.row
        openMapForPlace(lat: data[index].latitude, long: data[index].longitude, name: data[index].title)
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
