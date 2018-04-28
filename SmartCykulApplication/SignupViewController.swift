//
//  SignupViewController.swift
//  SmartCykul
//
//  Created by Cykul Cykul on 29/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import SDWebImage

class SignupViewController: UIViewController,UITextFieldDelegate
{
   

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var orgTF: UITextField!
    @IBOutlet weak var eMailIDTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var otpTextfield:UITextField!
    var enterOTP:String!
    
     var firstName,lastName,organization,emailID,mobileNumber,password,stationName,countElements:String!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        firstName = defaults.string(forKey: "FirstName")
        lastName = defaults.string(forKey: "LastName")
        organization = defaults.string(forKey: "Organization")
        emailID = defaults.string(forKey: "EmailID")
        mobileNumber = defaults.string(forKey: "MobileNumber")
        password = defaults.string(forKey: "Password")
        stationName = defaults.string(forKey: "StationName")
       
      //let customer_ID = defaults.string(forKey: "Customer_ID")
        //let mobileNumber = defaults.string(forKey: "MobileNumber")
        //let firstName = defaults.string(forKey: "FirstName")
        
        
       // defaults.set(fir, forKey: "FirstName")
        
        passwordTF.delegate = self
        passwordTF.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "key-7-150x150.png")
        imageView.image = image
        passwordTF.rightView = imageView
        
        firstNameTF.delegate = self
        firstNameTF.rightViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image1 = UIImage(named: "48169-200.png")
        imageView1.image = image1
        firstNameTF.rightView = imageView1
        firstNameTF.autocapitalizationType = .words
        
        lastNameTF.delegate = self
        lastNameTF.rightViewMode = UITextFieldViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image2 = UIImage(named: "48169-200.png")
        imageView2.image = image2
        lastNameTF.rightView = imageView2
        lastNameTF.autocapitalizationType = .words
        
        orgTF.delegate = self
        orgTF.rightViewMode = UITextFieldViewMode.always
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image3 = UIImage(named: "organization.png")
        imageView3.image = image3
        orgTF.rightView = imageView3
        orgTF.autocapitalizationType = .words
        
        eMailIDTF.delegate = self
        eMailIDTF.rightViewMode = UITextFieldViewMode.always
        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image4 = UIImage(named: "email.png")
        imageView4.image = image4
        eMailIDTF.rightView = imageView4
        eMailIDTF.keyboardType = .emailAddress
        
        mobileNumberTF.delegate = self
        mobileNumberTF.rightViewMode = UITextFieldViewMode.always
        let imageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image5 = UIImage(named: "m.png")
        imageView5.image = image5
        mobileNumberTF.rightView = imageView5
        mobileNumberTF.keyboardType = .numberPad
        

        // Do any additional setup after loading the view.
    }
    
    func isValid(_ email: String) -> Bool
    {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func validatePhone(_ phoneNumber: String) -> Bool
    {
        let phoneRegex: String = "^[7-9][0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    @IBAction func onTapSubmitBtn(_ sender: Any)
    {
        if (firstNameTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter first name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            firstNameTF.shake()
        }
        else if(lastNameTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter last name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            lastNameTF.shake()
        }
        else if(orgTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter organization", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            orgTF.shake()
        }
        else if(eMailIDTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            eMailIDTF.shake()
        }
        else if(mobileNumberTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter  mobilenumber", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            mobileNumberTF.shake()
        }
        else if(passwordTF.text == "")
        {
            let alert = UIAlertController(title: "Login", message:"Please enter password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            passwordTF.shake()
        }
        
       else if firstNameTF.text == "" || lastNameTF.text == "" || orgTF.text == "" || eMailIDTF.text == "" || mobileNumberTF.text == "" || passwordTF.text == ""
        {
            let alert = UIAlertController(title: "Login", message:"Please fill the details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.json()
            
            //Creating User defaults and set the values for particular keys
            let defaults = UserDefaults.standard
            defaults.set(firstNameTF.text, forKey: "FirstName")
            defaults.set(lastNameTF.text, forKey: "LastName")
            defaults.set(orgTF.text, forKey: "Organization")
            defaults.set(eMailIDTF.text, forKey: "EmailID")
            defaults.set(mobileNumberTF.text, forKey: "MobileNumber")
            defaults.set(passwordTF.text, forKey: "Password")
            defaults.set(stationName, forKey: "StationName")
           // defaults.set(existedgeneratedOTP, forKey: "GeneratedOTP"
            
            //defaults.synchronize() for saving the defaults
            defaults.synchronize()

            
            if !isValid(eMailIDTF.text!)
            {
                let error = UIAlertController(title: "Ooops", message: "Enter the valid mail", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                error.addAction(ok)
                present(error, animated: true,completion: nil)
                
            }
                
            else
            {
                if !validatePhone(mobileNumberTF.text!)
                {
                    let error = UIAlertController(title: "Ooops", message: "Enter the valid mobile number", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    error.addAction(ok)
                    present(error, animated: true,completion: nil)
                    
                }
            }
  
    }
    
}
    
func json()
 {
    if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
    {
    SVProgressHUD.show(withStatus: "Loading...")
    stationName = "CYKUL"
    // let stationName:String!
    let url = URL(string:"https://www.cykul.com/smartCykul/tempRegistration.php")
    let body: String = "firstName=\(firstNameTF.text!)&lastName=\(lastNameTF.text!)&organization=\(orgTF.text!)&emailID=\(eMailIDTF.text!)&mobileNumber=\(mobileNumberTF.text!)&password=\(passwordTF.text!)&station_name=\(stationName!)"
    print("signup==>==\(mobileNumberTF.text!)&\(passwordTF.text!)&\(firstNameTF.text!)&\(lastNameTF.text!)&\(eMailIDTF.text!)&\(orgTF.text!)&\(stationName!)")
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
                                let alert = UIAlertController(title: "Enter OTP", message:"", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler:
                                    {(_ action: UIAlertAction) -> Void in
                                    
                                        let alert = UIAlertController(title: "SmartCykul", message:"Congratulations Your are Sucessfully Register for SmartCykulAPP", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(_ action: UIAlertAction) -> Void in
                                            self.jsonOTP()
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    
                                    }))
                                alert.addTextField
                                    {
                                    (textField : UITextField!) -> Void in
                                    textField.placeholder = "Enter OTP"
                                    textField.textColor = UIColor.blue
                                    textField.clearButtonMode = .whileEditing
                                    textField.borderStyle = .roundedRect
                                    textField.keyboardType = .numberPad
                                    self.otpTextfield = textField
                                    }
                                self.present(alert, animated: true, completion: nil)
         
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
    
    
    
    func jsonOTP()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        SVProgressHUD.show(withStatus: "Loading...")
       // let stationName:String! = "CYKUL"
        enterOTP = otpTextfield.text
        let url = URL(string:"https://www.cykul.com/smartCykul/validateOTP.php")
//             let body: String = "firstName=\(firstName!)&lastName=\(lastName!)&organization=\(organization!)&emailID=\(emailID!)&mobileNumber=\(mobileNumber!)&password=\(password!)&station_name=\(stationName!)&generatedOTP=\(enterOTP!)"
       let body: String = "firstName=\(firstNameTF.text!)&lastName=\(lastNameTF.text!)&organization=\(orgTF.text!)&emailID=\(eMailIDTF.text!)&mobileNumber=\(mobileNumberTF.text!)&password=\(passwordTF.text!)&station_name=\(stationName!)&generatedOTP=\(enterOTP!)"
      //  print("ValidateOTP==>==\(mobileNumberTF.text!)&\(passwordTF.text!)&\(firstNameTF.text!)")
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
                        
                        let currentResultStatus = json["result_status"] as! String
                        //let currentReportStatus = json["report_status"] as! String
                        
                        DispatchQueue.main.async()
                            {
                                SVProgressHUD.dismiss()
                                if currentResultStatus == "true"
                                {
                                   self.json1()
                         
                                      // let existedFirstName = json["firstName"] as! String
//                                        let existedLastName = json["lastName"] as! String
//                                        let existedMobileNumber = json["mobileNumber"] as! String
//                                        let existedemailID = json["emailID"] as! String
//                                        let existedOrganization = json["organization"] as! String
//                                        let existedStationName = json["station_name"] as! String
//                                        let existedPassword = json["password"] as! String
//        //                                //let existedgeneratedOTP = json["generatedOTP"] as! String
//
//                                       let defaults = UserDefaults.standard
//                                        defaults.set(existedFirstName, forKey: "FirstName")
//                                        defaults.set(existedLastName, forKey: "LastName")
//                                        defaults.set(existedOrganization, forKey: "Organization")
//                                        defaults.set(existedemailID, forKey: "EmailID")
//                                        defaults.set(existedMobileNumber, forKey: "MobileNumber")
//                                        defaults.set(existedPassword, forKey: "Password")
//                                        defaults.set(existedStationName, forKey: "StationName")
//        //                               // defaults.set(existedgeneratedOTP, forKey: "GeneratedOTP")
//                                        defaults.synchronize()
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
    
    func json1()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/addCustomer.php")
              let body: String = "firstName=\(firstNameTF.text!)&lastName=\(lastNameTF.text!)&organization=\(orgTF.text!)&emailID=\(eMailIDTF.text!)&mobileNumber=\(mobileNumberTF.text!)&password=\(passwordTF.text!)&station_name=\(stationName!)"
//           let body: String = "firstName=\(firstName!)&lastName=\(lastName!)&organization=\(organization!)&emailID=\(emailID!)&mobileNumber=\(mobileNumber!)&password=\(password!)&station_name=\(stationName!)"
            //print("ValidateOTP==>==\(mobileNumberTF.text!)&\(passwordTF.text!)&\(String(describing: firstNameTF.text))")
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
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                        
                                        let currentCustomerID = json["customerID"] as! Int
                                        print("CustomerID::::",currentCustomerID)
                                        
                                        let defaults = UserDefaults.standard
                                        defaults.set(currentCustomerID, forKey: "Customer_ID")
                                        defaults.synchronize()
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


extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
