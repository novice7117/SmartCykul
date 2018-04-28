//
//  GovernmentViewController.swift
//  SmartCykulApplication
//
//  Created by CYKUL on 17/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage


typealias Parameters = [String: String]

@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)

class GovernmentViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate
{
    var mobileNumber,customerID,stationName,paths,Aadhar:String!
    var screen_width:UIScreen!
    @IBOutlet var govermentimage: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    var pickedImageData:NSData!
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
     var myImageName = ""

    @IBAction func govermentIDImage(_ sender: Any)
    {

        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Click a Image", "Choose from Gallery", "Cancel")

        actionSheet.show(in: view)

    }

    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        var buttonTitle: String? = actionSheet.buttonTitle(at: buttonIndex)
        if (buttonTitle == "Choose from Gallery")
        {
            let imagepicker = UIImagePickerController()
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            imagepicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagepicker.cameraCaptureMode = .photo
            imagepicker.modalPresentationStyle = .fullScreen
            self.present(imagepicker, animated: true, completion: nil)

            if let image = UIImage(named: "example.png")
            {
                if let data = UIImageJPEGRepresentation(image, 0.8) {
                    let filename = getDocumentsDirectory()
                    try? data.write(to: filename)
                }

                print("File saved")

            }
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

            print("image saved")
       // json()
        uploadPhoto()
        
        }

    override func viewDidLoad()
    {

        super.viewDidLoad()
        submitBtn.isHidden = true

        let defaults = UserDefaults.standard
        mobileNumber = defaults.string(forKey: "MobileNumber")
        customerID = defaults.string(forKey: "CustomerID")
        stationName = defaults.string(forKey: "StationName")



        images = []

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = (documentDirectorPath).appending("/ImagePicker")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }

    func refreshTable(){
        do{
            images.removeAll()
            titles = try FileManager.default.contentsOfDirectory(atPath: imagesDirectoryPath)
            for image in titles{
                let data = FileManager.default.contents(atPath: imagesDirectoryPath.appending("/\(image)"))
                let image = UIImage(data: data!)
                images.append(image!)
            }
            //self.tableView.reloadData()
        }catch{
            print("Error")
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var imagePath = NSDate().description
        imagePath = imagePath.replacingOccurrences(of: "", with: "")
        // stringByReplacingOccurrencesOfString(" ", withString: "")
        imagePath = imagesDirectoryPath.appending("\\(imagePath).png")
        //stringByAppendingString("/\(imagePath).png")
        do{
            images.removeAll()
            titles = try FileManager.default.contentsOfDirectory(atPath: imagesDirectoryPath)
            for image in titles{
                let data = FileManager.default.contents(atPath: imagesDirectoryPath.appending("/\(image)"))
                let image = UIImage(data: data!)
                images.append(image!)

                let data1 = UIImagePNGRepresentation(image! )
                let success = FileManager.default.createFile(atPath: imagePath, contents: data1, attributes: nil)
            }
            //self.tableView.reloadData()
        }
        catch
        {
            print("Error")
        }


        dismiss(animated: true)
        {
            () -> Void in
            self.refreshTable()
        }
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            govermentimage.contentMode = .scaleToFill
            govermentimage.image = pickedImage

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
        
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (assetPath.absoluteString?.hasSuffix("JPG"))! {
            print("JPG")
        }
        else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
            print("PNG")
        }
        else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
            print("GIF")
        }
        else {
            print("Unknown")
        }
        
        guard let fileUrl = info[UIImagePickerControllerImageURL] as? URL else { return }
        print("{}{{{{{{{{{{{{{{{{}{}{}{}{}{}{}{}{}")
        print(fileUrl.lastPathComponent)
        print("{}{{{{{{{{{{{{{{{{}{}{}{}{}{}{}{}{}")
        myImageName = fileUrl.lastPathComponent
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Image Upload Code
    
//    func json()
//    {
//        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
//        {
//           // SVProgressHUD.show(withStatus: "Loading...")
//
//            guard let mediaImage = Media(withImage: govermentimage.image!, forKey: "image") else { return }
//
//            guard let url = URL(string: "https://www.cykul.com/smartCykul/upload.php") else { return }
//            let parameters = ["customerID":"30003",
//                              "imageOperation":"aadhar"]
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            let boundary = generateBoundary()
//
//            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//            print("getrequest==>\(String(describing: url))")
//            let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
//            request.httpBody = dataBody
//
//            let session = URLSession.shared
//            session.dataTask(with: request) { (data, response, error) in
//                if let response = response {
//                    print(response)
//                }
//          //  request.httpBody = body.data(using: String.Encoding.utf8)
//            let session = URLSession(configuration:URLSessionConfiguration.default)
//
//            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//                if (error != nil)
//                {
//                    print(error!)
//                }
//                else {
//                    let httpResponse = response as? HTTPURLResponse
//                    print(httpResponse!)
//                    if let data = data
//                    {
//                        do {
//                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
//                             let currentStatus = json["result"] as! String
//                            print("_________________________________")
//                            print(json)
//                            DispatchQueue.main.async()
//                                {
//                                    SVProgressHUD.dismiss()
//                                    if currentStatus == "true"
//                                    {
//                                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SWRevealViewController") as! SWRevealViewController
//                                        self.navigationController?.present(vc, animated: true, completion: nil)
//                                    }
//                                    else
//                                    {
//                                        let alert = UIAlertController(title: "Attention", message:"Invalid Credentials", preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                                        }))
//                                        self.present(alert, animated: true, completion: nil)
//
//                                        print("current",currentStatus)
//                                    }
//
//                                    // self.tableView.reloadData()
//                                     SVProgressHUD.dismiss()
//
//
//                            }
//                        }
//                        catch
//                        {
//                            print(error)
//
//                        }
//                    }
//
//                }
//            })
//            dataTask.resume()
//            }
//        }
//        else
//{
//            let alert = UIAlertController(title: "Attention", message:"Please check your network connection", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            }))
//            self.present(alert, animated: true, completion: nil)
//            print("There is no internet connection")
//        }
//        }
    
    func uploadPhoto()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
        
            SVProgressHUD.show(withStatus: "Loading...")
        let parameters = ["customerID":CMId,
                          "imageOperation":"aadhar"]
        
        guard let mediaImage = Media(withImage: govermentimage.image!, forKey: "image") else { return }
        
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

extension Data {
    mutating func goverment(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}






