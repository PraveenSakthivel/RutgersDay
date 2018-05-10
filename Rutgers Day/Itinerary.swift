//
//  Itinerary.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 3/2/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import Alamofire

class Itinerary: UITableViewController {
    var selector = UISegmentedControl()
    let url = "REDACTED0"
    var items = true
    var data = [event]()
    var dataCA = [event]()
    var dataBusch = [event]()
    var dataCD = [event]()
    var campus = 0
    var index = 0
    var entries = true
    var parentController = UIViewController()
    override func viewDidLoad() {
        campus = UserDefaults.standard.integer(forKey: "campus")
        selector.insertSegment(withTitle: "Cook/Douglass", at: 0, animated: true)
        selector.insertSegment(withTitle: "College Avenue", at: 1, animated: true)
        selector.insertSegment(withTitle: "Busch", at: 2, animated: true)
        selector.addTarget(self, action: #selector(reloadData), for: .primaryActionTriggered)
        if(campus == 0){
            selector.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 30)
            selector.selectedSegmentIndex = 0
            self.tableView.tableHeaderView = selector
        }
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized(_:)))
        self.tableView.addGestureRecognizer(longpress)
        super.viewDidLoad()
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect.init(x: 0, y: 0, width: 150, height: 80)
        imageView.contentMode = .scaleAspectFit
        imageView.center = CGPoint.init(x: (self.navigationController?.navigationBar.frame.width)! / 2, y: ((self.navigationController?.navigationBar.frame.height)! / 2) + 8)
        self.navigationController?.navigationBar.addSubview(imageView)
        self.tableView.backgroundColor = UIColor.init(red: 249/255, green: 245/255, blue: 237/255, alpha: 1)
        self.tableView.separatorStyle = .none
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        let img = UIImage.init(named: "xbutton")
        button.setImage(img, for: UIControlState.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissItin), for: .touchUpInside)
        let Barbutton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = Barbutton
        getData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func dismissItin(){
        parentController.dismiss(animated: true, completion: nil)
    }
    @objc
    func reloadData(){
        self.tableView.reloadData()
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
        if(campus == 0){
            if(selector.selectedSegmentIndex == 0){
                return dataCD.count
            }
            else if selector.selectedSegmentIndex == 1{
                return dataCA.count
            }
            else{
                return dataBusch.count
            }
        }
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func getData(){
        let defaults = UserDefaults.standard
        if let itin = defaults.value(forKey: "intinerary"){
            let temp = NSKeyedUnarchiver.unarchiveObject(with: itin as! Data) as! [[String: Any]]
            data = temp.map {
                event.init(dictionary: $0)!
            }
            if(campus == 0){
                for item in data{
                    switch item.campus{
                    case 5:
                        dataCD.append(item)
                        break;
                    case 6:
                        dataCA.append(item)
                        break;
                    case 8:
                        dataBusch.append(item)
                        break;
                    default:
                        assert(true)
                    }
                }
            }
        }
        if data.count == 0{
            entries = false
            let alert = UIAlertController(title: "No Events in Your Intinerary", message: "Find an event in Programs and click the add icon in the top right corner to add the event to your itinerary", preferredStyle:  UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            var newEvent = event()
            newEvent.title = "No Events in Your Itinerary"
            if(campus == 0){
            self.data.append(newEvent)
            }
            self.dataCD.append(newEvent)
            self.tableView.reloadData()
            self.items = false
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func saveOrder(){
        data = [event]()
        if(campus == 0){
            for item in dataCD{
                data.append(item)
            }
            for item in dataCA{
                data.append(item)
            }
            for item in dataBusch{
                data.append(item)
            }
        }
       let defaults = UserDefaults.standard
        let arrayData = NSKeyedArchiver.archivedData(withRootObject: data.map{ $0.propertyListRepresentation})
        defaults.setValue(arrayData, forKey: "intinerary")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(campus == 0){
            if(selector.selectedSegmentIndex == 0){
                data = dataCD
            }
            else if selector.selectedSegmentIndex == 1{
                data = dataCA
            }
            else{
                data = dataBusch
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "itinCell") as! itinCell
        if(cell.label.tag == 0){
            cell.label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 75, height: 50))
            cell.label.tag = 1
        }
        cell.titleBox.text = data[indexPath.row].title
        cell.clockDisplay.textAlignment = NSTextAlignment.right
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
            cell.clockDisplay.addSubview(yellowRoundedView)
            cell.clockDisplay.sendSubview(toBack: yellowRoundedView)
            cell.clockDisplay.insertSubview(cell.label, aboveSubview: yellowRoundedView)
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
 
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if(items){
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { action, index in
            if(self.campus == 0){
                if(self.selector.selectedSegmentIndex == 0){
                    self.dataCD.remove(at: indexPath.row)
                }
                else if(self.selector.selectedSegmentIndex == 1){
                    self.dataCA.remove(at: indexPath.row)
                }
                else{
                    self.dataBusch.remove(at: indexPath.row)
                }
            }else{
            self.data.remove(at: indexPath.row)
            }
            self.saveOrder()
            let alert = UIAlertController(title: "Event Removed From Itinerary", message: "", preferredStyle:  UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            if(self.data.count == 0){
            var newEvent = event()
            self.entries = false
            newEvent.title = "No Events in Your Itinerary"
            if(self.campus == 0){
                if(self.selector.selectedSegmentIndex == 0){
                    self.dataCD.append(newEvent)
                }
                else if(self.selector.selectedSegmentIndex == 1){
                    self.dataCA.append(newEvent)
                }
                else{
                    self.dataBusch.append(newEvent)
                }
            }else{
            self.data.append(newEvent)
            }
            }
            self.tableView.reloadData()
        }
        remove.backgroundColor = UIColor.red
        return [remove]
        }
        return nil;
    }
    @objc
    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell!)
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                if ((indexPath != nil) && (indexPath?.row != Path.initialIndexPath?.row)) {
                    var event = self.data[(Path.initialIndexPath?.row)!]
                    if(campus == 0){
                        if(selector.selectedSegmentIndex == 0){
                            event = dataCD.remove(at: (Path.initialIndexPath?.row)!)
                            dataCD.insert(event, at: (indexPath?.row)!)
                        }
                        else if selector.selectedSegmentIndex == 1{
                            event = dataCA.remove(at: (Path.initialIndexPath?.row)!)
                            dataCA.insert(event, at: (indexPath?.row)!)
                        }
                        else{
                            event = dataBusch.remove(at: (Path.initialIndexPath?.row)!)
                            dataBusch.insert(event, at: (indexPath?.row)!)
                        }
                    }else{
                        data.remove(at: (Path.initialIndexPath?.row)!)
                        data.insert(event, at: (indexPath?.row)!)
                    }
                    self.tableView.reloadData()
                    saveOrder()
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(entries){
        index = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "event_view") as! FullEventView
        destination.titleString = data[index].title
        destination.eventID = data[index].eventID
        self.navigationController?.pushViewController(destination, animated: true)
        }
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

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
