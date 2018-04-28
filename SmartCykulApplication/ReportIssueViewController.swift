//
//  ReportIssueViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 17/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import SVProgressHUD
import CoreLocation

var k = ""
var dict = [String:String]()


class ReportIssueViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate
{
    var itemPicker : UIPickerView! = UIPickerView()
    var pickerData = [String]()
    
    var componentArray = [String]()
    
    @IBOutlet weak var ReturnCycle: UITextField!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var scanQRTF: UITextField!
    @IBOutlet weak var barBtn: UIBarButtonItem!
    let locationManager = CLLocationManager()
    
    var addressVariable = 0
    
    var latToServer : String = ""
    var lonToServer : String = ""
    var addressToServer : String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        textview.delegate = self
        textview.text = "placeholder text here..."
        textview.textColor = .lightGray
        
        if (revealViewController() != nil)
        {
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            
            print("delegate called")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
        pickerData = ["Unable to Return Cycle","Unable to Lock Cycle","Unable to Unlock Cycle","Lock Broken","Puncture","Chain Issue","Other"]
        ReturnCycle.inputView = itemPicker
        itemPicker.delegate = self
        itemPicker.dataSource = self
        ReturnCycle.delegate = self
        
        
        
        
        let addressDictionary = ["HMR63281": "FF:FF:11:00:04:EC",
                                 "HMR63282": "FF:FF:11:00:04:B2",
                                 "HMR63283": "FF:FF:11:00:04:EE",
                                 "HMR63284": "FF:FF:11:00:04:B8",
                                 "HMR63285": "FF:FF:11:00:04:BF",
                                 "HMR63286": "FF:FF:11:00:04:CB",
                                 "HMR63287": "FF:FF:11:00:04:D7",
                                 "HMR63288": "FF:FF:11:00:04:E4",
                                 "HMR63289": "FF:FF:11:00:04:97",
                                 "HMR63290": "FF:FF:11:00:04:C5",
                                 "HMR63291": "FF:FF:11:00:04:E0",
                                 "HMR63292": "FF:FF:11:00:04:F1",
                                 "HMR63294": "FF:FF:11:00:04:D5",
                                 "HMR63293": "FF:FF:11:00:04:DE",
                                 "HMR63295": "FF:FF:11:00:04:C2",
                                 "HMR63296": "FF:FF:11:00:04:E1",
                                 "HMR63297": "FF:FF:11:00:04:CD",
                                 "HMR63298": "FF:FF:11:00:04:AC",
                                 "HMR63299": "FF:FF:11:00:04:B0",
                                 "HMR63300": "FF:FF:11:00:04:AE",
                                 "HMR63301": "FF:FF:11:00:04:B6",
                                 "HMR63302": "FF:FF:11:00:04:A8",
                                 "HMR63303": "FF:FF:11:00:04:A3",
                                 "HMR63304": "FF:FF:11:00:04:9D",
                                 "HMR63305": "FF:FF:11:00:04:B1",
                                 "HMR63306": "FF:FF:11:00:04:CE",
                                 "HMR63307": "FF:FF:11:00:04:E7",
                                 "HMR63308": "FF:FF:11:00:04:A7",
                                 "HMR63309": "FF:FF:11:00:04:BB",
                                 "HMR63310": "FF:FF:11:00:04:DA",
                                 "HMR63311": "FF:FF:11:00:04:9A",
                                 "HMR63312": "FF:FF:11:00:04:A6",
                                 "HMR63313": "FF:FF:11:00:04:CC",
                                 "HMR63314": "FF:FF:11:00:04:DB",
                                 "HMR63315": "FF:FF:11:00:04:B4",
                                 "HMR63316": "FF:FF:11:00:04:3D",
                                 "HMR63317": "FF:FF:11:00:04:93",
                                 "HMR63318": "FF:FF:11:00:04:D0",
                                 "HMR63319": "FF:FF:11:00:04:A5",
                                 "HMR63320": "FF:FF:11:00:04:C1",
                                 "HMR63321": "FF:FF:11:00:04:99",
                                 "HMR63322": "FF:FF:11:00:04:A2",
                                 "HMR63323": "FF:FF:11:00:04:BC",
                                 "HMR63324": "FF:FF:11:00:04:D1",
                                 "HMR63325": "FF:FF:11:00:04:56",
                                 "HMR63326": "FF:FF:11:00:04:D3",
                                 "HMR63327": "FF:FF:11:00:04:39",
                                 "HMR63328": "FF:FF:11:00:04:9C",
                                 "HMR63329": "FF:FF:11:00:04:AA",
                                 "HMR63330": "FF:FF:11:00:04:53",
                                 "HMR63331": "FF:FF:11:00:04:9B",
                                 "HMR63332": "FF:FF:11:00:04:D6",
                                 "HMR63333": "FF:FF:11:00:04:C9",
                                 "HMR63334": "FF:FF:11:00:04:DD",
                                 "HMR63335": "FF:FF:11:00:04:A9",
                                 "HMR63336": "FF:FF:11:00:04:9F",
                                 "HMR63337": "FF:FF:11:00:04:55",
                                 "HMR63338": "FF:FF:11:00:04:9E",
                                 "HMR63339": "FF:FF:11:00:04:E8",
                                 "HMR63340": "FF:FF:11:00:04:B7",
                                 "HMR63341": "FF:FF:11:00:04:E5",
                                 "HMR63342": "FF:FF:11:00:04:E6",
                                 "HMR63343": "FF:FF:11:00:04:D9",
                                 "HMR63344": "FF:FF:11:00:04:D2",
                                 "HMR63345": "FF:FF:11:00:04:EF",
                                 "HMR63346": "FF:FF:11:00:04:B9",
                                 "HMR63347": "FF:FF:11:00:04:A1",
                                 "HMR63348": "FF:FF:11:00:04:DF",
                                 "HMR63349": "FF:FF:11:00:04:E2",
                                 "HMR63350": "FF:FF:11:00:04:E9",
                                 "HMR63351": "FF:FF:11:00:04:54",
                                 "HMR63352": "FF:FF:11:00:04:CF",
                                 "HMR63353": "FF:FF:11:00:04:3B",
                                 "HMR63354": "FF:FF:11:00:04:BD",
                                 "HMR63355": "FF:FF:11:00:04:AF",
                                 "HMR63356": "FF:FF:11:00:04:D4",
                                 "HMR63357": "FF:FF:11:00:04:C8",
                                 "HMR63358": "FF:FF:11:00:04:ED",
                                 "HMR63359": "FF:FF:11:00:04:B5",
                                 "HMR63360": "FF:FF:11:00:04:52",
                                 "HMR63361": "FF:FF:11:00:04:A4",
                                 "HMR63362": "FF:FF:11:00:04:C6",
                                 "HMR63363": "FF:FF:11:00:04:D8",
                                 "HMR63364": "FF:FF:11:00:04:CA",
                                 "HMR63365": "FF:FF:11:00:04:3A",
                                 "HMR63366": "FF:FF:11:00:04:BE",
                                 "HMR63367": "FF:FF:11:00:04:AB",
                                 "HMR63368": "FF:FF:11:00:04:C4",
                                 "HMR63369": "FF:FF:11:00:04:95",
                                 "HMR63370": "FF:FF:11:00:04:B3",
                                 "HMR63371": "FF:FF:11:00:04:F0",
                                 "HMR63372": "FF:FF:11:00:04:96",
                                 "HMR63373": "FF:FF:11:00:04:94",
                                 "HMR63374": "FF:FF:11:00:04:A0",
                                 "HMR63375": "FF:FF:11:00:04:AD",
                                 "HMR63376": "FF:FF:11:00:04:C3",
                                 "HMR63377": "FF:FF:11:00:04:92",
                                 "HMR63378": "FF:FF:11:00:04:BA",
                                 "HMR63379": "FF:FF:11:00:04:98",
                                 "HMR63380": "FF:FF:11:00:04:EB",
                                 "80:EA:CA:00:0A:23": "80:EA:CA:00:0A:23",
                                 "80:EA:CA:00:0A:2A": "80:EA:CA:00:0A:2A"]
        
        //"HMR63374": "FF:FF:11:00:04:A0",
        let kUserDefault = UserDefaults.standard
        
        kUserDefault.set(addressDictionary, forKey: "vin")
        dict = kUserDefault.object(forKey: "vin") as! Dictionary<String,String>
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print(k)
        //  print(dict[k]!)
        kUserDefault.synchronize()
        
        componentArray = Array(dict.keys)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if k != "" {
            scanQRTF.text =  k
        }
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        ReturnCycle.text = pickerData[row]
        self.view.endEditing(true)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return false
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == ReturnCycle {
            return true
        }
        return true
    }
    

    @IBAction func Home(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitbtn(_ sender: Any) {
        if k != "" {
            if dict[k] != nil
            {
                if ReturnCycle.text != "Tap Here To Report Issue"
                {
                print("@@@@@@@@@@@@")
                    self.json()
                }
                else
                {
                    let alert = UIAlertController(title: "Tap On Issue", message:"Please report Your Issue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                print("Please Enter Valid Lock Number")
                
                //
                
                let alert = UIAlertController(title: "SmartCykul", message:"enter valid lock number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
                
            }
            
        }
        else
        {
            print("Enter Lock Num")
            
            let alert = UIAlertController(title: "SmartCykul", message:"Please report your issue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.json()
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return pickerData[row]
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        //.hidden = true;
    }

    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/reportAnIssue.php")
            
            let body: String = "lockName=\(k)&issue=\(ReturnCycle.text!)&addInfo=nothing Serious&customerID=\(CMId)&mobileNumber=\(mbID)&address=\(addressToServer)&lattitude=\(latToServer)&longitude=\(lonToServer)"
            
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
                            //let cycleValue = json["cykulpay"]
                           // let s:String = String(format:"%f", (cycleValue as AnyObject).doubleValue) //formats the string to accept double/float
                            print("+++++++++++++++++++++++++++")
                           // print(s)
                            print("yesResponse : ++++>>  ",json)
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let alert = UIAlertController(title: "Success", message:"Your Issue Is Reported", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                            print("@@@@@@@@@@@@@@@@@@@********************&&&&&&&&&&&&&&&&&&")
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
                                            self.navigationController?.present(vc, animated: true, completion: nil)

                                           // self.navigationController?.pushViewController(vc, animated: true)
                                        }))
                                        self.present(alert, animated: true, completion: nil)
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
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textview.text == "placeholder text here...")
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textview.text == "")
        {
            textView.text = "placeholder text here..."
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}



extension ReportIssueViewController : CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if addressVariable == 0 {
            
            
            if let location = locations.first {
                //print(location.coordinate)
                print(location.coordinate.longitude)
                print(location.coordinate.latitude)
                let newLat = location.coordinate.latitude
                let newLon = location.coordinate.longitude
                
                latToServer = String(newLat)
                lonToServer = String(newLon)
                
                let cityCoords = CLLocation(latitude: newLat, longitude: newLon)
                getAdressName(coords: cityCoords)
                //  cityData(coord: cityCoords)
                
                addressVariable += 1
            }}
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getAdressName(coords: CLLocation) {
        
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                
                print("Hay un error")
                
            } else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    let place = placemark![0]
                    
                    var adressString : String = ""
                    
                    if place.thoroughfare != nil {
                        adressString = adressString + place.thoroughfare! + ", "
                    }
                    if place.subThoroughfare != nil {
                        adressString = adressString + place.subThoroughfare! + "\n"
                    }
                    if place.locality != nil {
                        adressString = adressString + place.locality! + " - "
                    }
                    if place.postalCode != nil {
                        adressString = adressString + place.postalCode! + "\n"
                    }
                    if place.subAdministrativeArea != nil {
                        adressString = adressString + place.subAdministrativeArea! + " - "
                    }
                    if place.country != nil {
                        adressString = adressString + place.country!
                    }
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                    print(placemark?.first?.locality)
                    
                    //print(adressString)
                    
                    self.addressToServer = adressString
                    // self.lblPlace.text = adressString
                }
                
            }
        }
    }
    
    
    
}
