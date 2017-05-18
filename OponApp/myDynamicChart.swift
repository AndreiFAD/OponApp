//
//  myDynamicChart.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 15..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import Charts
import UIKit
import MessageUI
import Foundation

class myDynamicChart: UIViewController, MFMailComposeViewControllerDelegate {
    
    var devicetype: String!
    var passedValue:String!
    var indexValue: String!
    var gameTimer: Timer!
    var resusername: String!
    var iNet: Bool!
    var intraStat: Int!
    var SoapMess: String!
    var colors: [UIColor] = []
    var maxYaxis: Double!
    var maxYaxis2: Double!

    @IBOutlet weak var activityIND: UIActivityIndicatorView!
    @IBOutlet weak var activityIND2: UIActivityIndicatorView!
    @IBOutlet weak var activityIND3: UIActivityIndicatorView!
    @IBOutlet weak var activityIND4: UIActivityIndicatorView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var combinedCartView: CombinedChartView!
    
    @IBOutlet weak var labelout: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        InternetConnection()
        IntraNetConnection()
        lineChartView.noDataText = "Loading..."
        pieChartView.noDataText = "Loading..."
        barChartView.noDataText = "Loading..."
        combinedCartView.noDataText = "Loading..."
        
        labelout.text = passedValue
        
        if (intraStat==1 && iNet==true) {
            
            idogomb.selectedSegmentIndex = 0
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(nil, forKey: "REPORT")
            
            if (indexValue=="L") {
                lineChartViewDidStartLoad(lineChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="P") {
                pieChartViewDidStartLoad(pieChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="B") {
                barChartViewDidStartLoad(barChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="C") {
                combinedChartViewDidStartLoad(combinedCartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else {
                if ( UIDevice.current.userInterfaceIdiom == .phone)
                {
                    devicetype = "phone"  /* Device is iPad */
                } else {
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        devicetype = "ipad"   /* Device is iPad */
                    } else {
                        devicetype = "another"
                    }
                }
                lineChartView.isHidden = true
                pieChartView.isHidden = true
                barChartView.isHidden = true
                combinedCartView.isHidden = true
            }
            
        } else {
            let intraStatString = "false"
            let alert = UIAlertController(title: "Network Connection Failed!", message: "Internet connection status: " + String(iNet).uppercased() + "\nIntranet connection status: " + intraStatString.uppercased() + "\nPlease check your connections \nand \nRestart App!", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    func combinedChartViewDidStartLoad(_ view: CombinedChartView) {
        activityIND4.isHidden = false
        activityIND4.startAnimating()
    }
    
    func combinedChartViewDidFinishLoad(_ view: CombinedChartView) {
        activityIND4.isHidden = true
        activityIND4.stopAnimating()
    }
    func barChartViewDidStartLoad(_ view: BarChartView) {
        activityIND3.isHidden = false
        activityIND3.startAnimating()
    }
    
    func barChartViewDidFinishLoad(_ view: BarChartView) {
        activityIND3.isHidden = true
        activityIND3.stopAnimating()
    }
    
    func lineChartViewDidStartLoad(_ view: LineChartView) {
        activityIND.isHidden = false
        activityIND.startAnimating()
    }
    
    func lineChartViewDidFinishLoad(_ view: LineChartView) {
        activityIND.isHidden = true
        activityIND.stopAnimating()
    }
    
    func pieChartViewDidStartLoad(_ view: PieChartView) {
        activityIND2.isHidden = false
        activityIND2.startAnimating()
    }
    
    func pieChartViewDidFinishLoad(_ view: PieChartView) {
        activityIND2.isHidden = true
        activityIND2.stopAnimating()
    }
    
    @IBOutlet weak var idogomb: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
    
        switch idogomb.selectedSegmentIndex
        {
        case 0:
            
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(nil, forKey: "REPORT")
            if (indexValue=="L") {
                lineChartViewDidStartLoad(lineChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="P") {
                pieChartViewDidStartLoad(pieChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="B") {
                barChartViewDidStartLoad(barChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="C") {
                combinedChartViewDidStartLoad(combinedCartView)
                diagram(indexValue,valtoGomb: "DAY")
  
            } else {
            
            }
        case 1:
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(nil, forKey: "REPORT")
            
            if (indexValue=="L") {
                lineChartViewDidStartLoad(lineChartView)
                diagram(indexValue,valtoGomb: "WEEK")
                
            } else if (indexValue=="P") {
                pieChartViewDidStartLoad(pieChartView)
                diagram(indexValue,valtoGomb: "WEEK")
                
            } else if (indexValue=="B") {
                barChartViewDidStartLoad(barChartView)
                diagram(indexValue,valtoGomb: "WEEK")
                
            } else if (indexValue=="C") {
                combinedChartViewDidStartLoad(combinedCartView)
                diagram(indexValue,valtoGomb: "WEEK")
                
            } else {
            }
        case 2:
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(nil, forKey: "REPORT")
          
            if (indexValue=="L") {
                lineChartViewDidStartLoad(lineChartView)
                diagram(indexValue,valtoGomb: "MONTH")
                
            } else if (indexValue=="P") {
                pieChartViewDidStartLoad(pieChartView)
                diagram(indexValue,valtoGomb: "MONTH")
                
            } else if (indexValue=="B") {
                barChartViewDidStartLoad(barChartView)
                diagram(indexValue,valtoGomb: "MONTH")
                
            } else if (indexValue=="C") {
                combinedChartViewDidStartLoad(combinedCartView)
                diagram(indexValue,valtoGomb: "MONTH")
                
            } else {
            }
        default: break
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        iNet = nil
        intraStat = nil
        SoapMess = ""
        
        InternetConnection()
        IntraNetConnection()
        lineChartView.noDataText = "Loading..."
        pieChartView.noDataText = "Loading..."
        barChartView.noDataText = "Loading..."
        combinedCartView.noDataText = "Loading..."
        
        if (intraStat==1 && iNet==true) {
            
            idogomb.selectedSegmentIndex = 0
            let prefs:UserDefaults = UserDefaults.standard
            prefs.set(nil, forKey: "REPORT")
            
            if (indexValue=="L") {
                lineChartViewDidStartLoad(lineChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="P") {
                pieChartViewDidStartLoad(pieChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="B") {
                barChartViewDidStartLoad(barChartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else if (indexValue=="C") {
                combinedChartViewDidStartLoad(combinedCartView)
                diagram(indexValue,valtoGomb: "DAY")
                
            } else {
                if ( UIDevice.current.userInterfaceIdiom == .phone)
                {
                    devicetype = "phone"  /* Device is iPhone */
                } else {
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        devicetype = "ipad"   /* Device is iPad */
                    } else {
                        devicetype = "another"
                    }
                }
            lineChartView.isHidden = true
            pieChartView.isHidden = true
            barChartView.isHidden = true
            combinedCartView.isHidden = true
            }

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
        sleep(1)
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

    
    func diagram(_ typpe: String, valtoGomb: String) {
        
        var itemsFieldName: [String] = []
        var chartsDatas: [Double] = []
        var BarAlapokAdatok: [AnyObject] = []

        var PieAlapokAdatok: [AnyObject] = []
        
        var LineAlapokAdatok: [AnyObject] = []
        
        
        var diadescription: String! = ""
        
        
        let prefs:UserDefaults = UserDefaults.standard
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
        
        let alert = UIAlertController(title: "Sign in again!", message: "Please restart App!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        } else {
            resusername = (prefs.value(forKey: "RESUSERNAME") as? String)!
        }
    
 
        wscomm(resusername as NSString,report:passedValue,activity:passedValue, timzone: valtoGomb)
        
            diadescription = passedValue
        
            for _ in 0...9 {
                Thread.sleep(forTimeInterval: 0.1)
                if ( (prefs.value(forKey: "REPORT") as? String) != nil ) {
                    var substring = prefs.value(forKey: "REPORT") as? String
                    substring = substring?.replacingOccurrences(of: ",", with: ".")
                    let inputs = substring!.components(separatedBy: "#")

                    for i in 1...inputs.count-1 {
                        var adat_l = inputs[i].components(separatedBy: "';'")
                        
                        adat_l.remove(at: 0)
                        if (adat_l[1] == "FieldName") {
                            adat_l.remove(at: 0)
                            adat_l.remove(at: 0)
                            itemsFieldName = adat_l
                            
                        } else if (adat_l[0] == "BarChart") {
                            if (indexValue=="C"){
                                let dataStringName=adat_l[1]
                                adat_l.remove(at: 0)
                                adat_l.remove(at: 0)
                                
                                chartsDatas = adat_l.map{ NSString(string: $0).doubleValue }
                                
                                maxYaxis2 = chartsDatas.max()
                                let setelement = setChartsElemlent("B", dataStrings: dataStringName, datavalues: chartsDatas) as! BarChartDataSet
                                BarAlapokAdatok.append(setelement)

                            } else {
                                let dataStringName=adat_l[1]
                                adat_l.remove(at: 0)
                                adat_l.remove(at: 0)
                                chartsDatas = adat_l.map{ NSString(string: $0).doubleValue }
                                BarAlapokAdatok.append(setChartsElemlent("B", dataStrings: dataStringName, datavalues: chartsDatas) as! BarChartDataSet)
                            }
                            
                        } else if (adat_l[0] == "LineChart") {
                            if (indexValue=="C"){
                                let dataStringName=adat_l[1]
                                adat_l.remove(at: 0)
                                adat_l.remove(at: 0)
                                
                                chartsDatas = adat_l.map{ NSString(string: $0).doubleValue }
                                
                                maxYaxis = chartsDatas.max()
                                let setelement = setChartsElemlent("L", dataStrings: dataStringName, datavalues: chartsDatas) as! LineChartDataSet
                                setelement.axisDependency = .right
                                LineAlapokAdatok.append(setelement)
                            } else {
                                let dataStringName=adat_l[1]
                                adat_l.remove(at: 0)
                                adat_l.remove(at: 0)
                                chartsDatas = adat_l.map{ NSString(string: $0).doubleValue }
                                LineAlapokAdatok.append(setChartsElemlent("L", dataStrings: dataStringName, datavalues: chartsDatas) as! LineChartDataSet)
                            }
                            
                        } else if (adat_l[0] == "PieChart") {
                            let dataStringName=adat_l[1]
                            adat_l.remove(at: 0)
                            adat_l.remove(at: 0)
                            chartsDatas = adat_l.map{ NSString(string: $0).doubleValue }
                            PieAlapokAdatok.append(setChartsElemlent("P", dataStrings: dataStringName, datavalues: chartsDatas) as! PieChartDataSet)
                            break
                            
                        }
                            
                    }
                    
                    var device = ""
                    if  (UIDevice.current.userInterfaceIdiom == .phone) {
                        device = ".Phone"
                    } else if (UIDevice.current.userInterfaceIdiom == .pad) {
                        device = ".Pad"
                    } else {
                        device = ".Unspecified"
                    }
                    if (device == ".Phone"){
                        if (itemsFieldName.count-9 >= 0) {
                            var xy = itemsFieldName.count-9
                            while (xy >= 0) {
                                itemsFieldName.remove(at: 0)
                                xy = itemsFieldName.count-9
                            }
                        } else {
                        }
                    } else {
                        if (itemsFieldName.count-33 >= 0) {
                            var xy = itemsFieldName.count-33
                            while (xy >= 0) {
                                itemsFieldName.remove(at: 0)
                                xy = itemsFieldName.count-33
                            }
                        } else {
                        }
                    }
                    
                    var linedataSets : [LineChartDataSet] = [LineChartDataSet]()
                    var bardataSets : [BarChartDataSet] = [BarChartDataSet]()
                    var bardataSet : [BarChartDataSet] = [BarChartDataSet]()
                    var piedataSets : [PieChartDataSet] = [PieChartDataSet]()
                    
                    if (typpe=="L"){
                        
                        for i in 0...LineAlapokAdatok.count-1 {
                            linedataSets.append(LineAlapokAdatok[i] as! LineChartDataSet)
                        }
                        lineChartMegmutat(data: linedataSets, dataPoints: itemsFieldName, text: diadescription)
                        
                    } else if (typpe=="P") {
                        for i in 0...PieAlapokAdatok.count-1 {
                            piedataSets.append(PieAlapokAdatok[i] as! PieChartDataSet)
                        }
                        pieChartMegmutat(piedataSets, dataPoints: itemsFieldName, text: diadescription)
                        
                    } else if (typpe=="B") {
                        
                        for i in 0...BarAlapokAdatok.count-1 {
                            bardataSets.append(BarAlapokAdatok[i] as! BarChartDataSet)
                        }
                        
                        barChartMegmutat(bardataSets, dataPoints: itemsFieldName, text: diadescription)
                        
                    } else if (typpe=="C") {
                        
                        for i in 0...BarAlapokAdatok.count-1 {
                            bardataSet.append(BarAlapokAdatok[i] as! BarChartDataSet)
                            
                        }
                        for i in 0...LineAlapokAdatok.count-1 {
                            linedataSets.append(LineAlapokAdatok[i] as! LineChartDataSet)
                        }
                        combinedChartMegmutat(bardataSet, dataline: linedataSets, dataPoints: itemsFieldName, text: diadescription)
                        
                    } else {
                        
                    }
                    
                    break
                
                } else {
                    
                }
                
                Thread.sleep(forTimeInterval: 0.2)
            }
    
        }
    
    func wscomm(_ username: NSString, report: String, activity: String, timzone: String) {
        
        var device = ""
        if  (UIDevice.current.userInterfaceIdiom == .phone) {
            device = ".Phone"
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            device = ".Pad"
        } else {
            device = ".Unspecified"
        }
        
        let xmlStr: String? =  "<S:Envelope xmlns:S='http://schemas.xmlsoap.org/soap/envelope/' xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'>\n<SOAP-ENV:Header/>\n<S:Body>\n<ns2:diagram xmlns:ns2='http:///'>\n<report>"+(report as String)+"</report>\n<timzone>"+(timzone as String)+"</timzone>\n<user>"+(username as String)+"</user>\n<DEVICE>"+(device as String)+"</DEVICE>\n<ACTIVITY>"+activity+"</ACTIVITY>\n</ns2:diagram>\n</S:Body>\n</S:Envelope>"
      
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
                prefs.set(substring, forKey: "REPORT")
            }else{prefs.set(nil, forKey: "REPORT")}})
        task.resume()
        
    }
    
    func setChartsElemlent(_ chartstype: String, dataStrings: String, datavalues: [Double]) -> AnyObject {
        
        var adatok = datavalues
        var device = ""
        
        if  (UIDevice.current.userInterfaceIdiom == .phone) {
            device = ".Phone"
        } else if (UIDevice.current.userInterfaceIdiom == .pad) {
            device = ".Pad"
        } else {
            device = ".Unspecified"
        }
        
        if (device == ".Phone"){
            if (adatok.count-9 >= 0) {
                var xy = adatok.count-9
                while (xy >= 0) {
                    adatok.remove(at: 0)
                    xy = adatok.count-9
                }
                
            } else {
            }
        } else {
            if (adatok.count-33 >= 0) {
                var xy = adatok.count-33
                while (xy >= 0) {
                    adatok.remove(at: 0)
                    xy = adatok.count-33
                }
                
            } else {
            }
        }
        
        if (chartstype=="L"){
            
            var dataEntriesLine: [ChartDataEntry] = []
            for i in 0..<adatok.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: adatok[i])
                dataEntriesLine.append(dataEntry)
            }
            let lineChartDataSet = LineChartDataSet(values: dataEntriesLine, label: dataStrings)
            return lineChartDataSet
        } else if (chartstype=="B"){
            
            var dataEntriesBar: [BarChartDataEntry] = []
            for i in 0..<adatok.count {
                let dataEntry = BarChartDataEntry(x: Double(i), y: adatok[i])
                dataEntriesBar.append(dataEntry)
            }
            let barChartDataSet = BarChartDataSet(values: dataEntriesBar, label: dataStrings)
            
            return barChartDataSet
            
        } else if (chartstype=="P"){
            
            var dataEntriesPie: [ChartDataEntry] = []
            for i in 0..<adatok.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: adatok[i])
                dataEntriesPie.append(dataEntry)
                
            }
            let pieChartDataSet = PieChartDataSet(values: dataEntriesPie, label: dataStrings)
            return pieChartDataSet
            
        } else {
            
            return "noData" as AnyObject
            
        }
    }

    func lineChartMegmutat(data: [LineChartDataSet], dataPoints: [String], text: String) {
        pieChartView.isHidden = true
        barChartView.isHidden = true
        combinedCartView.isHidden = true

        let lineChartData: LineChartData = LineChartData.init(dataSets: data)

        lineChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .easeInBounce)
        
        lineChartView.chartDescription?.text = text
        
        let formatter = ChartStringFormatter()
        formatter.nameValues = dataPoints
        lineChartView.xAxis.valueFormatter = formatter
        lineChartView.xAxis.granularity = 1
        
        lineChartView.xAxis.axisMinimum = -0.5
        lineChartView.xAxis.axisMaximum = Double(data[0].entryCount)-0.5
        
        lineChartView.data = lineChartData
        lineChartView.xAxis.wordWrapEnabled = true
        
        lineChartViewDidFinishLoad(lineChartView)

        lineChartView.isHidden = false
        
    }
    
    func pieChartMegmutat(_ data: [PieChartDataSet], dataPoints: [String], text: String) {
        lineChartView.isHidden = true
        barChartView.isHidden = true
        combinedCartView.isHidden = true
        
        /*
        let formatter = ChartStringFormatter()
        formatter.nameValues = dataPoints
        pieChartView.xAxis.valueFormatter = formatter
        pieChartView.xAxis.granularity = 1
        */
        
        let pieChartData = PieChartData.init(dataSets: data)

        
        pieChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutBack)
        
        pieChartView.chartDescription?.text = text
        
        pieChartView.data = pieChartData
        pieChartViewDidFinishLoad(pieChartView)
        
        pieChartView.isHidden = false

    }
    
    func barChartMegmutat(_ data: [BarChartDataSet], dataPoints: [String], text: String) {
        lineChartView.isHidden = true
        pieChartView.isHidden = true
        combinedCartView.isHidden = true
        
        
        let barchartData = BarChartData.init(dataSets: data)

        barchartData.barWidth = 0.375
        
        let formatter = ChartStringFormatter()
        formatter.nameValues = dataPoints
        barChartView.xAxis.valueFormatter = formatter
        barChartView.xAxis.granularity = 1

        barChartView.xAxis.wordWrapEnabled = true

        
        barchartData.groupBars(fromX: -0.5, groupSpace: 0.1, barSpace: 0.075)
        
        //barChartView.groupBars(fromX: 0.0, groupSpace: 0.1, barSpace: 0.2)
        
        barChartView.xAxis.axisMinimum = -0.5
        barChartView.xAxis.axisMaximum = Double(data[0].entryCount)-0.5

        barChartView.animate(xAxisDuration: 2, yAxisDuration: 2, easingOption: .easeInBounce)
        
        barChartView.chartDescription?.text = text
        
        barChartView.data = BarChartData(dataSets: data)
        
        self.barChartView.data = barchartData
        barChartViewDidFinishLoad(barChartView)
        
        barChartView.isHidden = false

    }
    func combinedChartMegmutat(_ databar: [BarChartDataSet], dataline: [LineChartDataSet], dataPoints: [String], text: String) {
        lineChartView.isHidden = true
        pieChartView.isHidden = true
        barChartView.isHidden = true

        let lineChartData = LineChartData.init(dataSets: dataline)
        let barchartData = BarChartData.init(dataSets: databar)
        let dataComChart: CombinedChartData = CombinedChartData()
        
        barchartData.barWidth = 0.375
        barchartData.groupBars(fromX: -0.5, groupSpace: 0.1, barSpace: 0.075)
        
        dataComChart.barData = barchartData
        dataComChart.lineData = lineChartData
        
        let formatter = ChartStringFormatter()
        formatter.nameValues = dataPoints
        combinedCartView.xAxis.valueFormatter = formatter
        combinedCartView.xAxis.granularity = 1
        
        //combinedCartView.drawBarShadowEnabled = true
        //combinedCartView.borderLineWidth = 0.4

        combinedCartView.xAxis.wordWrapEnabled = true
        
        combinedCartView.leftAxis.axisMinimum = 0.0
        combinedCartView.rightAxis.axisMinimum = 0.0
        combinedCartView.leftAxis.axisMaximum = maxYaxis2 * 1.5
        combinedCartView.rightAxis.axisMaximum = maxYaxis * 1.15
        combinedCartView.animate(xAxisDuration: 0.2, yAxisDuration: 1.0, easingOption: .easeInBounce)
        combinedCartView.chartDescription?.text = text
        combinedCartView.data = dataComChart
        
        combinedCartView.xAxis.axisMinimum = -0.5
        combinedCartView.xAxis.axisMaximum = Double(databar[0].entryCount)-0.5
        
        combinedChartViewDidFinishLoad(combinedCartView)
        combinedCartView.isHidden = false
        
    }
    
    @IBAction func bacck(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func gotoApexPage(_ sender: AnyObject) {

        let mailjpg = captureScreen()
        
        let mailComposeViewController = configuredMailComposeViewController(mailjpg)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    func captureScreen() -> UIImage {
        var window: UIWindow? = UIApplication.shared.keyWindow
        window = UIApplication.shared.windows[0] 
        UIGraphicsBeginImageContextWithOptions(window!.frame.size, window!.isOpaque, 0.0)
        window!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
    func configuredMailComposeViewController(_ mailjpg: UIImage) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["email@domain.com"])
        mailComposerVC.setSubject("Report request in-app(OponApp) e-mail from: " + resusername)

        mailComposerVC.setMessageBody("Report_Name: "+passedValue+"\n\nÉszrevétel az alábbi riportal kapcsolatban: \n\n\n\n\n", isHTML: false)
        
        mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(mailjpg, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  passedValue+".jpeg")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
