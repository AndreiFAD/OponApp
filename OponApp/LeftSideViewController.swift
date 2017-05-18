//
//  LeftSideViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 01. 29..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var tableView: UITableView!
    
    var valueToPass:String!
    var nameuser = ""
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    var listitems = [] as [String]
    var subtitlemessage = [] as [String]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listitems = ["List items","Avalilable Reports","Reporting Home (privateweb)", "Email Send","Logout","Report - Active Jobs","Report - Inactive Jobs"]
        subtitlemessage = ["tabtest","chartlist","webhome","mail","logout","SchedulerActive","SchedulerInactive"]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidAppear(true)
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"itemCell")
        cell.textLabel?.text = listitems[(indexPath as NSIndexPath).row] as String
        
        cell.detailTextLabel?.text = (subtitlemessage[(indexPath as NSIndexPath).row] as String)
        cell.detailTextLabel?.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!;
        
        valueToPass = currentCell?.detailTextLabel?.text
        
        var viewController: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (valueToPass=="webhome") {
            viewController = storyboard.instantiateViewController(withIdentifier: "WebPage") as! WebPage
        } else if (valueToPass=="mail") {
            viewController = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        } else if (valueToPass=="logout" || valueToPass=="Login") {
            let appDomain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        } else if (valueToPass=="chartlist") {
            viewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        } else if (valueToPass=="tabtest") {
            viewController = storyboard.instantiateViewController(withIdentifier: "ViewControllerTest") as! ViewControllerTest
        } else if (valueToPass=="SchedulerActive") {
            viewController = storyboard.instantiateViewController(withIdentifier: "SchedulerActivJobViewController") as! SchedulerActivJobViewController
            
        } else if (valueToPass=="SchedulerInactive") {
            viewController = storyboard.instantiateViewController(withIdentifier: "SchedulerInactivJobViewController") as! SchedulerInactivJobViewController
            
        } else {

            viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        }
        self.present(viewController, animated: true , completion: nil)
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
