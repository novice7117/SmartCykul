//
//  SubscriptionViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 30/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD

class SubscriptionViewController: UIViewController,UITextFieldDelegate
{
    var customerID,stationName,mobileNumber,category,promoCode,package,coupon_Codee:String!
    @IBOutlet weak var promCodeLabel: UILabel!
    var orderID,transactionID,paymentAmount,paymentPurpose,paymentDate:String!
    var merchant:PGMerchantConfiguration!
    var Random,orderId,new,System:String!
    @IBOutlet weak var subscriptionStartsValueLbl: UILabel!
    @IBOutlet weak var subscriptionEndsValueLbl: UILabel!
    @IBOutlet weak var subFeeTopLbl: NSLayoutConstraint!
    @IBOutlet weak var subFeeValueLbl: NSLayoutConstraint!
    @IBOutlet weak var totalAmntTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalAmntValueTop: NSLayoutConstraint!
    @IBOutlet weak var subscriptionFeeLbl: UILabel!
    @IBOutlet weak var totalAmntValueLbl: UILabel!
    @IBOutlet weak var becomeMonthlyLbl: UILabel!
    @IBOutlet weak var pay399Lbl: UILabel!
    @IBOutlet weak var enjoyFirstLbl: UILabel!
    @IBOutlet var promocodeTF: UITextField!
    @IBOutlet weak var discountAppliedLbl: UILabel!
    @IBOutlet weak var dis399Lbl: UILabel!
    @IBOutlet weak var barBtn: UIBarButtonItem!
    var s = "399"
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        json()
        promocodeTF.resignFirstResponder()
        promCodeLabel.isHidden = true
        totalAmntValueLbl.text = "399"
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        setMerchant()
        let defaults = UserDefaults.standard
        customerID = defaults.string(forKey: "Customer_ID")
        stationName = defaults.string(forKey: "StationName")
        mobileNumber = defaults.string(forKey: "MobileNumber")
        category = "MONTHLY"
        promoCode = promocodeTF.text!
        package = "MONTHLY"
        stationName = "CYKUL"
        
        discountAppliedLbl.isHidden = true
        dis399Lbl.isHidden = true
        
        
       // totalAmntTopConstraint.constant = -7
       // totalAmntValueTop.constant = -7
        
      //  subFeeTopLbl.constant = 50
       // subFeeValueLbl.constant = 50
        
        promocodeTF.delegate = self
        
        
       // self.json()
        self.jsonForFee()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Applybtn(_ sender: Any)
    {
        if promocodeTF.text == ""
        {
            let alert = UIAlertController(title: "Login", message:"Please enter promocode", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
                self.jsonForApply()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if promocodeTF.text!.uppercased() == "CTV100" {
            promCodeLabel.text = "Promocode Successfull!"
            promCodeLabel.isHidden = false
            discountAppliedLbl.isHidden = false
            dis399Lbl.isHidden = false
            dis399Lbl.text = "₹ 398"
            totalAmntValueLbl.text = "₹ 1"
            s = "1"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                
                self.self.promCodeLabel.isHidden = true
            }
            
        }
        else{
            
           promCodeLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                
                self.self.promCodeLabel.isHidden = false
            }
        }
        
        //totalAmntTopConstraint.constant = 20
       // totalAmntValueTop.constant = 20
        
       // subFeeTopLbl.constant = 25
       //subFeeValueLbl.constant = 25
        
        
    
    }
    @IBAction func payBtn(_ sender: Any)
    {
        createPayment()
    }
    
    func jsonForApply()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/promoCode.php")
            let body: String = "stationName=\(stationName)&mobileNumber=\(mobileNumber)&category=\(category)&promoCode=\(promocodeTF.text!.uppercased())"
            
             print("promo...\(mobileNumber)&\(stationName)&\(category)&\(promoCode!)")
            
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
                            
                            let currentResultStatus = json["status"] as! String
                            print("~~~~~~~~~~~~~@@@@@@@@@@@@@@!!!!!!!!!!")
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let discount = json["discount"] as! String
                                        let discountPrice = json["discountprice"] as! String
                                        print("++++++++++++++++???????????????")
                                        self.dis399Lbl.text =  discountPrice
                                        self.totalAmntValueLbl.text =   discount
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
    
    func jsonForFee()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/subscriptionFee.php")
            let body: String = "stationName=\(stationName!)&package=\(package!)"
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
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let subscriptionFee = json["subscriptionFee"] as! String
                                        let couponCode = json["couponCode"] as! String
                                        let totalFee = json["totalFee"] as! String
                                        let messageContent = json["messageContent"] as! String
                                        let schemeOne = json["schemeOne"] as! String
                                        let schemeTwo = json["schemeTwo"] as! String
                                        
                                        
                                        
                                        self.subscriptionFeeLbl.text = "₹" + subscriptionFee
                                        self.totalAmntValueLbl.text = "₹" + totalFee
                                        self.becomeMonthlyLbl.text = messageContent
                                        self.pay399Lbl.text = schemeOne
                                        self.enjoyFirstLbl.text = schemeTwo
                                        
                                        
                                        
                                        self.coupon_Codee = couponCode
                                        if self.coupon_Codee == "1"
                                        {
                                            let coupon = json["coupon"] as! String
                                        }
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
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/fetchSubscriptionDetails.php")
            let body: String = "customerID=\(CMId)"
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
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let startDate = json["startDate"] as! String
                                        let endDate = json["endDate"] as! String
                                  
                                        self.subscriptionStartsValueLbl.text = startDate
                                        self.subscriptionEndsValueLbl.text = endDate
                                        
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
    
    @IBAction func homebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        var customerID:String = "CUST"
        var OrderID:String = "CYKSMART"
        var orderDict = [String : String]()
        orderDict["MID"] = "cykull90786400441790";//paste here your merchant id   //mandatory
        orderDict["CHANNEL_ID"] = "WAP"; // paste here channel id                       // mandatory
        orderDict["INDUSTRY_TYPE_ID"] = "Retail110";//paste industry type              //mandatory
        orderDict["WEBSITE"] = "cykulwap";// paste website                            //mandatory
        //Order configuration in the order object
        orderDict["TXN_AMOUNT"] = s; // amount to charge                      // mandatory
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



extension SubscriptionViewController:PGTransactionDelegate{
    
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
        orderID = response["ORDERID"]! as! String
        transactionID = response["TXNID"]! as! String
        paymentDate = response["TXNDATE"]! as! String
        paymentAmount = response["TXNAMOUNT"]! as! String
        paymentPurpose = "CYKUL RIDES"
       // self.json()
        print("......................>",response)
        self.removeController(contrl: controller)
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



