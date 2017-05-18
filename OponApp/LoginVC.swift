//
//  LoginVC.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 13..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var loginButtonBT: UIButton!

    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loginButtonBT.isEnabled = false
        iNet = nil
        intraStat = nil
        SoapMess = ""
        
        InternetConnection()
        IntraNetConnection()
        
        if (intraStat==1 && iNet==true) {
            
            loginButtonBT.isEnabled = true
            
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
    func scheduleLocal() {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 10)
        notification.alertBody = "Application was securely logged out!"
        notification.alertAction = "a visszalépéshez."
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textUsername.delegate = self
        textPassword.delegate = self
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        scheduleLocal()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
        
        let username:NSString = textUsername.text! as NSString
        let password:NSString = textPassword.text! as NSString
        
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            
            let alert = UIAlertController(title: "Sign in Failed!", message: "Please enter Resusername and Password again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            wscomm(username,password: password)
            let prefs:UserDefaults = UserDefaults.standard
            
            
            for _ in 0...9 {
                
                if ( (prefs.value(forKey: "MESSAGE") as? String) != nil ) {
                    let uzenet = (prefs.value(forKey: "MESSAGE") as? String)
                    if(uzenet == "Az autentikáció eredménye: Sikeres!")
                    {
                        var device = ""
                        if  (UIDevice.current.userInterfaceIdiom == .phone) {
                            device = ".Phone"
                        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
                            device = ".Pad"
                        } else {
                            device = ".Unspecified"
                        }
                        let udvozles = uzenet! + "\nSigned: " + (username as String)
                        let prefs:UserDefaults = UserDefaults.standard
                        prefs.set(udvozles, forKey: "UDVOZLES")
                        prefs.set(username, forKey: "RESUSERNAME")
                        prefs.set(password, forKey: "USERPASS")
                        prefs.set(device, forKey: "DEVICETYPE")
                        prefs.set(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        self.dismiss(animated: true, completion: nil)
                       break
                        
                    } else {
                        let alert = UIAlertController(title: "Sign in Failed!", message: "Az autentikáció eredménye: Sikertelen! Nem megfelelő resusernév vagy jelszó!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else {

                }
                
                Thread.sleep(forTimeInterval: 0.3)
            }
        }
    
    }
    
    func wscomm(_ username: NSString, password: NSString ) {
        
            var device = ""
            if  (UIDevice.current.userInterfaceIdiom == .phone) {
                device = ".Phone"
            } else if (UIDevice.current.userInterfaceIdiom == .pad) {
                device = ".Pad"
            } else {
                device = ".Unspecified"
            }
            
        let activity = "login"
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n<SOAP-ENV:Header/>\n<S:Body>\n<ns2:AUT xmlns:ns2='http:///'>\n<USER>"+(username as String)+"</USER>\n<PASS>"+(password as String)+"</PASS>\n<DEVICE>"+(device as String)+"</DEVICE>\n<ACTIVITY>"+(activity as String)+"</ACTIVITY>\n</ns2:AUT>\n</S:Body>\n</S:Envelope>"
        var request = URLRequest(url: URL(string: "http://iphost:8080//?WSDL")!)
        request.timeoutInterval = 5.0
        request.httpMethod = "POST"
        let post:NSString = xmlStr! as NSString
        let postData:Data = post.data(using: String.Encoding.utf8.rawValue)!
        request.httpBody = postData
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
       
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                let prefs:UserDefaults = UserDefaults.standard
                if (response != nil) {
                    let responseString: String = String(data: data!, encoding: String.Encoding.utf8)!
                    var substring = responseString.components(separatedBy: "return>")[1]
                    substring.remove(at: substring.characters.index(before: substring.endIndex))
                    substring.remove(at: substring.characters.index(before: substring.endIndex))
                    let prefs:UserDefaults = UserDefaults.standard
                    prefs.set(substring, forKey: "MESSAGE")
                }else{prefs.set(nil, forKey: "MESSAGE")}})
            task.resume()

    }

}

