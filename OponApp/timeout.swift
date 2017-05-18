//
//  timeout.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 18..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit

class timeout: UIViewController {
    var pushTimer: NSTimer!
    func time(){
        pushTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(logout), userInfo: nil, repeats: false)
    }
    func logout(){
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
    }
    func logoutnot(){
         pushTimer?.invalidate()
    }

    
}
