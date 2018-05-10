//
//  Maps.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/25/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit
import MapKit
import Segmentio
import Alamofire
import UserNotifications

class Maps: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{

    @IBOutlet var map: MKMapView!
    @IBOutlet var selector: Segmentio!
    var parkingPins = [MKAnnotation]()
    var first = 0
    let locationManager = CLLocationManager()
    let coordinate = CLLocationCoordinate2D.init(latitude: 40.505, longitude: -74.45)
    var parkingData = [lots]()
    var busData = [lots]()
    var busPins = [MKAnnotation]()
    var Itin = [event]()
    var itinPins = [MKAnnotation]()
    var foodPins = [MKAnnotation]()
    var Programs = [event]()
    var programPins = [MKAnnotation]()
    var Campus = 0
    var segIndex = 0
    var selectedEvent = event()
    let headers: HTTPHeaders = ["REDACTED"]
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        Campus = UserDefaults.standard.integer(forKey: "campus")
        var point = CLLocationCoordinate2D()
        switch Campus{
        case 0:
            point = CLLocationCoordinate2D.init(latitude: 40.5008, longitude: -74.4474)
            break;
        case 2:
            point = CLLocationCoordinate2D.init(latitude: 40.7412, longitude: -74.1753)
            break;
        case 7:
            point = CLLocationCoordinate2D.init(latitude: 39.9485, longitude: -75.1219)
            break;
        default:
            break;
        }
        let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta:0.1)
        let region = MKCoordinateRegion.init(center: point, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        getProgramData()
        getFoodData()
        getParkingData()
        let ProgramsOption = SegmentioItem(title: "Programs", image: nil)
        let ItineraryOption = SegmentioItem(title: "Itinerary", image: nil)
        let ParkingOption = SegmentioItem(title: "Parking", image: nil)
        let FoodOption = SegmentioItem(title: "Food", image: nil)
        let BusOption = SegmentioItem(title: "Bus Stops", image: nil)
        let options = createOptions()
        var items = [ProgramsOption,ItineraryOption, ParkingOption,FoodOption]
        if(Campus == 0){
            items.append(BusOption)
        }
        selector.setup(content: items, style: SegmentioStyle.onlyLabel, options: options)
        selector.selectedSegmentioIndex = 0
        selector.valueDidChange = {
            segmentio, segmentIndex in
            self.addPins(index: segmentIndex)
            self.segIndex = segmentIndex
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        setUpItinerary()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound,.badge]) { (granted, error) in
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Tell us how you liked Rutgers Day.", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Take the survey and be eligible for a gift card!",arguments: nil)
            var dateInfo = DateComponents.init()
            dateInfo.calendar = NSCalendar.current
            dateInfo.month = 4
            dateInfo.day = 28
            dateInfo.hour = 12
            dateInfo.minute = 0
            dateInfo.year = 2018
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
            let request = UNNotificationRequest(identifier: "survey", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
            var dateInfo2 = DateComponents.init()
            dateInfo2.calendar = NSCalendar.current
            dateInfo2.month = 4
            dateInfo2.day = 28
            dateInfo2.hour = 15
            dateInfo2.minute = 0
            dateInfo2.year = 2018
            let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: false)
            let request2 = UNNotificationRequest(identifier: "survey2", content: content, trigger: trigger2)
            center.add(request2, withCompletionHandler: nil)
        }
        // Do any additional setup after loading the view.
    }
    func addPins(index: Int){
        map.removeAnnotations(map.annotations)
        switch index{
        case 0:
            map.addAnnotations(programPins)
            break;
        case 1:
            Itin = [event]()
            itinPins = [MKAnnotation]()
            getItinData()
            map.addAnnotations(itinPins)
            break;
        case 2:
            map.addAnnotations(parkingPins)
            break;
        case 3:
            map.addAnnotations(foodPins)
            break;
        case 4:
            map.addAnnotations(busPins)
            break;
        default:
            assert(true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func createOptions() -> SegmentioOptions{
        let h = SegmentioHorizontalSeparatorOptions.init(type: SegmentioHorizontalSeparatorType.top, height: 1, color: UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1))
        let v = SegmentioVerticalSeparatorOptions.init(ratio: 1, color:  UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1))
        let options = SegmentioIndicatorOptions.init(type: SegmentioIndicatorType.bottom, ratio: 1, height: 5, color: UIColor.white)
        return SegmentioOptions(
            backgroundColor:  UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1),
            segmentPosition: SegmentioPosition.dynamic,
            scrollEnabled: true,
            indicatorOptions: options,
            horizontalSeparatorOptions: h,
            verticalSeparatorOptions: v,
            imageContentMode: .scaleAspectFit,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .white,
                    titleFont: UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)!,
                    titleTextColor: .white
                ),
                selectedState: SegmentioState(
                    backgroundColor: UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1),
                    titleFont: UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)!,
                    titleTextColor: UIColor.white
                ),
                highlightedState: SegmentioState(
                    backgroundColor: UIColor.init(red: 154/255, green: 203/255, blue: 231/255, alpha: 1),
                    titleFont: UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)!,
                    titleTextColor: UIColor.white
                )
            ),
            animationDuration: 0.3
        )
    }
    func getItinData(){
        let defaults = UserDefaults.standard
        if let itinData = defaults.value(forKey: "intinerary"){
            let temp = NSKeyedUnarchiver.unarchiveObject(with: itinData as! Data) as! [[String: Any]]
            Itin = temp.map {
                event.init(dictionary: $0)!
            }
            var i = 0
            for item in Itin{
                let point = eventPin()
                point.pos = i
                point.coordinate = item.coordinate.coordinate
                print(item.coordinate)
                print(point.coordinate)
                itinPins.append(point)
                i += 1
            }
        }
    }
    func getProgramData(){
        let code = UserDefaults.standard.integer(forKey: "UID")
        Alamofire.request("REDACTEDl\(Campus)?UID=IOS-\(code)",headers: headers).responseJSON { response in
            let json = (response.result.value as! NSArray)
            if(json.count != 0){
                for i in 0...json.count - 1{
                    let dict = json[i] as! [String: Any]
                    let point = eventPin()
                    point.pos = self.programPins.count
                    var newEvent = event()
                    if(dict["name"] != nil){
                        newEvent.title = dict["name"] as! String
                    }
                    newEvent.eventID = Int(dict["sid"] as! String)!
                    if((dict["latitude"] as! String) != "" && dict["longitude"] as! String != ""){
                        let latitude = (dict["latitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        let longitude = (dict["longitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        newEvent.coordinate = CLLocation.init(latitude: Double.init(latitude)!, longitude: Double.init(longitude)! * -1)
                        point.coordinate = newEvent.coordinate.coordinate
                        self.Programs.append(newEvent)
                        self.programPins.append(point)
                    }
                    else if(self.Campus == 2 || self.Campus == 7){
                        newEvent.coordinate = self.camNewCoordinate(campus: self.Campus)
                        point.coordinate = newEvent.coordinate.coordinate
                        self.Programs.append(newEvent)
                        self.programPins.append(point)
                    }
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
                    }
                }
            if(self.segIndex == 0){
             self.addPins(index: 0)
            }
            }
    }
    func getFoodData(){
        let code = UserDefaults.standard.integer(forKey: "UID")
        Alamofire.request("REDACTEDp76?UID=IOS-\(code)",headers: headers).responseJSON { response in
            let json = (response.result.value as! NSArray)
            if(json.count != 0){
                for i in 0...json.count - 1{
                    let dict = json[i] as! [String: Any]
                    let point = MKPointAnnotation.init()
                    point.title = dict["name"] as? String
                    if((dict["latitude"] as! String) != "" && dict["longitude"] as! String != ""){
                        let latitude = (dict["latitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        let longitude = (dict["longitude"] as! String).trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                        point.coordinate = CLLocationCoordinate2D.init(latitude: Double.init(latitude)!, longitude: Double.init(longitude)! * -1)
                        self.foodPins.append(point)
                    }
                }
            }
        }
    }
    func getParkingData(){
        var rawInfo = String()
        if(Campus == 0){
        rawInfo = readDataFromCSV(fileName: "parkingLots", fileType: ".csv")
        }
        else if(Campus == 2){
        rawInfo = readDataFromCSV(fileName: "newark", fileType: ".csv")
        }
        else{
        rawInfo = readDataFromCSV(fileName: "camden", fileType: ".csv")
        }
        rawInfo = cleanRows(file: rawInfo)
        var result: [[String]] = []
        var rows = rawInfo.components(separatedBy: "\n")
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
            parkingData.append(lot)
        }
        for lot in parkingData{
            let point = MKPointAnnotation.init()
            point.title = lot.title
            point.coordinate = CLLocationCoordinate2D.init(latitude: lot.latitude, longitude: lot.longitude)
            parkingPins.append(point)
        }
        rawInfo = cleanRows(file: rawInfo)
        rawInfo = readDataFromCSV(fileName: "buses", fileType: ".csv")
        result = []
        rows = rawInfo.components(separatedBy: "\n")
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
            busData.append(lot)
        }
        for lot in busData{
            let point = MKPointAnnotation.init()
            point.title = lot.title
            point.coordinate = CLLocationCoordinate2D.init(latitude: lot.latitude, longitude: lot.longitude)
            busPins.append(point)
        }
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
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if(annotation.isKind(of: Mirror.init(reflecting: MKUserLocation.init()).subjectType as! AnyClass)){
        return nil
    }
    if(segIndex > 1){
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Applemaps")
            if(view == nil){
                view = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "Applemaps")
                let Button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 164, height: 20))
                Button.setTitle("Open in Apple Maps", for: .normal)
                Button.setTitleColor(UIColor.blue, for: .normal)
                view?.rightCalloutAccessoryView = Button
                view?.canShowCallout = true
            }
            else{
                view?.annotation = annotation
            }
            return view
    }
        var data = [event]()
        if(segIndex == 0){
            data = Programs
        }
        else{
            data = Itin
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "eventView")
        if(view == nil){
            view = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "eventView")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let popout = storyboard.instantiateViewController(withIdentifier: "mapAnnotation").view as! eventAnnotation
            let height = NSLayoutConstraint.init(item: popout, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 95)
            let width = NSLayoutConstraint.init(item: popout, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 184)
            popout.addConstraints([height,width])
            view?.detailCalloutAccessoryView = popout
            view?.canShowCallout = true
        }
        let pos = (annotation as! eventPin).pos
        let popout2 = view?.detailCalloutAccessoryView as! eventAnnotation
        popout2.titleBox.text = data[pos].title
        let eventTime = data[pos].time
        if(eventTime == 0){
            popout2.label.text = "All Day"
        }
        else{
            var offset = 0
            var isPM = false
            if(eventTime >= 1200){
                isPM = true
                if(eventTime >= 1300){
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
            popout2.label.text = "\(eventTime / 100 - offset):\(minuteS)"
            if(!isPM){
                popout2.label.text = popout2.label.text! + " AM"
            }
            else{
                popout2.label.text = popout2.label.text! + " PM"
            }
        }
        popout2.label.textAlignment = NSTextAlignment.center
        var yellowRoundedView = popout2.color
        if(yellowRoundedView.tag != 1){
        yellowRoundedView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let time = Int(formatter.string(from: NSDate() as Date))!
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
        let dayOf = Date.init()
        let cal = Calendar.current
        let month = cal.component(.month, from: dayOf)
        let day = cal.component(.day, from: dayOf)
        if(month != 4 || day != 28){
            yellowRoundedView.layer.backgroundColor = UIColor.green.cgColor
        }
    if(yellowRoundedView.tag != 1){
        yellowRoundedView.layer.masksToBounds = false
        yellowRoundedView.layer.cornerRadius = 2.0
        yellowRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        yellowRoundedView.layer.shadowOpacity = 0.2
        yellowRoundedView.layer.shadowPath = UIBezierPath(rect: yellowRoundedView.bounds).cgPath
        yellowRoundedView.layer.shouldRasterize = true
        popout2.clock.addSubview(yellowRoundedView)
        popout2.clock.sendSubview(toBack: yellowRoundedView)
        popout2.clock.insertSubview(popout2.label, aboveSubview: yellowRoundedView)
        yellowRoundedView.tag = 1
        popout2.color = yellowRoundedView
    }
        popout2.openButton.tag = pos
        popout2.openButton.addTarget(self, action: #selector(openView), for: .touchUpInside)
        view?.annotation = annotation
        return view
    }
    
    @objc
    func openView(sender: UIButton){
        let pos = sender.tag
        if(segIndex == 0){
            selectedEvent = Programs[pos]
        }
        else{
            selectedEvent = Itin[pos]
        }
        performSegue(withIdentifier: "mapPinSegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if(segIndex > 1){
            openMapForPlace(lat: (view.annotation?.coordinate.latitude)!,long: (view.annotation?.coordinate.longitude)!,name: ((view.annotation?.title)!)!)
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            UIApplication.shared.open(URL(string: "https://rutgers.ca1.qualtrics.com/jfe/form/SV_byl6QWjT9pq4gpT")!, options: [:], completionHandler: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FullEventView
        destination.titleString = selectedEvent.title
        destination.eventID = selectedEvent.eventID
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
