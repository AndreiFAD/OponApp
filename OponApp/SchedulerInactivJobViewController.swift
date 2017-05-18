//
//  SchedulerInactivJobViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 05. 18..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//

import UIKit
import SwiftyJSON

class SchedulerInactivJobViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView2: UITableView!
    
    var valueToPass:String!
    var nameuser = ""
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    var healthyFoods2 = [] as [String]
    var subtitlemessage2 = [] as [String]
    
    
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
        tableView2.delegate = self
        tableView2.dataSource = self
        
    }
    
    
    func listrequestt() {
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            
            let alert = UIAlertController(title: "Sign in again!", message: "Please restart App!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            nameuser = (prefs.value(forKey: "RESUSERNAME") as? String)!
        }
        
        wscomm(nameuser as NSString)
        typealias JSONObject = [String:Any]
        for _ in 0...9 {
            Thread.sleep(forTimeInterval: 0.1)
            if ( (prefs.value(forKey: "JOBS2") as? String) != nil ) {
                let data2 = prefs.value(forKey: "JOBS2") as! String
                
                var listaid2 : [String] = []
                var listanev2 : [String] = []
                if let dataFromString = data2.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    
                    var db2 : Int = 0
                    for _ in json {
                        db2+=1
                    }
                    if db2 > 0 {
                        for i in 0...db2-1 {
                            
                            listaid2.append(String(htmlEncodedString: json[i]["jobName"].stringValue))
                            listanev2.append(String(htmlEncodedString: json[i]["jobId"].stringValue))
                        }
                        
                    }
                    healthyFoods2 = listaid2
                    subtitlemessage2 = listanev2
                    break
                }
                
                
            } else {
                
            }
            
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
    
    func wscomm(_ username: NSString) {
        
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'><SOAP-ENV:Header/><S:Body><ns2:Inactive xmlns:ns2='http:///'/></S:Body></S:Envelope>"
        
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
                var substring1 = responseString.components(separatedBy: "return>")[1]
                substring1.remove(at: substring1.characters.index(before: substring1.endIndex))
                substring1.remove(at: substring1.characters.index(before: substring1.endIndex))
                let prefs:UserDefaults = UserDefaults.standard
                prefs.set(substring1, forKey: "JOBS2")
            }else{prefs.set(nil, forKey: "JOBS2")}})
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthyFoods2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell2 = tableView2.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! TableViewCell2
        cell.column5.text = self.healthyFoods2[indexPath.row]
        cell.column4.text = self.subtitlemessage2[indexPath.row]
        cell.textLabel?.text = self.subtitlemessage2[indexPath.row]
        cell.textLabel?.isHidden = true

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        valueToPass = currentCell?.textLabel!.text

        // Get Cell Label
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ActiveJobDetails") as! ActiveJobDetails
        viewController.passedValue = currentCell?.textLabel!.text
        viewController.indexValue = "D"
        self.present(viewController, animated: true , completion: nil)
    }
    @IBAction func gotoback(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

