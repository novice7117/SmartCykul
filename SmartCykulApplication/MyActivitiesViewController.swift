//
//  MyActivitiesViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyActivitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var tableArray = [String]()
    var cyclenoArr=[String]()
    var farearr=[String]()
    var datearr = [String]()
    var statusArry = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cyclenoArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! ActivityCellOneTableViewCell
        cell1.backgroundColor = UIColor.white
        cell1.CellCycleNO.text = "CycleNo"
        cell1.StatusLbl.text = "Status"
        cell1.FareLbl.text = "Fare"
        cell1.DateLbl.text = "Date & Time"
        return cell1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ActivityCellTwoTableViewCell
        cell.CycleTwoLbl.text = cyclenoArr[indexPath.row] as? String
        cell.StatusLbl2.text = statusArry[indexPath.row] as? String
        cell.Fare2Lbl.text = farearr[indexPath.row] as? String
        cell.DateTime2Lbl.text = datearr[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    var customerID,stationName:String!
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var barBtn: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        if revealViewController != nil
        {
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
       
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        stationName = defaults.string(forKey: "StationName")
     //   customerID = "300534"
        self.json()
        
        // Do any additional setup after loading the view.
    }

   
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/myactivities.php")
            let body: String = "customerID=\(CMId)"
            //  print(body)
            // print("CustomerID==>==\(customerID!)")
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            
            
            
            let datatask = session.dataTask(with: request as URLRequest, completionHandler:
            {
                (data,response,error)-> Void in
                if (error != nil)
                {
                    print(error!)
                }
                else
                {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!)
                    if let data = data
                    {
                        do {
                            
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                            print("+++++++++++++++++++++++++++++++++++++")
                            //print(json.count)
                            // print("yesResponse : ++++>>  ", json)
                            var valueArry = Array(json.values)
                            
                            //let arr = json["1"] as! Dictionary<String,Any>
                            for obj in 0..<(valueArry.count - 1)
                            {
                                let s = String(obj)
                                
                                let dictVal = json[s]
                                let titleString = dictVal!["cycleName"] as! String
                                let dateString  = dictVal!["riderAction"] as! String
                                let date1String  = dictVal!["amount"] as! String
                                let mystring = dictVal!["date"] as! String
                                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                print("HEllllllllllllllllllll")
                                print(titleString)
                                print(dateString)
                                print(date1String)
                                print(mystring)
                                self.cyclenoArr.append(titleString)
                                self.statusArry.append(dateString)
                                self.farearr.append(date1String)
                                self.datearr.append(mystring)
                                
                            }
                            
                            DispatchQueue.main.async()
                                {
                                   self.TableView.reloadData()
                                    
                            }
                            
                            
                        }
                            
                            
                            
                        catch
                        {
                            print(error)
                        }
                        SVProgressHUD.dismiss()
                    }
                }
                
            })
            datatask.resume()
            TableView.reloadData()
        }
    }
 
    
    @IBAction func actihomebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
