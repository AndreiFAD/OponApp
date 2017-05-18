//
//  RiportNav.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 13..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit
import Foundation

class RiportNav: UIViewController {

    @IBOutlet weak var navbutton: UIButton!
    
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iNet = nil
        intraStat = nil
        SoapMess = ""
        
        InternetConnection()
        IntraNetConnection()
        
        if (intraStat==1 && iNet==true) {
            
            navbutton.enabled = true
            
        } else {
            let intraStatString = "false"
            let alert = UIAlertController(title: "Network Connection Failed!", message: "Internet connection status: " + String(iNet).uppercaseString + "\nIntranet connection status: " + intraStatString.uppercaseString + "\nPlease check your connections \nand \nRestart App!", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func InternetConnection(){
        iNet = Reachability.isConnectedToNetwork()
    }
    
    func IntraNetConnection(){
        let f = Reachability()
        f.postData()
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        for _ in 0...9 {
            if (prefs.integerForKey("INTRANET") as Int == 200) {
                intraStat = 1
                break
            } else {
                intraStat = 0
            }
            NSThread.sleepForTimeInterval(1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

    }
    
}
