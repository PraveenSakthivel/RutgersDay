//
//  AboutWebpages.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 1/11/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit
import WebKit

class AboutWebpages: UIViewController, WKNavigationDelegate {
  
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
    @IBOutlet var webView: WKWebView!
    var page = 1
    var survey = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIcon.hidesWhenStopped = true
        webView.navigationDelegate = self
        if(survey){
            webView.load(URLRequest.init(url: URL.init(string: "https://rutgers.ca1.qualtrics.com/jfe/form/SV_byl6QWjT9pq4gpT")!))
        }else{
        if page == 1{
            webView.load(URLRequest.init(url: URL.init(string: "https://www.rutgers.edu/about")!))
        }
        else{
            webView.load(URLRequest.init(url: URL.init(string: "https://rutgersday.rutgers.edu/content/about-rutgers-day")!))
        }
        }
        let backText = UIButton(type: .custom)
        backText.frame = CGRect(x: 0, y: 0, width: 40, height: 80)
        backText.setTitle("<", for: UIControlState())
        backText.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: UIControlState())
        backText.titleLabel!.font = UIFont(name: "Helvetica", size: 30)
        let forText = UIButton(type: .custom)
        forText.frame = CGRect(x: 0, y: 0, width: 40, height: 80)
        forText.setTitle(">", for: UIControlState())
        forText.setTitleColor(UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: UIControlState())
        forText.titleLabel!.font = UIFont(name: "Helvetica", size: 30)
        let back = UIBarButtonItem(customView: backText)
        let forward = UIBarButtonItem(customView: forText)
        self.navigationItem.rightBarButtonItems = [forward,back]
        backText.addTarget(self, action: #selector(goB), for: UIControlEvents.touchUpInside)
        forText.addTarget(self, action: #selector(goF), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc
    func goF(){
        webView.goForward()
        loadingIcon.stopAnimating()
    }
    @objc
    func goB(){
        webView.goBack()
        loadingIcon.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIcon.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIcon.stopAnimating()
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
