//
//  ViewControllerTest.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2017. 01. 30..
//  Copyright © 2017. Fekete András Demeter. All rights reserved.
//

import UIKit

class ViewControllerTest: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    

    var listitems = [] as [String]
    var subtitlemessage = [] as [String]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listitems = ["item1","item2","item3", "item4","item5"]
        subtitlemessage = ["value1","value2","value3","value4","value5"]
        
        
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
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! TableViewCell
        cell.column1.text = self.listitems[indexPath.row]
        cell.column2.text = self.subtitlemessage[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    @IBAction func gotoback(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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



    
    



