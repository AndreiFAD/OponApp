//
//  defalult_classes.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 18..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

open class Reachability {
    
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func postData() {
        
        var request = URLRequest(url: URL(string: "http://intrahostconnect.intra")!)
        request.timeoutInterval = 5.0
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let prefs:UserDefaults = UserDefaults.standard
            if (response != nil) {
            let results = (response as! HTTPURLResponse).statusCode
            prefs.set(results, forKey: "INTRANET")
            }else{prefs.set(0, forKey: "INTRANET")}})
        task.resume()
        
    }
   
}
