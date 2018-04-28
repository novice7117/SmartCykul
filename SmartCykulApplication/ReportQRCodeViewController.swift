//
//  ReportQRCodeViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 18/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import AVFoundation

class ReportQRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate
{

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
        
        view.layer.masksToBounds = true
        
        
        
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
                
                k = message
                print(k)
                
                avCaptureSession.stopRunning()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportIssueViewController") as! ReportIssueViewController
                    // self.navigationController?.pushViewController(vc, animated: true)
                    // self.navigationController?.popToViewController(vc, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                   // self.navigationController.push
                    
                })
                
                
                
                //                let alert = UIAlertController.init(title: "QR Code", message: message, preferredStyle: .alert)
                
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
                
                //               alert.addAction(UIAlertAction.init(title: "Finish", style: .cancel, handler:{ (nil) in
                //
                //
                //
                //                    //                    self.avCaptureSession.startRunning()
                //                    //
                //                    //
                //                    //                    let storyboard: UIStoryboard = UIStoryboard(name: "ViewController", bundle: nil)
                //                    //                    let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "myVCID") as UIViewController
                //                    //                    self.present(vc, animated: true, completion: nil)
                //                }
                //
                //
                //
                //
                //                ))
                
                
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
                
                
                
                //   present(alert, animated: true, completion: nil)
                
                
                
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
        
        
        
        avCaptureSession.startRunning()
        
    }
    
    
    
    
}
