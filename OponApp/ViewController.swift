//
//  ViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 13..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

 

    @IBOutlet var menu: [UIBarButtonItem]!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backGroundStart: UIView!
    @IBOutlet weak var StartImg: UIImageView!
    
    var iNet: Bool!
    var intraStat: Int!
    var pushTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InternetConnection()
        IntraNetConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        iNet = nil
        intraStat = nil
        
        
        InternetConnection()
        IntraNetConnection()
        
        if (intraStat==1 && iNet==true) {

            let prefs:UserDefaults = UserDefaults.standard
            let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
            
            if (isLoggedIn != 1) {
                self.performSegue(withIdentifier: "goto_login", sender: self)
            } else {
                backGroundStart.isHidden = false
                StartImg.isHidden = false
                self.usernameLabel.text = prefs.value(forKey: "RESUSERNAME") as? String
            }
            
        } else {
            let intraStatString = "false"
            let alert = UIAlertController(title: "Network Connection Failed!", message: "Internet connection status: " + String(iNet).uppercased() + "\nIntranet connection status: " + intraStatString.uppercased() + "\nPlease check your connections \nand \nRestart App!", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func InternetConnection(){
        iNet = Reachability.isConnectedToNetwork()
    }
    
    func IntraNetConnection(){
        let f = Reachability()
        f.postData()
        let prefs:UserDefaults = UserDefaults.standard
        for _ in 0...9 {
            if (prefs.integer(forKey: "INTRANET") as Int == 200) {
                intraStat = 1
                break
            } else {
                intraStat = 0
            }
            Thread.sleep(forTimeInterval: 1)
        }
    }
    
    @IBAction func menu(_ sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    
}

