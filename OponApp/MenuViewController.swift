//
//  MenuViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 15..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var valueToPass:String!
    var nameuser = ""
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    var healthyFoods = [] as [String]
    var subtitlemessage = [] as [String]

 
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

            
            listrequest()
            
        } else {
            let intraStatString = "false"
            let alert = UIAlertController(title: "Network Connection Failed!", message: "Internet connection status: "  + "\nIntranet connection status: " + intraStatString.uppercased() + "\nPlease check your connections \nand \nRestart App!", preferredStyle: UIAlertControllerStyle.alert)
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
        listrequest()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
        
    func listrequest() {
        
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
        
            for _ in 0...9 {
                 Thread.sleep(forTimeInterval: 0.1)
                if ( (prefs.value(forKey: "MENU") as? String) != nil ) {
                    let substring = prefs.value(forKey: "MENU") as? String
                    let lista = substring!.components(separatedBy: "#")[1]
                    let param = substring!.components(separatedBy: "#")[2]
                    var fejlectomb=lista.components(separatedBy: "';'")
                    fejlectomb.remove(at: 0)
                    var beerkezetttomb = param.components(separatedBy: "';'")
                    beerkezetttomb.remove(at: 0)
                    healthyFoods = fejlectomb
                    subtitlemessage = beerkezetttomb
                    break
                } else {
                    
                }
                
                Thread.sleep(forTimeInterval: 0.2)
            }
    }
    func wscomm(_ username: NSString) {
        
        var device = ""
        if  (UIDevice.current.userInterfaceIdiom == .phone) {
            device = ".Phone"
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            device = ".Pad"
        } else {
            device = ".Unspecified"
        }
        
        let activity = "menu_list"
        
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n<SOAP-ENV:Header/>\n<S:Body>\n<ns2:menu xmlns:ns2='http:///'>\n<user>"+(username as String)+"</user>\n<DEVICE>"+(device as String)+"</DEVICE>\n<ACTIVITY>"+activity+"</ACTIVITY>\n</ns2:menu>\n</S:Body>\n</S:Envelope>"
        
        var request = URLRequest(url: URL(string: "http://iphost:8080//?WSDL")!)
        request.timeoutInterval = 3.0
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
                prefs.set(substring, forKey: "MENU")
            }else{prefs.set(nil, forKey: "MENU")}})
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthyFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"healthyCell")
        cell.textLabel?.text = healthyFoods[(indexPath as NSIndexPath).row] as String
        cell.detailTextLabel?.text = (subtitlemessage[(indexPath as NSIndexPath).row] as String)
        cell.detailTextLabel?.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        valueToPass = currentCell?.textLabel!.text

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "myDynamicChart") as! myDynamicChart
        viewController.passedValue = currentCell?.textLabel!.text
        viewController.indexValue = currentCell?.detailTextLabel!.text
        self.present(viewController, animated: true , completion: nil)
    }
    @IBAction func gotoback(_ sender: AnyObject) {
       self.dismiss(animated: true, completion: nil)
    }
    
}
