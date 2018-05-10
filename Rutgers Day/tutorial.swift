//
//  tutorial.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 4/11/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class tutorial: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    var controllers = [UIViewController]()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! TutorialImgNoButton).index
        if(index == 0){
            return nil
        }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! TutorialImgNoButton).index
        if(index == 6){
            return nil
        }
        return controllers[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 7
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.dataSource = self
        self.delegate = self
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.backgroundColor = UIColor.init(red: 81/255, green: 116/255, blue: 246/255, alpha: 1)
        let t0 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t0.imgString = "t0"
        t0.index = 0
        let t1 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t1.imgString = "t1"
        t1.index = 1
        let t2 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t2.imgString = "t2"
        t2.index = 2
        let t3 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t3.imgString = "t3"
        t3.index = 3
        let t4 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t4.imgString = "t4"
        t4.index = 4
        let t5 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t5.imgString = "t5"
        t5.index = 5
        let t6 = storyboard.instantiateViewController(withIdentifier: "tutorialimage") as! TutorialImgNoButton
        t6.imgString = "t6"
        t6.index = 6
        controllers = [t0,t1,t2,t3,t4,t5,t6]
        setViewControllers([t0], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
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
