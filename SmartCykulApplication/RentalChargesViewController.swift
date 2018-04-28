//
//  RentalChargesViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class RentalChargesViewController: UIViewController
{
    var customerID,stationName:String!
    
    @IBOutlet weak var first30MinValueLbl: UILabel!

    @IBOutlet weak var additional30minsValueLbl: UILabel!
    @IBOutlet weak var every30MinValueLbl: UILabel!
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        stationName = defaults.string(forKey: "StationName")
        self.json()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        SVProgressHUD.show(withStatus: "Loading...")
        let url = URL(string:"https://www.cykul.com/smartCykul/rateCard.php")
        let body: String = "stationName=\(stationName!)"
        print("CustomerID==>==\(stationName!)")
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
                        print("yesResponse : ++++>>  ", json)
                        
                        let currentResultStatus = json["result"] as! String
                        //let currentReportStatus = json["report_status"] as! String
                        
                        DispatchQueue.main.async()
                            {
                                SVProgressHUD.dismiss()
                              if currentResultStatus == "true"
                                {
                                    let currentFirst30Mins = json["subFirst30mins"] as! String
                                    let currentEveryAdd30Mins = json["subAdditional30mins"] as! String
                                    let currentEvery30Mins = json["payNGo30mins"] as! String
                                    
                                    
                                    self.first30MinValueLbl.text =  currentFirst30Mins
                                    self.additional30minsValueLbl.text = "₹" + currentEveryAdd30Mins
                                    self.every30MinValueLbl.text = "₹" + currentEvery30Mins
                                    
                                   
//                                    let defaults = UserDefaults.standard
//                                    defaults.set(currentFirst30Mins, forKey: "SubFirst30Min")
//                                    defaults.set(currentEveryAdd30Mins, forKey: "SubAdditionl30Min")
//                                    defaults.set(currentEvery30Mins, forKey: "PayNGO30Min")
//                                    defaults.synchronize()
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Attention", message:currentResultStatus, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                                // self.tableView.reloadData()
                                // SVProgressHUD.dismiss()
                                
                                
                        }
                    }
                        
                        
                    catch
                    {
                        print(error)
                    }
                }
            }
            
        })
        datatask.resume()
    }
        
        else
        {
            let alert = UIAlertController(title: "Attention", message:"Please check your network connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            print("There is no internet connection")
        }
    }
    
  
    @IBAction func rentalbtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
