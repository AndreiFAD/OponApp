//
//  WebPage.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 18..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit
import Foundation

class WebPage: UIViewController, UIWebViewDelegate {

    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    
    @IBOutlet weak var loadPage: UIActivityIndicatorView!
    @IBOutlet weak var Apexsite: UIWebView!
    
    
    func loadFirstAid(){
        let requestFirstAidURL = URL (string: "https://private.web.page.com")
        let requestFirstAid = URLRequest(url: requestFirstAidURL!)
        Apexsite.loadRequest(requestFirstAid)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Apexsite.delegate = self
        
        loadPage.isHidden = true
        iNet = nil
        intraStat = nil
        SoapMess = ""
        
        InternetConnection()
        IntraNetConnection()
        
        if (intraStat==1 && iNet==true) {
            
            loadFirstAid()
            
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
    
    func webViewDidStartLoad(_ Apexsite: UIWebView) {
        loadPage.startAnimating()
    }
    
    func webViewDidFinishLoad(_ Apexsite: UIWebView) {
        loadPage.stopAnimating()
        
        let prefs:UserDefaults = UserDefaults.standard
        let resusername = (prefs.value(forKey: "RESUSERNAME") as? String)!
        let respass = (prefs.value(forKey: "USERPASS") as? String)!
        
        let savedUsername = resusername
        let savedPassword = respass
        
        let fillForm = String(format: "document.getElementById('USERNAME').value = '\(savedUsername)';document.getElementById('PASSWORD').value = '\(savedPassword)';")
        let fillForm2 = String(format: "document.getElementById('USERNAME').value = '\(savedUsername)';document.getElementById('PASSWORD').value = '\(savedPassword)';")
        
        Apexsite.stringByEvaluatingJavaScript(from: fillForm)
        Apexsite.stringByEvaluatingJavaScript(from: fillForm2)
        
        //submit form
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()){
        //    Apexsite.stringByEvaluatingJavaScriptFromString("document.getElementById('P101_LOGIN').click();")
        //}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    @IBAction func dorefresh(_: AnyObject) {
        Apexsite.reload()
    }
    
    @IBAction func goBack(_: AnyObject) {
        Apexsite.goBack()
    }
    
    @IBAction func goForward(_: AnyObject) {
        Apexsite.goForward()
    }
    
    @IBAction func stop(_: AnyObject) {
        Apexsite.stopLoading()
    }
    
    @IBAction func gotoback(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}



