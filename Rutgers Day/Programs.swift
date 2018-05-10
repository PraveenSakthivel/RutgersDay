//
//  Programs.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/25/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit

class Programs: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var CampusCollection: UICollectionView!
    
    
    
    var extCode = ""
    let sectionInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 10.0, right: 20.0)
    let campuses = ["Cook/Douglass", "College Avenue", "Busch"]
    let interests = ["Get to Know Rutgers", "Experience the Arts & Humanities", "Science & Technology", "All Things Green", "Business & Careers", "Sports & Recreation", "Kid's Stuff", "Health & Wellness"]
    let stages = ["College Avenue Big R Stage", "College Avenue Scarlet Stage", "Busch Big R Stage", "Cook/Douglass Big R Stage"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpItinerary()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
        return 3
        }
        else if section == 1{
        return 8
        }
        else{
        return 4
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "programCell",
                                                          for: indexPath) as! CollectionCell
        let data: [String]
        switch indexPath.section{
        case 0:
            data = campuses
            break;
        case 1:
            data = interests
            break;
        case 2:
            data = stages
            break;
        default:
            data = [String]()
            break;
        }
            let name = data[indexPath.row]
            cell.img.image = UIImage.init(named: name.trimmingCharacters(in: .whitespaces))
        if(indexPath.row == 3 && indexPath.section == 2){
                cell.img.image = UIImage.init(named: "Cook:Douglass Big R Stage")
            }
        else if(indexPath.row == 0 && indexPath.section == 0){
            cell.img.image = UIImage.init(named: "CookDouglass")
        }
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.firstLineHeadIndent = 7
            paraStyle.headIndent = 7
            let formattedName = NSAttributedString.init(string: name, attributes: [NSAttributedStringKey.paragraphStyle: paraStyle])
            cell.title.attributedText = formattedName
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
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "programHeader",for: indexPath) as! ProgramHeader
            if indexPath.section == 0{
            headerView.title.text = "Programs By Campus"
            }
            else if indexPath.section == 1{
                headerView.title.text = "Programs By Interest"
            }
            else{
                headerView.title.text = "Performance Stages"
            }
            return headerView
            break;
        default:
            return UICollectionReusableView()
        }
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
        if(indexPath.section == 0){
            switch indexPath.row{
            case 0:
                extCode = "l5"
                break;
            case 1:
                extCode = "l6"
                break;
            case 2:
                extCode = "l8"
                break;
            case 3:
                extCode = "l7"
                break;
            case 4:
                extCode = "l2"
                break;
            default:
                break;
            }
        }
        else if(indexPath.section == 1){
            switch indexPath.row{
            case 0:
                extCode = "c23"
                break;
            case 1:
                extCode = "c24"
                break;
            case 2:
                extCode = "c25"
                break;
            case 3:
                extCode = "c26"
                break;
            case 4:
                extCode = "c28"
                break;
            case 5:
                extCode = "c29"
                break;
            case 6:
                extCode = "c30"
                break;
            case 7:
                extCode = "c27"
                break;
            default:
                break;
            }
        }
        else{
            switch indexPath.row{
            case 0:
                extCode = "bigR"
                break;
            case 1:
                extCode = "scarletstage"
                break;
            case 2:
                extCode = "l8t51"
                break;
            case 3:
                extCode = "l5t51"
                break;
            default:
                break;
            }
        }
        performSegue(withIdentifier: "programSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProgramList
        destination.ext = extCode
    }
    

}
