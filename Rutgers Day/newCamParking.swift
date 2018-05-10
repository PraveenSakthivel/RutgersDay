//
//  newCamParking.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/27/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit

class newCamParking: UITableViewController, CLLocationManagerDelegate{

    var campus = 2
    var data = [lots]()
    let locationManager = CLLocationManager()
    var loc = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        campus = UserDefaults.standard.integer(forKey: "campus")
        getData()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if(locationManager.location != nil){
            loc = locationManager.location!
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return data.count
    }
    func getData(){
        var rawInfo = String()
        if(campus == 2){
            rawInfo = readDataFromCSV(fileName: "newark", fileType: ".csv")
        }else{
            rawInfo = readDataFromCSV(fileName: "camden", fileType: ".csv")
        }
        rawInfo = cleanRows(file: rawInfo)
        var result: [[String]] = []
        let rows = rawInfo.components(separatedBy: "\n")
        for i in 1...((rows.count) - 1) {
            let row = rows[i]
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        for i in 0...result.count - 1{
            var lot = lots()
            lot.title = result[i][1]
            lot.description = result[i][5]
            lot.latitude = Double.init(result[i][result[i].count - 2])!
            lot.longitude = Double.init(result[i][result[i].count - 1])!
            lot.campus = result[i][3]
            data.append(lot)
        }
        self.tableView.reloadData()
    }
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingCell", for: indexPath) as! parkingCell
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 50))
        cell.label.text = data[indexPath.row].title
        let text = loc.distance(from: CLLocation.init(latitude: data[indexPath.row].latitude, longitude: data[indexPath.row].longitude)).description
        let distance = round(((Double(text)!                * 0.621371) / 1000) * 100) / 100
        cell.distanceMeter.textAlignment = NSTextAlignment.right
        label.text = distance.description + " Mi"
        label.textAlignment = NSTextAlignment.center
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
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
        if (cell.tag != 1){
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
            cell.distanceMeter.addSubview(yellowRoundedView)
            cell.distanceMeter.sendSubview(toBack: yellowRoundedView)
            cell.distanceMeter.insertSubview(label, aboveSubview: yellowRoundedView)
            cell.tag = 1
        }
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        openMapForPlace(lat: data[index].latitude, long: data[index].longitude, name: data[index].title)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
