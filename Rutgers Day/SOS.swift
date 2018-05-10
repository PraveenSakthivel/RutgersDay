//
//  SOS.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 4/19/18.
//  Copyright © 2018 TBLE Technologies. All rights reserved.
//

import UIKit

class SOS: UIViewController {

   let NBText = "In Case of Emergency \n\nAssistance is available at the information tents, from public safety personnel and from Rutgers Day staff in neon t-shirts. In case of emergency, call Rutgers Police at 732-932-7211 or 911.\n\nLost Persons\n\nImmediately report a lost person to the nearest information tent or to any Rutgers Day staff in a neon t-shirt, or contact Rutgers Police at 732-932-7211."
    
    let camdenText = "First Aid and Emergency Services\n\nAssistance is available from Rutgers Day staff and public safety personnel. Emergency phones are located throughout our campuses. Call the Rutgers Police at 856-225-6009 or dial 911. Report or bring lost items to Camden Division of the Rutgers Police Department located at 409 North 4th Street."
    
    let newarkText = "In Case of Emergency \n\nAssistance is available at the information tents, from public safety personnel and from Rutgers Day staff in neon t-shirts. In case of emergency, call Rutgers Police at 973-353-5111 or 911.\n\nLost Persons\n\nImmediately report a lost person to the nearest information tent or to any Rutgers Day staff in a neon t-shirt, or contact Rutgers Police at 732-932-7211. Report or bring lost items to the nearest information tent."
    
    var campus = 0
    
    @IBOutlet var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        campus = UserDefaults.standard.integer(forKey: "campus")
        if(campus == 0){
            text.text = NBText
        }
        else if(campus == 2){
            text.text = newarkText
        }
        else{
            text.text = camdenText
        }
        // Do any additional setup after loading the view.
    }

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
