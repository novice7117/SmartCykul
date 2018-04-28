//
//  MyBalanceViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import IQKeyboardManagerSwift

class MyBalanceViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var addmoneylabl: UILabel!
    var customerID,transactionID,paymentAmount,paymentPurpose,paymentDate:String!
    var merchant:PGMerchantConfiguration!
    var Random,orderId,new,System:String!
    var stationName,cykulPayy:String!
    @IBAction func homebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBOutlet weak var barBtn: UIBarButtonItem!
    @IBOutlet weak var Rs0Lbl: UILabel!
    
    @IBOutlet weak var addMoneyTF: UITextField!
    
    var totalString = ""
    var oddValue = ""
    var textFieldValue = ""
    var total : Int = 0
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        print(CMId)
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        
        setMerchant()
        
        let defaults = UserDefaults.standard
       // CMId = defaults.string(forKey: "Customer_ID")!
        stationName = defaults.string(forKey: "StationName")
        
        self.jsonCheck()
        
        addMoneyTF.delegate = self
        addMoneyTF.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTap10Btn(_ sender: Any)
    {
        if addMoneyTF.text == ""
        {
            addMoneyTF.text = "10"
        }
            
        else if addMoneyTF.text! >= "0"
        {
            textFieldValue = addMoneyTF.text!
            let ItextFieldValue = Int(textFieldValue)
            total = ItextFieldValue! + 10
            if total != nil
            {
                let value = String(total)
                addMoneyTF.text = value
                total = total + 10
                totalString = "\(total)"
            }
        }
    }
    
    
    
    @IBAction func onTap50Btn(_ sender: Any)
    {
        if addMoneyTF.text == ""
        {
            addMoneyTF.text = "50"
        }
            
        else if addMoneyTF.text! >= "0"
        {
            textFieldValue = addMoneyTF.text!
            let ItextFieldValue = Int(textFieldValue)
            total = ItextFieldValue! + 50
            if total != nil
            {
                let value = String(total)
                addMoneyTF.text = value
                total = total + 50
                totalString = "\(total)"
            }
        }
        
    }
    
    @IBAction func onTap100Btn(_ sender: Any)
    {
        if addMoneyTF.text == ""
        {
            addMoneyTF.text = "100"
        }
            
        else if addMoneyTF.text! >= "0"
        {
            textFieldValue = addMoneyTF.text!
            let ItextFieldValue = Int(textFieldValue)
            total = ItextFieldValue! + 100
            if total != nil
            {
                let value = String(total)
                addMoneyTF.text = value
                total = total + 100
                totalString = "\(total)"
                
            }
        }
        
    }
    
    @IBAction func onTapAddBtn(_ sender: Any)
    {
       
       
        
        if addMoneyTF.text == "" ||  addMoneyTF.text == "0"
        {
            let alert = UIAlertController(title: "Attention", message:"Please enter the amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if addMoneyTF.text != nil
        {
            textFieldValue = addMoneyTF.text!
            let ItextFieldValue = Int(textFieldValue)
            
            if ItextFieldValue! % 10 == 0
            {
                
                let value = String(ItextFieldValue!)
                
                let alert = UIAlertController(title: "Thank you!", message:"You have enterd the ₹" + value + " amount", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    
                    self.createPayment()
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Attention", message:"Please enter the multiples of 10 only...", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                   // self.json()
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
           }
    
    
  

    
    func json(body: String)
    {
        
        // customerID = "CUST"
//        orderId = response["ORDERID"]! as! String
//        transactionID = response["TXNID"]! as! String
//        paymentDate = response["TXNDATE"]! as! String
//        paymentAmount = response["TXNAMOUNT"]! as! String
//        paymentPurpose = "CYKUL RIDES"
        
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            
             print("#################################")
             print("#################################")
             print("#################################")
             print("#################################")
            print(CMId)
            
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/cykulPay.php")
//            let body: String = "customerID=\(CMId)&orderID=\(orderId)&transactionID=\(transactionID)&paymentAmount=\(paymentAmount)&paymentDate=\(paymentDate)&paymentPurpose=\(paymentPurpose)"
         //   print("result========>\(customerID!)==\(orderId!)==\(transactionID!)==\(paymentAmount!)==\(paymentDate!)==\(paymentPurpose!)")
            //  print("pwd...\(mobile_Number!)&\(newPwdTF.text!)")
            
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
                            
                            let currentStatus = json["result"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    
                                    if currentStatus == "true"
                                    {
                                        print("paytm payment sucessfully")
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Transaction Successful", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Smart Cykul", message:"Transaction Faild", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        }))
                                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                                    }
                            

                            }
                        }
                        catch
                        {
                            print(error)
                        }
                        //SVProgressHUD.dismiss()
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
    
    func jsonCheck()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/checkCykulPay.php")
            let body: String = "customerID=\(CMId)&stationName=\(stationName!)"
            //  print("pwd...\(mobile_Number!)&\(newPwdTF.text!)")
            
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
                            
                            let currentResultStatus = json["result"] as! String
                            let cycleValue = json["cykulpay"]
                            let s:String = String(format:"%f", (cycleValue as AnyObject).doubleValue) //formats the string to accept double/float
                            print("+++++++++++++++++++++++++++")
                            print(s)
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        self.Rs0Lbl.text = String(s.characters.prefix(5))
                                        //                                        let cykulPay = json["cykulpay"] as! String
                                        //                                        //let rideCharge = json["rideCharge"] as! String
                                        //
                                        //                                        self.cykulPayy = cykulPay
                                        //
                                        //                                        if self.cykulPayy == nil
                                        //                                        {
                                        //                                            self.Rs0Lbl.text = "₹ 0"
                                        //                                        }
                                        //                                        else
                                        //                                        {
                                        //                                            self.Rs0Lbl.text = cykulPay
                                        //                                        }
                                        
                                        
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
    
    
    //------------------paytm------------------------------
    
    
    func setMerchant()
    {
        merchant  = PGMerchantConfiguration.default()!
        //user your checksum urls here or connect to paytm developer team for this or use default urls of paytm
        merchant.checksumGenerationURL = "https://www.cykul.com/Apps/PaytmWallet/paymentchecksumgeneration.php";
        merchant.checksumValidationURL = "https://www.cykul.com/Apps/PaytmWallet/paymentchecksumvalidation.php";
        
        // Set the client SSL certificate path. Certificate.p12 is the certificate which you received from Paytm during the registration process. Set the password if the certificate is protected by a password.
        merchant.clientSSLCertPath = nil; //[[NSBundle mainBundle]pathForResource:@"Certificate" ofType:@"p12"];
        merchant.clientSSLCertPassword = nil; //@"password";
        
        //configure the PGMerchantConfiguration object specific to your requirements
        merchant.merchantID = "cykull90786400441790";//paste here your merchant id  //mandatory
        merchant.website = "cykulwap";//mandatory
        merchant.industryID = "Retail110";//mandatory
        merchant.channelID = "WAP"; //provided by PG WAP //mandatory
        
    }
    
    
    func createPayment()
    {
        
        // var customerID,transactionID,paymentAmount,paymentPurpose,paymentDate:String!
        var customerID:String = "CUST"
        var OrderID:String = "CYKSMART"
        var orderDict = [String : String]()
        orderDict["MID"] = "cykull90786400441790";//paste here your merchant id   //mandatory
        orderDict["CHANNEL_ID"] = "WAP"; // paste here channel id                       // mandatory
        orderDict["INDUSTRY_TYPE_ID"] = "Retail110";//paste industry type              //mandatory
        orderDict["WEBSITE"] = "cykulwap";// paste website                            //mandatory
        //Order configuration in the order object
        let l: String = "\(total)"
        orderDict["TXN_AMOUNT"] = "1"; // amount to charge                      // mandatory
//        transactionID = ""
//        paymentAmount = addMoneyTF.text!
//        paymentPurpose = "CYKULRIDES"
//        paymentDate = "26/04/2018"
        orderDict["ORDER_ID"] = "\(Date().timeIntervalSince1970)";//change order id every time on new transaction
        //orderDict["ORDER_ID"] = "CYKSMART";
        orderDict["REQUEST_TYPE"] = "DEFAULT";// remain same
        orderDict["CUST_ID"] = "CUST"; // change acc. to your database user/customers
        orderDict["MOBILE_NO"] = "9076111005";// optional
        orderDict["EMAIL"] = "sumanthgopi143@gmailcom"; //optional
        let pgOrder = PGOrder(params: orderDict )
        
        
        //        let order = PGOrder(params: orderDict)
        //        debugLog(order)
        //        self.txnController = PGTransactionViewController(transactionForOrder: order)
        //        //A staging server is a mix between production and development; you get to test your app as if it were in production
        //
        //
        //        self.txnController!.serverType = eServerTypeStaging
        //
        //        // Set the merchant configuration for the transaction.
        //        self.txnController!.merchant = pgMerchantConfiguration
        //        // A delegate object should be set to handle the responses coming during the transaction
        //        self.txnController!.delegate = self
        //        self.navigationController?.pushViewController(self.txnController!, animated:true)
        //
        //
       // json()
        let transaction = PGTransactionViewController.init(transactionFor: pgOrder)
        
        transaction!.serverType = eServerTypeProduction
        transaction!.merchant = merchant
        transaction!.loggingEnabled = true
        transaction!.delegate = self as! PGTransactionDelegate
        //        let tVC = storyboard?.instantiateViewController(withIdentifier: "PGTransactionViewController") as! PGTransactionViewController
        self.navigationController?.pushViewController(transaction!, animated: true)
        //        self.present(transaction!, animated: true, completion: {
        //            print("subscriptin paytm payment sucessfuly")
        //        })
        //  self.navigationController?.pushViewController(transaction!, animated: true)
        // navigationController?.popViewController(animated: true)
    }
    
}



//func didCancelTransaction(controller: PGTransactionViewController!, error: NSError!, response: [NSObject : AnyObject]!) {
//
//
//
//    var customerID:String = "CUST"
//    var OrderID:String = "CYKSMART"
//    var orderDict = [String : String]()
//    orderDict["MID"] = "cykull90786400441790";//paste here your merchant id   //mandatory
//    orderDict["CHANNEL_ID"] = "WAP"; // paste here channel id                       // mandatory
//    orderDict["INDUSTRY_TYPE_ID"] = "Retail110";//paste industry type              //mandatory
//    orderDict["WEBSITE"] = "cykulwap";// paste website                            //mandatory
//    //Order configuration in the order object
//    orderDict["TXN_AMOUNT"] = "1"; // amount to charge                      // mandatory
//    orderDict["ORDER_ID"] = "\(Date().timeIntervalSince1970)";//change order id every time on new transaction
//    //orderDict["ORDER_ID"] = "CYKSMART";
//    orderDict["REQUEST_TYPE"] = "DEFAULT";// remain same
//    orderDict["CUST_ID"] = "CUST"; // change acc. to your database user/customers
//    orderDict["MOBILE_NO"] = "9076111005";// optional
//    orderDict["EMAIL"] = "sumanthgopi143@gmailcom"; //optional
//
//    let pgOrder = PGOrder(params: orderDict )
//    let transaction = PGTransactionViewController.init(transactionFor: pgOrder)
//    if transaction != nil {
//        //Access AbcViewController in navigation stack and pop
//        for viewController in self.navigationController!.viewControllers as [UIViewController] {
//            if viewController.isKindOfClass(AbcViewController) {
//                self.navigationController?.popToViewController(viewController, animated: false)
//                return
//            }
//
//        }
//    }
//
//
//}



extension MyBalanceViewController:PGTransactionDelegate{
    
    func showcontroller(contrl:PGTransactionViewController){
        if (self.navigationController != nil){
            self.navigationController?.pushViewController(contrl, animated: true)
        }else{
            self.present(contrl, animated: true, completion: {
                
            })
        }
    }
    
    func removeController(contrl:PGTransactionViewController){
        if(self.navigationController != nil){
            self.navigationController?.popViewController(animated: true)
        }else{
            contrl.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    func showAlert(title:String,message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func didSucceedTransaction(_ controller: PGTransactionViewController!, response: [AnyHashable : Any]!) {
        customerID = "CUST"
        orderId = response["ORDERID"]! as! String
        transactionID = response["TXNID"]! as! String
        paymentDate = response["TXNDATE"]! as! String
        paymentAmount = response["TXNAMOUNT"]! as! String
        paymentPurpose = "CYKUL RIDES"

        print("......................>",response)
        self.removeController(contrl: controller)
        self.json(body: "customerID=\(CMId)&orderID=\(orderId)&transactionID=\(transactionID)&paymentAmount=\(paymentAmount)&paymentDate=\(paymentDate)&paymentPurpose=\(paymentPurpose)"
        )
        print(CMId)
        print(orderId)
        print(transactionID)
        print(paymentDate)
        print(paymentAmount)
        print(paymentPurpose)
        print("payment Done")
        let alert = UIAlertController(title: "Smart Cykul", message:"Transaction Successful", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func didFailTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        self.removeController(contrl: controller)
        
    }
    
    func didCancelTransaction(_ controller: PGTransactionViewController!, error: Error!, response: [AnyHashable : Any]!) {
        self.removeController(contrl: controller)
    }
    
    func didFinishCASTransaction(_ controller: PGTransactionViewController!, response: [AnyHashable : Any]!) {
        print(response)
        //showAlert(title: "cas", message: "")
        //  self.removeController(contrl: controller)
    }
    
    enum UIKeyboardType : Int {
        case Default
        case ASCIICapable
        case NumbersAndPunctuation
        case URL
        case NumberPad
        case PhonePad
        case NamePhonePad
        case EmailAddress
        case DecimalPad
        case Twitter
        case WebSearch
    }
}






