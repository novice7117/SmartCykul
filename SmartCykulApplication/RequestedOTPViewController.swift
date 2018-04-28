//
//  RequestedOTPViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 01/02/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class RequestedOTPViewController: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmNewPwdTF: UITextField!
    var customerID,mobileNumber,mobile_Number,password:String!
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        mobileNumber = defaults.string(forKey: "MobileNumber")
        password = defaults.string(forKey: "Password")
        
        mobile_Number = defaults.string(forKey: "ForgotMobile")
        

        newPwdTF.delegate = self
        newPwdTF.rightViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image1 = UIImage(named: "key-7-150x150.png")
        imageView1.image = image1
        newPwdTF.rightView = imageView1
        
    
        confirmNewPwdTF.delegate = self
        confirmNewPwdTF.rightViewMode = UITextFieldViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image2 = UIImage(named: "key-7-150x150.png")
        imageView2.image = image2
        confirmNewPwdTF.rightView = imageView2
        
    }

    @IBAction func onTapChangePwdBtn(_ sender: Any)
    {
        
        if newPwdTF.text == "" || confirmNewPwdTF.text == ""
        {
            let alert = UIAlertController(title: "Alert", message:"Please enter the new password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
                {(_ action:
                    UIAlertAction) -> Void in
                }))
            self.present(alert, animated: true, completion: nil)
        }
            
            
        else
        {
            json()
        }
    }
    
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        SVProgressHUD.show(withStatus: "Loading...")
        let url = URL(string:"https://www.cykul.com/smartCykul/updatePassword.php")
        let body: String = "mobileNumber=\(mobile_Number!)&password=\(newPwdTF.text!)"
        print("pwd...\(mobile_Number!)&\(newPwdTF.text!)")
            
       // let defaults = UserDefaults.standard
       // defaults.set(newPwdTF.text, forKey: "New_Password")
            
            
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
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                        print(json)
                        
                        let currentResultStatus = json["result_status"] as! String
                         print("yesResponse : ++++>>  ",json)
                        
                        DispatchQueue.main.async()
                            {
                                SVProgressHUD.dismiss()
                                if currentResultStatus == "true"
                                {
                                    
                                    //self.performSegue(withIdentifier: "sw_front", sender: nil)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                    self.navigationController?.present(vc, animated: true, completion: nil)
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Attention", message:currentResultStatus, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
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
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
