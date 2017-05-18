//
//  ChartViewClass.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 14..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit
import Charts

class ChartViewClass: UIViewController, ChartViewDelegate,UITextFieldDelegate {
    
    
    
    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    var gameTimer: NSTimer!
    var resusername: String!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://hostdomain.intra")!)
        request.timeoutInterval = 3.0
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        connection.start()
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        var jelezes: [String] = []
        var adat1: [Double] = []
        var jelezes2: [String] = []
        var adat12: [Double] = []
        
        do {
            let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n<SOAP-ENV:Header/>\n<S:Body>\n<ns2:test xmlns:ns2='http:///'/>\n</S:Body>\n</S:Envelope>"
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://iphost:8080//?WSDL")!)
            request.timeoutInterval = 3.0
            request.HTTPMethod = "POST"
            let post:NSString = xmlStr!
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            request.HTTPBody = postData
            request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            connection.start()
            
            var response: NSURLResponse?
            
            let data = try NSURLConnection.sendSynchronousRequest(request , returningResponse: &response)
            let responseString: String = String(data: data, encoding: NSUTF8StringEncoding)!
            var substring = responseString.componentsSeparatedByString("return>")[1]
            substring.removeAtIndex(substring.endIndex.predecessor())
            substring.removeAtIndex(substring.endIndex.predecessor())

            var fejlec = substring.componentsSeparatedByString("#")[1]
            var beerkezett = substring.componentsSeparatedByString("#")[2]
            var lezart = substring.componentsSeparatedByString("#")[3]
            var sl = substring.componentsSeparatedByString("#")[4]
   
            var fejlectomb=fejlec.componentsSeparatedByString("';'")
            fejlectomb.removeAtIndex(0)
            var beerkezetttomb = beerkezett.componentsSeparatedByString("';'")
            beerkezetttomb.removeAtIndex(0)
            var lezarttomb = lezart.componentsSeparatedByString("';'")
            lezarttomb.removeAtIndex(0)
            var sltomb = sl.componentsSeparatedByString("';'")
            sltomb.removeAtIndex(0)
            
            let b = beerkezetttomb.map{ NSString(string: $0).doubleValue }
            let l = lezarttomb.map{ NSString(string: $0).doubleValue }
            let s = sltomb.map{ NSString(string: $0).doubleValue }
            
            jelezes = fejlectomb
            adat1 = b

            let xmlStr2: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n<SOAP-ENV:Header/>\n<S:Body>\n<ns2:value xmlns:ns2='http:///'/>\n</S:Body>\n</S:Envelope>"
            
            let request2 = NSMutableURLRequest(URL: NSURL(string: "http://iphost:8080//?WSDL")!)
            request2.timeoutInterval = 3.0
            request2.HTTPMethod = "POST"
            let post2:NSString = xmlStr2!
            let postData2:NSData = post2.dataUsingEncoding(NSUTF8StringEncoding)!
            request2.HTTPBody = postData2
            request2.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let connection2: NSURLConnection = NSURLConnection(request: request2, delegate: self, startImmediately: true)!
            connection2.start()
            
            var response2: NSURLResponse?

            let data2 = try NSURLConnection.sendSynchronousRequest(request2 , returningResponse: &response2)
            let responseString2: String = String(data: data2, encoding: NSUTF8StringEncoding)!
            var substring2 = responseString2.componentsSeparatedByString("return>")[1]
            substring2.removeAtIndex(substring2.endIndex.predecessor())
            substring2.removeAtIndex(substring2.endIndex.predecessor())

            
            let fejlec2 = substring2.componentsSeparatedByString("#")[1]
            let beerkezett2 = substring2.componentsSeparatedByString("#")[2]
            let lezart2 = substring2.componentsSeparatedByString("#")[3]
            let sl2 = substring2.componentsSeparatedByString("#")[4]
            
            var fejlectomb2=fejlec2.componentsSeparatedByString("';'")
            fejlectomb2.removeAtIndex(0)
            var beerkezetttomb2 = beerkezett2.componentsSeparatedByString("';'")
            beerkezetttomb2.removeAtIndex(0)
            var lezarttomb2 = lezart2.componentsSeparatedByString("';'")
            lezarttomb2.removeAtIndex(0)
            var sltomb2 = sl2.componentsSeparatedByString("';'")
            sltomb2.removeAtIndex(0)
            
            let b2 = beerkezetttomb2.map{ NSString(string: $0).doubleValue }
            let l2 = lezarttomb2.map{ NSString(string: $0).doubleValue }
            let s2 = sltomb2.map{ NSString(string: $0).doubleValue }
            
            jelezes = fejlectomb
            adat1 = b

            jelezes2 = fejlectomb2
            adat12 = b2
    } catch let error as NSError{
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = error.localizedDescription
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }

        let months = jelezes
        let unitsSold = adat1
        
        setChart(months, values: unitsSold, typp: jelezes2, adatok: adat12)
    }
    
    func setChart(dataPoints: [String], values: [Double], typp: [String], adatok: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<adatok.count {
            let dataEntry2 = ChartDataEntry(value: adatok[i], xIndex: i)
            dataEntries2.append(dataEntry2)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries2, label: "Input")
        let pieChartData = PieChartData(xVals: typp, dataSet: pieChartDataSet)
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0, easingOption: .EaseInOutBack)
        pieChartView.centerText = "One or Two"
        pieChartView.descriptionText = "description"
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        var color: UIColor = UIColor()
        for i in 0..<typp.count {
            
            if (i == 0) {
                color = UIColor.lightGrayColor()
                colors.append(color)
              } else {
                color = UIColor(colorLiteralRed: 226/255, green: 0, blue: 116/255, alpha: 1)
                colors.append(color)
            }
        }
        
        pieChartDataSet.colors = colors
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Input")
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSets: dataSets)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        lineChartView.descriptionText = "Input description"
        lineChartView.data = lineChartData
        
    }
    
    @IBAction func visszalepes(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
