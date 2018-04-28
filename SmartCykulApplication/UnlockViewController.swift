//
//  UnlockViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 18/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit
import CoreBluetooth
import SVProgressHUD
import SDWebImage
import CoreLocation

class UnlockViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var lockPeripheral: CBPeripheral!
    let lockNamee = "OmniBleLock"
    var foundService: Bool!
    var result1,result2:UInt8!
    var result = [UInt8] ()
    var mobileNumber,stationName,customerID,lockName,address,latitude,longitude,batteryLevel: String!
    var latToServer : String = ""
    var lonToServer : String = ""
    var addressToServer : String = ""
    var myNumber = 0
    var stationNamee = "CYKUL"
    var addressVariable = 0
    var addresToServer : String = ""
    var unlock:String!
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var myActionBTN: UIButton!
    var notifycharacteristic,readCharacteristic,writeCharacteristic:CBCharacteristic!
    var keyCommand = Data(bytes: [ 0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, 0x00, 0x11, 0x08, 0x33, 0x68, 0x75, 0x42, 0x68, 0x39, 0x4c, 0x31,0x1f, 0x37] as [UInt8], count: 19)
    let serviceUUID = CBUUID(string:"0783B03E-8535-B5A0-7140-A304D2495CB7")
    let readUUID = CBUUID(string:"0783b03e-8535-b5a0-7140-a304d2495cb8")
    let writeUUID = CBUUID(string:"0783b03e-8535-b5a0-7140-a304d2495cba")
    
    
    func checkLockStatus(responseFound : [UInt8])  {
        print("LOCK STATUS PRINTED")
        
        //  var keyCommand = Data(bytes: [ 0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, 0x00, 0x11, 0x08, 0x33, 0x68, 0x75, 0x42, 0x68, 0x39, 0x4c, 0x31,0x1f, 0x37] as [UInt8], count: 19)
        
        
        var unlockCommand = Data(bytes: [0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, secretKey(response:responseFound), 0x31, 0x00] as [UInt8], count: 9)
        //let data = NSData(bytes: &unlockCommand, length: unlockCommand )
        
        var x =  [UInt8](unlockCommand)
        calcCRC(data: x, offset: 0, len: 9, preval: 0xFFFF)
        unlockCommand.append(result1)
        unlockCommand.append(result2)
        //let newUnlockCode : [UInt8] = [unlockCommand[0], unlockCommand[1], unlockCommand[2], unlockCommand[3], unlockCommand[4], unlockCommand[5], unlockCommand[6], unlockCommand[7], unlockCommand[8], unlockCommand[9], unlockCommand[10]]
        
        let newunlockCommand = Data([0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, secretKey(response:responseFound), 0x31, 0x00, unlockCommand[9], unlockCommand[10]])
        
        //let byte1Data = Data(bytes: newUnlockCode)
        //        print(unlockCommand)
        //        print(unlockCommand[0])
        //        print(unlockCommand[1])
        //        print(unlockCommand[2])
        //        print(unlockCommand[3])
        //        print(unlockCommand[4])
        //        print(unlockCommand[5])
        //        print(unlockCommand[6])
        //        print(unlockCommand[7])
        //        print(unlockCommand[8])
        //        print(unlockCommand[9])
        //        print(unlockCommand[10])
        
        lockPeripheral.writeValue(newunlockCommand, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        myActionBTN.titleLabel?.text = "UNLOCK"
        myActionBTN.setTitle(myBtnText, for: .normal)
        myActionBTN.layer.cornerRadius = myActionBTN.frame.width/2
    }
    
    
    @IBAction func Backbtn(_ sender: Any) {
      
    }
    
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch central.state
        {
        case .poweredOn:
            print("Bluetooth is on")
            centralManager.scanForPeripherals(withServices: nil)
        case .poweredOff:
            print("Bluetooth is off")
        default:
            break
        }
    }
    func connect(_ peripheral: CBPeripheral?) {
        
        peripheral?.delegate = self
        
        centralManager.stopScan()
        
        if let aPeripheral = peripheral {
            
            print("peripheral connect")
            
            centralManager.connect(aPeripheral, options: nil)
            
            
            
        }
        
    }
    
    @IBAction func returnBtn(_ sender: UIButton) {
        
        if myActionBTN.titleLabel?.text == "RETURN"
        {
            myNumber = 1
            checkLockStatus(responseFound: result)
            
        }
        if myActionBTN.titleLabel?.text == "UNLOCK" {
            myNumber = 1
            createUnlockCommand(responseFound: result)
            
        }
        
        
        
        // createUnlockCommand(responseFound: result)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        centralManager = CBCentralManager (delegate: self, queue: nil)
        
        if CLLocationManager.locationServicesEnabled() {
            
            print("delegate called")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        
        print("Name: \(peripheral.name)") //print the names of all peripherals connected.
        
        
        
        if peripheral.name == "OmniBleLock" { //if is it my peripheral, then connect
            
            print("identifier: \(peripheral.identifier)")
            print("uuid: \(peripheral.identifier.uuid)")
            print("UUID: \(peripheral.identifier.uuidString)")
            print("new device:%@,%@",advertisementData)
            
            
            
            self.lockPeripheral = peripheral     //save peripheral
            self.lockPeripheral.delegate = self
            
            
            var data: Data? = (advertisementData["kCBAdvDataManufacturerData"] as! Data)
            
            if (data != nil) && data!.count >= 8
            {
                var num: Int = 8
                // data.length && mac固定长度，6位
                var recData = malloc(num)
                if data?.count == 8
                {
                    //  data?.getBytes(recData, length: (data?.length)!)
                }
                var mac = ""
                for i in num-1..<num {
                    if i != num - 1 {
                        mac += String(format: "%02x:", data![i])
                    } else {
                        mac += String(format: "%02x", data![i])
                    }
                }
                
                //dict[k]!
                let subString = dic[kk]!.dropLast(2)
                
                let finalMac=subString+mac
                print("mac is printed  ******************** \(mac)")
                print("-------->[mac uppercaseString]:\(finalMac.uppercased())")
                if (finalMac.uppercased() == dic[kk]!) {
                    lockPeripheral = peripheral
                    print("connect method called")
                    connect(peripheral)
                    centralManager.connect(lockPeripheral, options: nil)
                    centralManager.stopScan()
                }
                //                if recData != nil {
                //                    let k = data as! UnsafeMutableRawPointer
                //                    free(k)
            }
        }
        
        
        //stop scanning for peripherals
        //connect to my peripheral
        
        //  }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Lock got connected")
        lockPeripheral.discoverServices([serviceUUID])
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("did discover services called")
        //
        guard let services = lockPeripheral.services else {
            return
        }
        print("Printing Services")
        for service in services
        {
            
            print(service)
            if(service.uuid==serviceUUID)
            {
                lockPeripheral.discoverCharacteristics(nil, for: service)
            }else{
                print("Other Service")
            }
            
            
        }
        
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        print("did discover characteristics called")
        
        
        if let characterArray = service.characteristics as [CBCharacteristic]!
        {
            
            
            for character in characterArray {
                print("charcaterstictics called")
                print(character.uuid.uuidString)
                if (character.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CB8")
                {
                    print("Read characteristic")
                    notifycharacteristic = character
                    lockPeripheral.readValue(for: character)
                    lockPeripheral.setNotifyValue(true, for: character)
                } else if (character.uuid.uuidString == "0783B03E-8535-B5A0-7140-A304D2495CBA")
                {
                    print("Write characteristic")
                    writeCharacteristic = character
                    
                    lockPeripheral.setNotifyValue(true, for: character)
                    
                    lockPeripheral.readValue(for: character)
                    
                }
                
            }
            if (notifycharacteristic != nil) && (writeCharacteristic != nil) {
                foundService = true
                print("0x11 cmd send to lock")
                print(keyCommand)
                lockPeripheral.writeValue(keyCommand, for: writeCharacteristic, type:CBCharacteristicWriteType.withResponse)
            }
            if (foundService != nil) {
                // postUnlockBikeDeviceKey()
                
                
                
            }
        }
    }
    
    func  secretKey(response : [UInt8])->UInt8
    {
        print("array to seceret key")
        print(response)
        var a : UInt8
        if response[1] < 50
        {
            
            a = (response[1] + (205)) as UInt8
            
        }
        else
        {
            a = (response[1] - (50)) as UInt8
        }
        let key = (response[6] ^ a)
        
        print("Secret Key")
        print(key)
        //        AC7B2FAC-F2B4-AA65-125D-11B55BF56CA8   ----->04AE
        //        0783B03E-8535-B5A0-7140-A304D2495CB7   -----> UUID for every lock device
        return key
    }
    
    
    @IBAction func unlock(_ sender: Any)
    {
        
        createUnlockCommand(responseFound: result)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IssueSucessfullyViewController") as! IssueSucessfullyViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdate method is called")
        if(error==nil)
        {
            var fetchedResponse = characteristic.value
            let responseFound = [UInt8](fetchedResponse!)
            
            result = responseFound
            print("Response Found from lock")
            print( result )
           if myNumber == 1
            {
                myNumber = 0
                print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
                print("++++++++++++ LOCK STATUS RESULT +++++++++++++++")
                var k : UInt8
                var l : UInt8
                if result[1] < 50{
                    l = (result[10] ^ (result[1] + 205))
                    
                    k = (result[9] ^ (result[1] + 205))
                }
                else
                {
                    l = (result[10] ^ (result[1] - 50))
                    k = (result[9] ^ (result[1] - 50))
                }
                print("***********Battery level ****************")
                print(l)
                print(k)
            }
            
            
            
            
        }
        
        
    }
    func createUnlockCommand(responseFound : [UInt8])
    {
        //self.json()
        var unlockCommand = Data(bytes: [0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, secretKey(response:responseFound), 0x21, 0x00] as [UInt8], count: 9)
        //let data = NSData(bytes: &unlockCommand, length: unlockCommand )
        
        var x =  [UInt8](unlockCommand)
        calcCRC(data: x, offset: 0, len: 9, preval: 0xFFFF)
        unlockCommand.append(result1)
        unlockCommand.append(result2)
        //let newUnlockCode : [UInt8] = [unlockCommand[0], unlockCommand[1], unlockCommand[2], unlockCommand[3], unlockCommand[4], unlockCommand[5], unlockCommand[6], unlockCommand[7], unlockCommand[8], unlockCommand[9], unlockCommand[10]]
        
        let newunlockCommand = Data([0xFE, 0x32, 0x49, 0x95, 0xFF, 0x6D, secretKey(response:responseFound), 0x21, 0x00, unlockCommand[9], unlockCommand[10]])
        
        //let byte1Data = Data(bytes: newUnlockCode)
        print(unlockCommand)
        print(unlockCommand[0])
        print(unlockCommand[1])
        print(unlockCommand[2])
        print(unlockCommand[3])
        print(unlockCommand[4])
        print(unlockCommand[5])
        print(unlockCommand[6])
        print(unlockCommand[7])
        print(unlockCommand[8])
        print(unlockCommand[9])
        print(unlockCommand[10])
        
        lockPeripheral.writeValue(newunlockCommand, for: writeCharacteristic, type: CBCharacteristicWriteType.withResponse)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            
            self.centralManager.cancelPeripheralConnection(self.lockPeripheral)
        })
        
       // let vc = self.storyboard?.instantiateViewController(withIdentifier:"IssueSucessfullyViewController") as! IssueSucessfullyViewController
      //  self.navigationController?.present(vc, animated: true, completion: nil)
        //lockPeripheral.readValue(for: writeCharacteristic)
        //centralManager.cancelPeripheralConnection(lockPeripheral)
        
    }
    
    
    private func calcCRC(data: [UInt8], offset: Int, len: Int, preval: Int) -> Int {
        var ucCRCHi: Int = (preval & 0xff00) >> 8
        var ucCRCLo: Int = preval & 0x00ff
        var iIndex: Int
        for i in 0..<len {
            iIndex = Int((UInt8(ucCRCLo) ^ data[offset + i]) & 0x00ff)
            ucCRCLo = ucCRCHi ^ t_crc16_h[iIndex]
            ucCRCHi = t_crc16_l[iIndex]
        }
        print("!!!!!!!!!!!!!! CalcCrc Method Called !!!!!!!!!!!!")
        
        //        let n = ((ucCRCHi & 0x00ff) << 8) | (ucCRCLo & 0x00ff) & 0xffff
        //        var st = String(format:"%2X", n)
        //        st += " is the hexadecimal representation of \(n)"
        //        print(st)
        let d3 = ((ucCRCHi & 0x00ff) << 8) | (ucCRCLo & 0x00ff) & 0xffff
        let h1 = String(d3, radix: 16)
        print("###########################")
        print(h1)
        
        let x = (String(h1.prefix(2)) )
        print("________________________________")
        print(x)
        let y = (String(h1.suffix(2)) )
        print("________________________________")
        print(y)
        
        result1 = UInt8(strtoul(x,nil,16))
        result2 = UInt8(strtoul(y,nil,16))
        
        
        print(((ucCRCHi & 0x00ff) << 8) | (ucCRCLo & 0x00ff) & 0xffff)
        return ((ucCRCHi & 0x00ff) << 8) | (ucCRCLo & 0x00ff) & 0xffff
    }
    private let t_crc16_h = [    //H
        0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40, 0x01, 0xc0, 0x80, 0x41, 0x01, 0xc0, 0x80, 0x41, 0x00, 0xc1, 0x81, 0x40]
    private let t_crc16_l = [    //L
        0x00, 0xc0, 0xc1, 0x01, 0xc3, 0x03, 0x02, 0xc2, 0xc6, 0x06, 0x07, 0xc7, 0x05, 0xc5, 0xc4, 0x04, 0xcc, 0x0c, 0x0d, 0xcd, 0x0f, 0xcf, 0xce, 0x0e, 0x0a, 0xca, 0xcb, 0x0b, 0xc9, 0x09, 0x08, 0xc8, 0xd8, 0x18, 0x19, 0xd9, 0x1b, 0xdb, 0xda, 0x1a, 0x1e, 0xde, 0xdf, 0x1f, 0xdd, 0x1d, 0x1c, 0xdc, 0x14, 0xd4, 0xd5, 0x15, 0xd7, 0x17, 0x16, 0xd6, 0xd2, 0x12, 0x13, 0xd3, 0x11, 0xd1, 0xd0, 0x10, 0xf0, 0x30, 0x31, 0xf1, 0x33, 0xf3, 0xf2, 0x32, 0x36, 0xf6, 0xf7, 0x37, 0xf5, 0x35, 0x34, 0xf4, 0x3c, 0xfc, 0xfd, 0x3d, 0xff, 0x3f, 0x3e, 0xfe, 0xfa, 0x3a, 0x3b, 0xfb, 0x39, 0xf9, 0xf8, 0x38, 0x28, 0xe8, 0xe9, 0x29, 0xeb, 0x2b, 0x2a, 0xea, 0xee, 0x2e, 0x2f, 0xef, 0x2d, 0xed, 0xec, 0x2c, 0xe4, 0x24, 0x25, 0xe5, 0x27, 0xe7, 0xe6, 0x26, 0x22, 0xe2, 0xe3, 0x23, 0xe1, 0x21, 0x20, 0xe0, 0xa0, 0x60, 0x61, 0xa1, 0x63, 0xa3, 0xa2, 0x62, 0x66, 0xa6, 0xa7, 0x67, 0xa5, 0x65, 0x64, 0xa4, 0x6c, 0xac, 0xad, 0x6d, 0xaf, 0x6f, 0x6e, 0xae, 0xaa, 0x6a, 0x6b, 0xab, 0x69, 0xa9, 0xa8, 0x68, 0x78, 0xb8, 0xb9, 0x79, 0xbb, 0x7b, 0x7a, 0xba, 0xbe, 0x7e, 0x7f, 0xbf, 0x7d, 0xbd, 0xbc, 0x7c, 0xb4, 0x74, 0x75, 0xb5, 0x77, 0xb7, 0xb6, 0x76, 0x72, 0xb2, 0xb3, 0x73, 0xb1, 0x71, 0x70, 0xb0, 0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9c, 0x5c, 0x5d, 0x9d, 0x5f, 0x9f, 0x9e, 0x5e, 0x5a, 0x9a, 0x9b, 0x5b, 0x99, 0x59, 0x58, 0x98, 0x88, 0x48, 0x49, 0x89, 0x4b, 0x8b, 0x8a, 0x4a, 0x4e, 0x8e, 0x8f, 0x4f, 0x8d, 0x4d, 0x4c, 0x8c, 0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40]
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if  lockPeripheral != nil{
            centralManager.cancelPeripheralConnection(lockPeripheral)
        }
        
        
    }
    
    func json()
    {
        if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
        {
            SVProgressHUD.show(withStatus: "Loading...")
            let url = URL(string:"https://www.cykul.com/smartCykul/riderOperation.php")
            print("getrequest==>\(String(describing: url))")
            
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            let body: String = "mobileNumber=\(mbID)&stationName=\(stationNamee)&customerID=\(CMId)&latitude=\(latToServer)&longitude=\(lonToServer)&address=\(addressToServer)&lockName=\(kk)&batteryLevel=\(batteryLevel)&operation=\(unlock)"
          //  print("login==>==\(mobilenumberTF.text!)&\(passwordTF.text!)")
            let request = NSMutableURLRequest(url:url!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: String.Encoding.utf8)
            let session = URLSession(configuration:URLSessionConfiguration.default)
            
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
                            print(json)
                            print("yesResponse : ++++>>  ", json)
                            
                            
                            let currentStatus = json["result"] as! String
                           // let message = json["message"] as! String
                            DispatchQueue.main.async()
                                {
                                    SVProgressHUD.dismiss()
                                    if currentStatus == "true"
                                    {
                                        // self.performSegue(withIdentifier: "Login", sender: nil)
                                        
//                                        CMId = json["customerID"] as! String
//                                        let currentMobileNumber = json["mobileNumber"] as! String
//                                        let currentStationName = json["station_name"] as! String
//
//                                        let defaults = UserDefaults.standard
//                                        //  defaults.set(currentCustomerID, forKey: "Customer_ID")
//                                        // defaults.set(currentMobileNumber, forKey: "Mobile_Number")
//                                        defaults.set(currentStationName, forKey: "StationName")
//                                        defaults.synchronize()
                                        
                                        
                                        
                                       
                                    }
                                    else
                                    {
                                        let alert = UIAlertController(title: "Attention", message:"", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        print("current",currentStatus)
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


extension UnlockViewController : CLLocationManagerDelegate
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
