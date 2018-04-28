//
//  BluetoothQRViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 18/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
// BluetoothQRViewController

import UIKit
import AVFoundation

var dic = [String : String]()
var kk = ""


class BluetoothQRViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
  
    
    var avCaptureInput: AVCaptureDeviceInput!
    
    var avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var isScanDone: Bool = false
    
    var message = String()
    
    let avCaptureSession = AVCaptureSession.init()
    
    let avCaptureMetadataOutput = AVCaptureMetadataOutput.init()
    
    
    
    enum error: Error {
        
        case noCameraAvailable
        
        case videoInitFailed
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
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
        dic = kUserDefault.object(forKey: "vin") as! Dictionary<String,String>
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        kUserDefault.synchronize()
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        // makeORView(view: textView)
        
        avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: avCaptureSession)
        
        
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        
        
        self.avCaptureSession.stopRunning()
        
        if self.avCaptureSession.inputs.isEmpty {
            
            print("No need of Inputs removal")
            
        }else {
            
            self.avCaptureSession.removeInput(avCaptureInput)
            
            self.avCaptureSession.removeOutput(avCaptureMetadataOutput)
            
        }
        
        
        
    }
    
    
    
    func makeORView(view: UITextView) {
        
        //   view.layer.borderWidth = 2.5
        
        //   view.layer.borderColor = primaryColor?.cgColor
        
        view.layer.cornerRadius = view.frame.width/2
        
        view.layer.masksToBounds = true
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        avCaptureSession.removeOutput(avCaptureMetadataOutput)
        
        
        
        isScanDone = false
        
        do {
            
            
            
            try scanQRCode()
            
            
            
        } catch {
            
            
            
            print("Catch Err")
            
        }
        
        configureScanView(view: view, isScanDone: isScanDone)
        
        
        
        //   walletIDTF.inputView = UIView.init(frame: CGRect.zero)
        
    }
    
    
    
    func configureScanView(view: UIView, isScanDone: Bool) {
        
        
        
        // view.layer.borderWidth = 3.5
        
        view.layer.borderColor = isScanDone ? UIColor.green.cgColor : UIColor.yellow.cgColor
        
        view.layer.masksToBounds = false
        
        
        
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        isScanDone = false
        
        configureScanView(view: view, isScanDone: isScanDone)
        
        if metadataObjects.count > 0 {
            
            
            
            let machineReadableCode = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            
            
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                
                isScanDone = true
                
                configureScanView(view: view, isScanDone: isScanDone)
                
                message = machineReadableCode.stringValue!
                
                kk = message
                //    print(k)
                //
                avCaptureSession.stopRunning()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnlockViewController") as! UnlockViewController
                    
                    self.present(vc, animated: false, completion: nil)
                    
                })
                
                
                
                //    let alert = UIAlertController.init(title: "QR Code", message: message, preferredStyle: .alert)
                
                //                alert.addAction(UIAlertAction.init(title: "Retake", style: .default, handler:{ (nil) in
                //
                //
                //
                //                    self.avCaptureSession.startRunning()
                //
                //
                //
                //                }
                //
                //
                //
                //
                //                ))
                
                //    alert.addAction(UIAlertAction.init(title: "Finish", style: .cancel, handler:{ (nil) in
                //
                //
                //
                //    //                    self.avCaptureSession.startRunning()
                //    //
                //    //
                //    //                    let storyboard: UIStoryboard = UIStoryboard(name: "ViewController", bundle: nil)
                //    //                    let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "myVCID") as UIViewController
                //    //                    self.present(vc, animated: true, completion: nil)
                //    }
                //
                //
                //
                //
                //    ))
                
                
                //                alert.addAction(UIAlertAction.init(title: "Copy", style: .default, handler: { (nil) in
                //
                //
                //
                //                    UIPasteboard.general.string = self.message
                //
                //                    self.avCaptureSession.stopRunning()
                //
                //
                //
                //                }))
                
                
                
                //    present(alert, animated: true, completion: nil)
                
                
                
            } else {
                
                isScanDone = false
                
                configureScanView(view: view, isScanDone: isScanDone)
                
            }
            
        }
        
        
        
    }
    
    
    
    func alertPromptToAllowCameraAccessViaSettings() {
        
        
        
        let camAlert = UIAlertController.init(title: "Access to Device Camera", message: "Please enable the camera in device settings, for scanning purpose", preferredStyle: .alert)
        
        
        
        let settingsAction = UIAlertAction.init(title: "Settings", style: .default) { (settingsAction) in
            
            
            
            DispatchQueue.main.async {
                
                if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                    
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    
                }
                
            }
            
            
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (cancelAction) in
            
            
            
            return
            
        }
        
        camAlert.addAction(cancelAction)
        
        camAlert.addAction(settingsAction)
        
        present(camAlert, animated: true, completion: nil)
        
    }
    
    
    
    func scanQRCode() throws {
        
        
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            
            
            
            print("No Cam")
            
            throw error.noCameraAvailable
            
            
            
        }
        
        
        
        do {
            
            avCaptureInput = try AVCaptureDeviceInput.init(device: avCaptureDevice)
            
        }catch {
            
            
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            
            
            if status == AVAuthorizationStatus.authorized {
                
                // authorized
                
                print("Authorized")
                
                
                
            } else if status == AVAuthorizationStatus.denied {
                
                // denied
                
                print("Denied")
                
                
                
            } else if status == AVAuthorizationStatus.restricted {
                
                // restricted
                
                print("Restricted")
                
                
                
            } else if status == AVAuthorizationStatus.notDetermined {
                
                // not determined
                
                print("Not Determined")
                
                
                
            }
            
            
            
            var isGranted = false
            
            
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                
                
                
                if granted {
                    
                    isGranted = true
                    
                    print("Yahooooo")
                    
                }else {
                    
                    print("Not yet Known Granted")
                    
                    isGranted = false
                    
                    self.alertPromptToAllowCameraAccessViaSettings()
                    
                    
                    
                }
                
                
                
            })
            
            if !isGranted {
                
                return
                
            }
            
        }
        
        
        
        avCaptureMetadataOutput.setMetadataObjectsDelegate((self as AVCaptureMetadataOutputObjectsDelegate), queue: DispatchQueue.main)
        
        
        
        //        if let inputs = self.avCaptureSession.inputs as? [AVCaptureDeviceInput] {
        
        //            for input in inputs {
        
        //                self.avCaptureSession.removeInput(input)
        
        //            }
        
        //        }
        
        
        
        if avCaptureSession.inputs.isEmpty {
            
            avCaptureSession.addInput(avCaptureInput)
            
        }
        
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        
        avCaptureVideoPreviewLayer.frame = view.bounds
        
        
        
        self.view.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        // self.scanView.addSubview(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
        
    }
    
    
    
    
    
}


