//
//  VerificationViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class VerificationViewController: UIViewController
{
   var customerID:String!
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    @IBOutlet weak var documentVerficationLbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
    //self.verificationStatus()
    
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        verificationStatus()
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        
        

        // Do any additional setup after loading the view.
    }

    
    func verificationStatus()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            
            let url = URL(string:"https://www.cykul.com/smartCykul/checkVerificationStatus.php")
            let body: String = "customerID=\(CMId)"
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
                        do
                        {
                            let myjson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                           
                            print("++++++++++++++++++++++++++++")
                            print(myjson)
                            var currentStatus = myjson["result"] as! String
                            
                            
                            
                            DispatchQueue.main.async()
                                {

                                    if currentStatus == "true"
                                    {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let message = myjson["message"] as! String
                                        print(message)
                                        
                                        let alertController = UIAlertController(title: "SmartCykul", message: message, preferredStyle: .alert)
                                        
                                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                            
                                            // Code in this block will trigger when OK button tapped.
                                            print("Ok button tapped");
                                            
                                        }
                                        
                                        alertController.addAction(OKAction)
                                        
                                        self.present(alertController, animated: true, completion:nil)

                                        
                                    }
                                    
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
    
    
    
    
    
    
    
    @IBAction func onTapCheckVerificationBtn(_ sender: Any)
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            
            let url = URL(string:"https://www.cykul.com/smartCykul/checkDocumentStatus.php")
            let body: String = "customerID=\(CMId)"
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
                        do
                        {
                            let myjson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                            print(myjson)
                            let message = myjson["message"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    let alertController = UIAlertController(title: "SmartCykul", message: message, preferredStyle: .alert)
                                    
                                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                        
                                        // Code in this block will trigger when OK button tapped.
                                        print("Ok button tapped");
                                        
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                        
                                    }
                                    
                                    alertController.addAction(OKAction)
                                    
                                    self.present(alertController, animated: true, completion:nil)
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
    
    @IBAction func verificationHomebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
