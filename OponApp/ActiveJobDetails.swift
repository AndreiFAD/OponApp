//
//  ActiveJobDetails.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 05. 18..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActiveJobDetails: UIViewController, UITableViewDelegate {
    
    //
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var parameters: UITextView!
    
    var valueToPass:String!
    var nameuser = ""
    var passedValue:String!
    var indexValue: String!
    var resusername: String!
    var iNet: Bool!
    var intraStat: Int!
    var list: JSON = []
    var SoapMess: String!
    
    
    
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        iNet = nil
        intraStat = nil
        SoapMess = ""
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == UIUserNotificationType() {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        InternetConnection()
        IntraNetConnection()

        if (intraStat==1 && iNet==true) {
            
            
            listrequestt()
            
            
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InternetConnection()
        IntraNetConnection()
        listrequestt()

        
    }
    func listrequestt() {
        
        if (indexValue == "D"){
            button.isHidden = true;
        } else{
            button.isHidden = false;
        }
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            
            let alert = UIAlertController(title: "Sign in again!", message: "Please restart App!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            nameuser = (prefs.value(forKey: "USERNAME") as? String)!
        }
        
        wscomm(nameuser as NSString)
        typealias JSONObject = [String:Any]
        for _ in 0...15 {
            Thread.sleep(forTimeInterval: 0.1)
            if ( (prefs.value(forKey: "JOBS1D") as? String) != nil ) {
                let data2 = prefs.value(forKey: "JOBS1D") as! String
                
                if let dataFromString = data2.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                     parameters.text = String(describing: json)
                    
                    break
                }
                
                
            } else {
                
            }
            
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
    
    @IBAction func goto_log(_ sender: Any) {
        
    }
    
    
    
    func wscomm(_ username: NSString) {
        
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'><SOAP-ENV:Header/><S:Body><ns2:Details xmlns:ns2='http:///'><Id>"+passedValue+"</Id><Type>"+indexValue+"</Type></ns2:Details></S:Body></S:Envelope>"
        
        var request = URLRequest(url: URL(string: "http://iphost:8080//?WSDL")!)
        request.timeoutInterval = 4.0
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
                var substring1 = responseString.components(separatedBy: "return>")[1]
                substring1.remove(at: substring1.characters.index(before: substring1.endIndex))
                substring1.remove(at: substring1.characters.index(before: substring1.endIndex))
                let prefs:UserDefaults = UserDefaults.standard
                prefs.set(String(htmlEncodedString: substring1), forKey: "JOBS1D")
            }else{prefs.set(nil, forKey: "JOBS1D")}})
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var result: UILabel!
    
    
    func runcall() {
        button.isHidden = false;
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'><SOAP-ENV:Header/><S:Body><ns2:Test_Run xmlns:ns2='http:///'><Id>"+passedValue+"</Id></ns2:Test_Run></S:Body></S:Envelope>"
        
        var request = URLRequest(url: URL(string: "http://iphost:8080//?WSDL")!)
        request.timeoutInterval = 4.0
        request.httpMethod = "POST"
        let post:NSString = xmlStr! as NSString
        let postData:Data = post.data(using: String.Encoding.utf8.rawValue)!
        request.httpBody = postData
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data2, response3, error -> Void in
            let prefs:UserDefaults = UserDefaults.standard
            if (response3 != nil) {
                let responseString: String = String(data: data2!, encoding: String.Encoding.utf8)!
                var substring3 = responseString.components(separatedBy: "return>")[1]
                substring3.remove(at: substring3.characters.index(before: substring3.endIndex))
                substring3.remove(at: substring3.characters.index(before: substring3.endIndex))
                print(substring3)
                prefs.set(String(htmlEncodedString: substring3), forKey: "JOBrunresult")
                
            }else{prefs.set(nil, forKey: "JOBrunresult")
            }})
        
        task.resume()
        button.isHidden = true;

    }
    
    @IBAction func runActiveJob(_ sender: Any) {
        self.runcall()
        
    }
    
    
    @IBAction func gotoback(_ sender: AnyObject) {

        self.dismiss(animated: true, completion: nil)
    }
    

    
    
}
