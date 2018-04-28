//
//  FeedbackViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedbackViewController: UIViewController,UITextViewDelegate
{
    var customerID,stationName,mobile_Number:String!
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        textView.delegate = self
        //textView.text = "please provide feedback"
        textView.textColor = .lightGray
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        
        
        
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        stationName = defaults.string(forKey: "StationName")
        mobile_Number = defaults.string(forKey:"ForgotMobile")
       
        // Do any additional setup after loading the view.
    }
    
    //delegates for textview
    
    
   
    @IBAction func onTapSubmitBtn(_ sender: Any)
    {
        self.json()
        
    }
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            stationName = "CYKUL"
            // let stationName:String!
            let url = URL(string:"https://www.cykul.com/smartCykul/feedback.php")
            let body: String = "customerID=\(CMId)&feedback=\(textView.text!)&mobileNumber=\(mbID)"
            //print("feedback==>==\(customerID!)&\(textView.text!)&\(mobile_Number!)")
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
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                        
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

    @IBAction func feedbackhome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //textview delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //placeholder text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Please provide your feedback")
        {
            textView.text = ""
        }
        //textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = "Please provide your feedback"
        }
        //textView.becomeFirstResponder()
    }
}
