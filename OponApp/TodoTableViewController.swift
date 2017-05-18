//
//  TodoTableViewController.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 20..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit

class TodoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    func refreshList() {
        
        if (64 >= 64) {
            self.navigationItem.rightBarButtonItem!.enabled = false // disable 'add' button
        }
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) // retrieve the prototype cell (subtitle style)
        cell.textLabel?.text = "hello" as String!
        // the current time is later than the to-do item's deadline
            cell.detailTextLabel?.textColor = UIColor.redColor()

        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.detailTextLabel?.text = "hello"
        return cell
    }
}
