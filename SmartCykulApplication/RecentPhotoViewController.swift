//
//  RecentPhotoViewController.swift
//  SmartCykul
//
//  Created by CYKUL on 31/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage


class RecentPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate
{
    @IBOutlet var libraryImage: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    var mobileNumber,customerID,stationName,myphoto:String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        submitBtn.isHidden = true
        
        let defaults = UserDefaults.standard
        mobileNumber = defaults.string(forKey: "MobileNumber")
        customerID = defaults.string(forKey: "CustomerID")
        stationName = defaults.string(forKey: "StationName")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapChoosePhotoBtn(_ sender: Any)
    {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Click a Image", "Choose from Gallery", "Cancel")
        
        actionSheet.show(in: view)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        var buttonTitle: String? = actionSheet.buttonTitle(at: buttonIndex)
        
        (buttonTitle == "")
        if (buttonTitle == "Choose from Gallery")
        {
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            imagepicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagepicker.cameraCaptureMode = .photo
            imagepicker.modalPresentationStyle = .fullScreen
            self.present(imagepicker, animated: true, completion: nil)
        }
        if (buttonTitle == "Click a Image")
        {
            
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            //imagepicker.cameraCaptureMode = .photo
            imagepicker.sourceType = UIImagePickerControllerSourceType.camera
            imagepicker.cameraCaptureMode = .photo
            imagepicker.modalPresentationStyle = .fullScreen
            self.present(imagepicker, animated: true, completion: nil)
            if !UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                var myAlertView = UIAlertView(title: "Error", message: "Device has no camera.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
                myAlertView.show()
            }
            
        }
        else
        {
            
        }
        
    }
    
    @IBAction func onTapSubmitBtn(_ sender: Any)
    {
        self.json()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            libraryImage.contentMode = .scaleToFill
            libraryImage.image = pickedImage
            
             submitBtn.isHidden = false
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message:"No photo available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action:
                UIAlertAction) -> Void in
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
            print("error")
        }
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
   // func json()
//    {
//        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
//        {
//            SVProgressHUD.show(withStatus: "Loading...")
//        let url = URL(string:"https://www.cykul.com/smartCykul/upload.php")
//        let body: String = "customerID=\(customerID)&imageOperation=\(libraryImage.image!)"
//        let request = NSMutableURLRequest(url:url!)
//        request.httpMethod = "POST"
//        request.httpBody = body.data(using: String.Encoding.utf8)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let session = URLSession(configuration:URLSessionConfiguration.default)
//
//        let datatask = session.dataTask(with: request as URLRequest, completionHandler:
//        {
//            (data,response,error)-> Void in
//            if (error != nil)
//            {
//                print(error!)
//            }
//            else
//            {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse!)
//                if let data = data
//                {
//                    do
//                    {
//                        let myjson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//                        print(myjson)
//                    }
//                    catch
//                    {
//                        print(error)
//                    }
//                    SVProgressHUD.dismiss()
//                }
//            }
//
//        })
//        datatask.resume()
//    }
//        else
//        {
//            let alert = UIAlertController(title: "Attention", message:"Please check your network connection", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            }))
//            self.present(alert, animated: true, completion: nil)
//            print("There is no internet connection")
//        }
//    }
    
    func json()
    {
        
            if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
            {
                
                SVProgressHUD.show(withStatus: "Loading...")
                let parameters = ["customerID":CMId,
                                  "imageOperation":"myphoto"]
                
                guard let mediaImage = Media(withImage: libraryImage.image!, forKey: "image") else { return }
                
                guard let url = URL(string: "https://www.cykul.com/smartCykul/upload.php") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let boundary = generateBoundary()
                
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                //        request.addValue("Client-ID f65203f7020dddc", forHTTPHeaderField: "Authorization")
                
                let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
                request.httpBody = dataBody
                
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let response = response {
                        print(response)
                    }
                    
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                            
                            print("_________________________________")
                            print(json)
                            SVProgressHUD.dismiss()
                            //print(json["response"]);
                        } catch {
                            
                            print("$$$$$$$$$$$$$$$*******************")
                            // print(error)
                            
                        }
                    }
                    }.resume()
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
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
        
    }
    
    
}

extension Data{
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

