//
//  ChartStringFormatter.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 11. 03..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import Foundation
import Charts

class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]! =  ["A", "B", "C", "D"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues[Int(value)])
    }
}
