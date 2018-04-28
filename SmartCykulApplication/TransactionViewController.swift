//
//  TransactionViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class TransactionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var tableview: UITableView!
    var tableArray = [String]()
    var customerID:String!
    var cyclenameArray=[String]()
    var riderActionArray=[String]()
    var dateArry = [String]()
    
   // var dictStore : [String]()
    
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("!!!!!!!!!!!!!!!!!! MY COUNT !!!!!!!!!!!!!!!!!!")
            
            print(cyclenameArray.count)
        return cyclenameArray.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        cell1.backgroundColor = UIColor.white
        cell1.label1.text = "Purpose"
        cell1.label2.text = "Amount"
        cell1.label3.text = "Date &Time"
        return cell1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TransactionsTableViewCell
        cell.paymentPurposeLBL.text = cyclenameArray[indexPath.row] as? String
        cell.PaymentAmountLBL.text = riderActionArray[indexPath.row] as? String
        cell.PaymentDateLBL.text = dateArry[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 75.0
        return 40
    }
    @IBOutlet weak var barBtn: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        json()
        tableview.delegate = self
        tableview.dataSource = self
        if revealViewController != nil
        {
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        //customerID = "3003"
}
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/transaction.php")
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
                                let titleString = dictVal!["paymentPurpose"] as! String
                                let dateString  = dictVal!["paymentAmount"] as! String
                                let date1String  = dictVal!["paymentDate"] as! String
                                print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                print("HEllllllllllllllllllll")
                                print(titleString)
                                self.cyclenameArray.append(titleString)
                                self.riderActionArray.append(dateString)
                                self.dateArry.append(date1String)
                                
                            }
                            
                            DispatchQueue.main.async()
                                {
                                    self.tableview.reloadData()
                                    
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
            tableview.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        self.tableview .reloadData()
    }
    
    @IBAction func homeTransbtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
