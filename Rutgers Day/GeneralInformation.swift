//
//  GeneralInformation.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/29/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit
import DTPhotoViewerController

class GeneralInformation: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let sectionInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 50.0, right: 20.0)
    let nbtitles = ["  Parking", "  Bus Stops", "  Bus Route", "  Restrooms", "  Food", "  In Case of an Emergency", "  Accessibility"]
    let nctitles = ["  Parking","  Restrooms","  Food","  In Case of an Emergency"]
    var index = 0
    var campus = 0
    @IBOutlet var genInfo: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        campus = UserDefaults.standard.integer(forKey: "campus")
        genInfo.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.init(red: 249/250, green: 245/250, blue: 237/250, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(campus == 0){
        return 7
        }else{
        return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var titles = [String]()
        if(campus == 0){
            titles = nbtitles
        }
        else{
            titles = nctitles
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genInfoCell",
                                                          for: indexPath) as! GenInfoCell
            let name = titles[indexPath.row]
            cell.img.image = UIImage.init(named: name.trimmingCharacters(in: .whitespaces))
            cell.title.text = name
            cell.img.contentMode = UIViewContentMode.scaleAspectFill
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
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (2 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        if(campus == 0){
        switch index{
        case 0:
            performSegue(withIdentifier: "parkingSegue", sender: self)
        case 1:
            performSegue(withIdentifier: "parkingSegue", sender: self)
        case 2:
            let image = UIImage.init(named: "Bus Loop")
            let imgView = UIImageView()
            if let viewController = DTPhotoViewerController(referencedView: imgView, image: image) {
                self.present(viewController, animated: true, completion: nil)
            }
        //performSegue(withIdentifier: "busRouteSegue", sender: self)
        case 3:
            performSegue(withIdentifier: "restroomsSegue", sender: self)
        case 4:
            performSegue(withIdentifier: "foodSegue", sender: self) 
        case 5:
            performSegue(withIdentifier: "sosSegue", sender: self)
        case 6:
            performSegue(withIdentifier: "accessibility", sender: self)
        default:
            assert(true)
        }
        }
        else{
            switch index{
            case 0:
                performSegue(withIdentifier: "ncParking", sender: self)
            case 1:
                performSegue(withIdentifier: "restroomsSegue", sender: self)
            case 2:
                performSegue(withIdentifier: "foodSegue", sender: self)
            case 3:
                performSegue(withIdentifier: "sosSegue", sender: self)
            default:
                assert(true)
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(index == 1 && campus == 0){
         let destination = segue.destination as! Parking
            destination.buses = true
        }
        else if(index == 0 && campus == 2){
            let destination = segue.destination as! newCamParking
            destination.campus = 2
        }
        else if(index == 0 && campus == 7){
            let destination = segue.destination as! newCamParking
            destination.campus = 7
        }
     }
    
    
}
