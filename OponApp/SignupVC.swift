//
//  SignupVC.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 13..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class SignupVC: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var TextRiportname: UITextField!
    @IBOutlet weak var textReasonname: UITextField!
    @IBOutlet weak var sendMail: UIButton!
    
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
          }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textUsername.delegate = self
        TextRiportname.delegate = self
        textReasonname.delegate = self
        let prefs: UserDefaults = UserDefaults.standard
        self.textUsername.text = prefs.value(forKey: "RESUSERNAME") as? String
        iNet = nil
        intraStat = nil
        SoapMess = ""
        
        InternetConnection()
        IntraNetConnection()
        
        if (intraStat==1 && iNet==true) {
            
            sendMail.isEnabled = true
            
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func sendMail(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let username:NSString = textUsername.text! as NSString
        let request_name:NSString = TextRiportname.text! as NSString
        let request_reason:NSString = textReasonname.text! as NSString
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["email@domain.com"])
        mailComposerVC.setSubject("Report request in-app() e-mail from: " + (username as String))
        
        mailComposerVC.setMessageBody("Report_Name: "+(request_name as String) + "\nrequest_reason: " + (request_reason as String) + "\n\nMegjegyzés: \n\nVisszajelzés az alkalmazásról: ", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func gotoLogin(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
}
