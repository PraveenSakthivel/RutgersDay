//
//  BusMap.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 4/11/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class BusMap: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scroller: UIScrollView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!
    
    
  /**  override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   /** fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / img.bounds.width
        let heightScale = size.height / img.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scroller.minimumZoomScale = minScale
        scroller.zoomScale = minScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - img.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - img.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
