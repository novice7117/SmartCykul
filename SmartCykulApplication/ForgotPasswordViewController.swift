//
//  ForgotPasswordViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 01/02/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var mobilenotf: UITextField!
    
    var otpTextfield:UITextField!
    var mobileNumber,password:String!
    var receivedOTP,finalOTP:String!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let defaults = UserDefaults.standard
//        mobileNumber = defaults.string(forKey: "MobileNumber")
//
//        mobilenotf.text = mobileNumber

        
       mobilenotf.text = mobileNumber
        
        mobilenotf.rightViewMode = UITextFieldViewMode.always
        let imageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image5 = UIImage(named: "mobilenumber.png")
        imageView5.image = image5
        mobilenotf.rightView = imageView5
        mobilenotf.keyboardType = .numberPad
        
        //mobilenotf.text = mobileNumber
       // print("mobile noooo",mobilenotf.text! )
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func validatePhone(_ phoneNumber: String) -> Bool
    {
        let phoneRegex: String = "^[7-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    @IBAction func requestotp(_ sender: Any)
    {
//        if   mobilenotf.text == ""
//        {
//            let alert = UIAlertController(title: "Login", message:"Please enter mobile number", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
//                UIAlertAction) -> Void in
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
        
        
       //else
        //{
            json()
       // }
        
        
        let alert = UIAlertController(title: "Enter OTP", message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler:
            {(_ action: UIAlertAction) -> Void in
                
            self.otp()
                
       }))
            
            alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter OTP"
            textField.textColor = UIColor.blue
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
            textField.keyboardType = .numberPad
            self.otpTextfield = textField
                
                if textField == nil
                {
                    let alert = UIAlertController(title: "Alert", message:"OTP field can't be empty.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler:
                        {(_ action: UIAlertAction) -> Void in
                    self.present(alert, animated: true, completion: nil)
                }))
        }
        }
            self.present(alert, animated: true, completion: nil)
            
        //}
        
        
    }
    
 
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        SVProgressHUD.show(withStatus: "Loading...")
       let url = URL(string:"https://www.cykul.com/smartCykul/forgotPassword.php")
        //let body: String = "mobileNumber=\(mobilenotf.text!)"
        let body: String = "mobileNumber=\(mobileNumber!)"
        print(mobilenotf.text!)
            let defaults = UserDefaults.standard
            defaults.set(mobileNumber, forKey: "ForgotMobile")
            defaults.synchronize()
            
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
    
    func otp()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        SVProgressHUD.show(withStatus: "Loading...")
        receivedOTP = otpTextfield.text
        print("OTP",receivedOTP!)
       
        let url = URL(string:"https://www.cykul.com/smartCykul/validateOTP.php")
       // let body: String = "generatedOTP=\(receivedOTP!)&mobileNumber=\(mobilenotf.text!)"
       let body: String = "generatedOTP=\(receivedOTP!)&mobileNumber=\(mobileNumber!)"
        print(mobilenotf.text!)
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
                        let myJson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                        print("yesResponse : ++++>>  ", myJson)
                        
                        let currentResultStatus = myJson["result_status"] as! String
                        //let currentReportStatus = json["report_status"] as! String
                        
                        DispatchQueue.main.async()
                            {
                                SVProgressHUD.dismiss()
                                if currentResultStatus == "true"
                                {
                                    
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier:"rvc") as! RequestedOTPViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Attention", message:currentResultStatus, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                                    }))
                                    self.present(alert, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
