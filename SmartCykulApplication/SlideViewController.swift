//
//  SlideViewController.swift
//  SmartCykulApplication
//
//  Created by Surendra on 02/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import SVProgressHUD
import CoreBluetooth
import CoreLocation
var myBtnText = ""

class SlideViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var messagelbl: UILabel!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var mapView: GMSMapView!
    
    var customerID,FFFF110004B4,HMR63324,stationName: String!
//    var mapview = GMSMapView()
    var  locationManager = CLLocationManager()

    var myLocations: [CLLocation] = []
    
    var latUser : CLLocationDegrees!
    var longUser : CLLocationDegrees!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messagelbl.isHidden = true
        print("^^^^^^^^^^^^^^^^")
        print(verCount)
        if verCount == 1
        {
            verCount = 0
            verficationLabelText = "Documents Already Verfied"
            
            messagelbl.isHidden = false
            messagelbl.text = verficationLabelText
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.messagelbl.isHidden = true
            })
            
            
        }
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //userdefaults()
        
        if (revealViewController() != nil)
        
        {
            
            barButton.target = revealViewController()
            
            barButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
           
        }
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.distanceFilter = 1
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
//        self.mapview = GMSMapView(frame:CGRect.init(x: 0, y: 0, width: 500, height: 630))
//        self.view.addSubview(mapview)
//
        self.mapView.delegate = self
        

       
        
        json1()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocations.append(locations[0] as CLLocation)
//        print(myLocations)
        
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //        print(myLocations)
        
        
        
        //***** Zoom UserLocation*****
        
        latUser = locValue.latitude
        
        longUser = locValue.longitude
        
        let userLocation = GMSCameraPosition.camera(withLatitude: latUser, longitude: longUser,zoom: 13)
        
        mapView.camera = userLocation
//        GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:latitude
//            longitude:longitude
//            zoom:11.0];
//
//        [self.mapView animateToCameraPosition:cameraPosition];
        
        
    }
   
    @IBAction func unlockbtn(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Bluetooth") as! BluetoothQRViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
//        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
//        {
//            SVProgressHUD.show(withStatus: "Loading...")
//            stationName = "CYKUL"
//            // let stationName:String!
//            let url = URL(string:"https://www.cykul.com/smartCykul/newEligibilityCondition.php")
//            let body: String = "customerID=\(CMId)&mobileNumber=\(mbID)&stationName=\(stationName)"
//            //print("feedback==>==\(customerID!)&\(!)&\(stationName!)")
//            let request = NSMutableURLRequest(url:url!)
//            request.httpMethod = "POST"
//            request.httpBody = body.data(using: String.Encoding.utf8)
//            let session = URLSession(configuration:URLSessionConfiguration.default)
//
//            let datatask = session.dataTask(with: request as URLRequest, completionHandler:
//            {
//                (data,response,error)-> Void in
//                if (error != nil)
//                {
//                    print(error!)
//                }
//                else
//                {
//                    let httpResponse = response as? HTTPURLResponse
//                    print(httpResponse!)
//                    if let data = data
//                    {
//                        do {
//                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
//                            print("yesResponse : ++++>>  ", json)
//
//                            let currentResultStatus = json["result"] as! String
//                            let message = json["message"] as! String
//
//
//                            //let currentReportStatus = json["report_status"] as! String
//
//                            DispatchQueue.main.async()
//                                {
//                                    SVProgressHUD.dismiss()
//                                    if message == "Valid Subscriber"
//                                    {
//                                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "Bluetooth") as! BluetoothQRViewController
//                                        self.navigationController?.pushViewController(vc, animated: true)
//                                    }
//                                    else
//                                    {
//                                        let alert = UIAlertController(title: "Attention", message:message, preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(_ action: UIAlertAction) -> Void in
//
//                                            switch action.style{
//                                            case .default:
//                                                print("default")
//
//                                            case .cancel:
//                                                print("cancel")
//
//                                            case .destructive:
//                                                print("destructive")
//
//
//                                            }
//                                        }))
//                                        self.present(alert, animated: true, completion: nil)
//                                    }
//
//                                    // self.tableView.reloadData()
//                                    // SVProgressHUD.dismiss()
//
//
//                            }
//                        }
//
//
//                        catch
//                        {
//                            print(error)
//                        }
//                    }
//                }
//
//            })
//            datatask.resume()
//        }
//
//        else
//        {
//            let alert = UIAlertController(title: "Attention", message:"Please check your network connection", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            }))
//            self.present(alert, animated: true, completion: nil)
//            print("There is no internet connection")
//        }
//
//
        
        
        
        
         myBtnText = "UNLOCK"
        
        
        
        }
    

    @IBAction func `return`(_ sender: Any)
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            stationName = "CYKUL"
            // let stationName:String!
            let url = URL(string:"https://www.cykul.com/smartCykul/checkForReturn.php")
            let body: String = "customerID=\(CMId)&mobileNumber=\(mbID)&stationName=\(stationName)"
            //print("feedback==>==\(customerID!)&\(!)&\(stationName!)")
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
                            let message = json["message"] as! String
                            //let currentReportStatus = json["report_status"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentResultStatus == "true"
                                    {
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"Bluetooth") as! BluetoothQRViewController
                                        self.navigationController?.present(vc, animated: true, completion: nil)
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Attention", message:message, preferredStyle: .alert)
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

        
//        self.enableLocationManager()
//        self.disableLocationManager()
        
       // let alertController = UIAlertController(title: "Bluetooth", message: "please enable bluetooth and location", preferredStyle: .alert)
        
        // Create OK button
       // let OKAction = UIAlertAction(title: "YES", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
           // self.openBluetooth()
           // self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            self.locationManager.requestAlwaysAuthorization()
//            self.enableLocationManager()
//            self.disableLocationManager()
        
           // print("Yes button tapped")
            
             myBtnText = "RETURN"
            
      //  }
      //  alertController.addAction(OKAction)
        
        // Create Cancel button
       // let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
          //  print("NO button tapped");
      //  }
       // alertController.addAction(cancelAction)
        
        // Present Dialog message
      //  self.present(alertController, animated: true, completion:nil)
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QrcodeViewController") as! QrCodeViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func openBluetooth()
    {
        let url = URL(string: "App-Prefs:root=Bluetooth") //for bluetooth setting
        let app = UIApplication.shared
        app.openURL(url!)
    }
    
    func enableLocationManager() {
        
        locationManager.startUpdatingLocation()
        print("enable location")
    }
    
    func disableLocationManager() {
        
        locationManager.stopUpdatingLocation()
        print("disable location")
    }
    
    func json1()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/fetchStationMarker.php")
            print("getrequest==>\(String(describing: url))")
            let body: String = "customerID=\(customerID)"
            
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            let marker = GMSMarker()
            var longitudes:[AnyObject]!
            var latitudes:[AnyObject]!
            var title : [AnyObject]!
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil)
                {
                    print(error!)
                }
                else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!)
                    if let data = data
                    {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                            print("yesResponse : ++++>>  ", json)
                            latitudes = json["latitude"] as! [AnyObject]
                            longitudes = json["longitude"] as! [AnyObject]
                            title = json["stationName"] as! [AnyObject]
                            
                            let currentStatus = json["result"] as! String
                            
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    
                                    for (index, element) in title.enumerated()
                                    {
                                        print("Item \(index): \(element)")
                                        DispatchQueue.main.async {
                                            
                                            let coordinates = CLLocationCoordinate2D(latitude: latitudes[index].doubleValue, longitude:longitudes[index].doubleValue)
                                            let marker = GMSMarker(position: coordinates)
                                            marker.map = self.mapView
//                                            let camera = GMSCameraPosition.camera(withLatitude: latitudes[index].doubleValue!, longitude:longitudes[index].doubleValue!, zoom:10)
//                                            self.mapView.animate(to: camera)
                                            // self.mapview.animate(toZoom: 12.0)
                                            marker.snippet = "\(element)"
                                            marker.title = "\(element)"
                                        }
                                    }
                                    
                            }
                            
                            
                        }
                        catch
                        {
                            print(error)
                            
                        }
                    }
                    
                }
            })
            dataTask.resume()
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
}
