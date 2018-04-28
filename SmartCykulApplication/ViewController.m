//
//  ViewController.m
//  BluetoothDemo
//
//  Created by apple on 2017/10/31.
//  Copyright © 2017年 jane. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define Notify_UUID @"0783B03E-8535-B5A0-7140-A304D2495CB8" //Notify
#define WRITE_UUID @"0783B03E-8535-B5A0-7140-A304D2495CBA" //Write

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

/*
 * 中心管理器
 */
@property (retain,nonatomic) CBCentralManager *centralManger;

/*
 * 当前设备通知协议
 */
@property (retain,nonatomic) CBCharacteristic *notifyCharacteristic;

/*
 * 当前设备写入协议
 */
@property (retain,nonatomic) CBCharacteristic *writeCharacteristic;
/*
 * 外设管理器
 */
@property (retain,nonatomic) CBPeripheralManager *peripheralManager;
/*
 * 外设数组
 */
@property (retain,nonatomic) NSMutableArray *peripheralArr;

/*
 * 当前连接设备
 */
@property (retain,nonatomic) CBPeripheral *currentPeripheral;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self scanForPeripheralsWithServices];
    NSLog(@"objective c");
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 * 搜索设备
 */
- (void) scanForPeripheralsWithServices
{

    _peripheralArr = [[NSMutableArray alloc] init];

    if(!self.centralManger){
        self.centralManger = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }else{
        [self stop];
        if ([self.centralManger state] == CBCentralManagerStatePoweredOn) {
            [self.centralManger scanForPeripheralsWithServices:nil options:nil];
        }
    }
}

/**
 * 连接设备
 */
- (void) connectPeripheral:(CBPeripheral *) peripheral{
    
    peripheral.delegate = self;
    [self.centralManger stopScan];
    [self.centralManger connectPeripheral:peripheral options:nil];
}

/**
 *  断开连接
 */
- (void)stop
{
    [self.centralManger stopScan];
    for (CBPeripheral *per in _peripheralArr) {
        [self.centralManger cancelPeripheralConnection:per];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil options:nil];
        if(_currentPeripheral != nil && _currentPeripheral.state == CBPeripheralStateDisconnected){
            [self connectPeripheral:_currentPeripheral];
        }
    }
}

/**
 *  发现外部设备，每发现一个就会调用这个方法
 *  所以可以使用一个数组来存储每次扫描完成的数组
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if(![_peripheralArr containsObject:peripheral] && peripheral.name != nil){
        [_peripheralArr addObject:peripheral];
        NSLog(@"new device:%@,%@",peripheral.identifier.UUIDString,advertisementData);
        
        NSData *data =  advertisementData[@"kCBAdvDataManufacturerData"];// <010280ea ca000116 06640120 81> - 80:EA:CA:00:01:16
        if (data && data.length >= 6) {
            long num= 6;// data.length && mac固定长度，6位
            unsigned char *recData = malloc(num);
            if (data.length == 6){
                [data getBytes:recData length:data.length];
                
            }
            NSMutableString *mac = [NSMutableString string];
            
            for (int i = 0; i < num; i++)
            {
                if (i != num-1) {
                    [mac appendString:[NSString stringWithFormat:@"%02x:",recData[i]]];
                }
                else
                {
                    [mac appendString:[NSString stringWithFormat:@"%02x",recData[i]]];
                }
            }
            NSLog(@"-------->[mac uppercaseString]:%@",[mac uppercaseString]);
                if( [[mac uppercaseString] isEqualToString:@"10:10:00:00:04:78"]){
                    _currentPeripheral = peripheral;
                    [self connectPeripheral:peripheral];
                }
                
                if (recData) {
                    free(recData);
                }
            }else{
                [self.centralManger cancelPeripheralConnection:peripheral];
            }
        }
        
}

/**
 *  连接外设成功调用
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManger stopScan];
    [peripheral discoverServices:nil];
}

/**
 外设连接断开
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"didDisconnectPeripheral:%@",error);
}

/**
 连接外设失败
 */
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didFailToConnectPeripheral:%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  发现服务就会调用代理方法
 *
 *  @param peripheral 外设
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = peripheral.services;
    for (CBService *ses in services) {
        [peripheral discoverCharacteristics:nil forService:ses];
    }
}

/**
 *  发现服务对应的特征
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSArray *ctcs = service.characteristics;
    BOOL foundService = NO;
    for (CBCharacteristic *character in ctcs) {
        NSLog(@"uuid:%@\n - value:%@\n",character.UUID.UUIDString,character.value);
        
        if ([character.UUID.UUIDString isEqualToString:@"0783B03E-8535-B5A0-7140-A304D2495CB8"]) {
            
            _notifyCharacteristic = character;
            [_currentPeripheral readValueForCharacteristic:character];
            [_currentPeripheral setNotifyValue:YES forCharacteristic:character];
        }else if ([character.UUID.UUIDString isEqualToString:@"0783B03E-8535-B5A0-7140-A304D2495CBA"])
        {
            _writeCharacteristic = character;
            [_currentPeripheral readValueForCharacteristic:character];
        }
        
    }
    
    if(_notifyCharacteristic && _writeCharacteristic){
        foundService = YES;
    }
    
    if(foundService){
        
        [self postUnlockBikeDeviceKey];
    }
}

/**
 * 中心读取外设实时数据
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"Notifity = %d,error:%@",characteristic.isNotifying,error);
    
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
    }
}

/**
 * 获取外设发来的数据,读到数据时进入
 * [peripheral readValueForCharacteristic:characteristic](获取的charateristic的值)
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"recive data:%@",characteristic);
    if (!error&&characteristic.isNotifying) {
        NSData * data = characteristic.value;
        Byte *resultByte = (Byte *)[data bytes];
        int start = 0;
        int end = 0;
        for(int i=0;i<[data length];i++){
            if ((resultByte[i]&0xff)==0xfe) {
                start = i;
                Byte randomNum = resultByte[i+1]-0x32;
                Byte len = (resultByte[i+4]&0xff)^randomNum;
                end = len + 7;
                break;
            }
        }
        if (end==0) return;
        
        Byte needResult[end];
        for (int j = 0; j < end; j++) {
            needResult[j] = resultByte[start++];
        }
        if ([characteristic.UUID.UUIDString isEqual:@"0783B03E-8535-B5A0-7140-A304D2495CB8"]&&end>=8) {
            Byte randomNum = needResult[1]-0x32;
            Byte b_key = needResult[2]^randomNum;
            Byte cmd = needResult[3]^randomNum;
            Byte len = needResult[4]^randomNum;
            NSLog(@"b_key:%hhu - cmd:%hhu - len:%hhu",b_key,cmd,len);
        }
    }
}

/**
 * 搜索到Characteristic的Descriptors
 */
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    for (CBDescriptor * descriptor in characteristic.descriptors) {
        NSLog(@"descriptor: %@",descriptor);
        [peripheral readValueForDescriptor:descriptor];
    }
}

/**
 * 写数据
 */
- (void) writeData:(NSData *) charData{
    if(_currentPeripheral == nil){
        NSLog(@"no device connected");
        return;
    }else if(self.writeCharacteristic == nil){
        NSLog(@"current device can't write");
        return;
    }
    NSLog(@"_writeCharacteristic : %@ *********charData:%@\n",self.writeCharacteristic,charData);
    if (_currentPeripheral.state == CBPeripheralStateConnected) {
        if (self.writeCharacteristic.properties == 6) {
            [_currentPeripheral writeValue:charData forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

/**
 * 连接成功后发送获取开锁key指令
 * KEY:0x00 0xFE+randomNum+用户ID(4字节)+0x00+0x11+0x00+CRC(高低位) - STX+NUM+ID+KEY+CMD+LEN+CRC
 */
- (void) postUnlockBikeDeviceKey
{
    Byte b_key = 0x00;
    Byte cmd = 0x11;
    Byte len = 0x08;
    char *s = "yOTmK50z";
    NSData *senderData = [[NSData alloc]initWithData:[self getCommunicationKeyWithData:s bleKey:b_key CMD:cmd LEN:len]];
    [self writeData:senderData];
}

/**

 */
- (NSMutableData *)getCommunicationKeyWithData:(char *)s bleKey:(Byte)b_key CMD:(Byte)cmd LEN:(Byte)len{
    Byte randomNum = [self getRandomNumber:1 to:255];
    Byte r_num = randomNum + 0x32;
    Byte num = r_num & 0xff;
    Byte byte[13] = {0xfe,num,b_key,cmd,len,0x79,0x4F,0x54,0x6D,0x4B,0x35,0x30,0x7A};//yOTmK50z
    for (int i = 2; i < sizeof(byte)/sizeof(byte[0]); i++) {
        byte[i] = randomNum^byte[i];
    }
    NSMutableData *byteData = [[NSMutableData alloc]initWithBytes:byte length:sizeof(byte)/sizeof(byte[0])];
    int crc = calcCRC(byte, 0, 13, 0xffff);//CRC16
    Byte crcByte[] = {(crc >> 8)&0xff ,crc & 0xff};
    NSData *crcData = [[NSData alloc]initWithBytes:crcByte length:sizeof(crcByte)/sizeof(crcByte[0])];
    [byteData appendData:crcData];
    return byteData;
}

/**
 * 获取随机整数 范围在[from,to），包括from，包括to
 */
- (Byte)getRandomNumber:(Byte)from to:(Byte)to{
    
    return (Byte)(from + (arc4random() % (to - from + 1)));
    
}

/**
 * CRC16校验
 */
static int calcCRC(Byte data[],int offset,int len,int preval){
    int ucCRCHi =(preval & 0xff00)>>8;
    int ucCRCLo = preval& 0x00FF;
    int iIndex;
    for(int i=0;i<len;i++){
        iIndex = (ucCRCLo^data[offset+i]) &0x00FF;
        ucCRCLo = ucCRCHi^t_crc16_h[iIndex];
        ucCRCHi = t_crc16_l[iIndex];
    }
    return (( (ucCRCHi&0x00FF) <<8) | ( ucCRCLo&0x00FF) )& 0xFFFF;
}


static const unsigned short t_crc16_h[] =
{//H
    0x00,   0xC1,   0x81, 0x40, 0x01,   0xC0,   0x80, 0x41, 0x01,   0xC0,
		  0x80, 0x41, 0x00,   0xC1,   0x81, 0x40, 0x01,   0xC0,   0x80, 0x41,
    0x00,   0xC1,   0x81, 0x40, 0x00,   0xC1,   0x81, 0x40, 0x01,   0xC0,
		  0x80, 0x41, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,  0x81, 0x40,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,
    0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,  0x80, 0x41,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,
    0x81, 0x40, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x00,  0xC1,  0x81, 0x40,
    0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,
    0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,  0x81, 0x40,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x00,  0xC1,  0x81, 0x40,
    0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,
    0x80, 0x41, 0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,  0x81, 0x40,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41,
    0x00,  0xC1,  0x81, 0x40, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41,
    0x01,  0xC0,  0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40, 0x00,  0xC1,  0x81, 0x40,
    0x01,  0xC0,  0x80, 0x41, 0x01,   0xC0,   0x80, 0x41, 0x00,   0xC1,
    0x81, 0x40, 0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41,
    0x00,  0xC1,  0x81, 0x40, 0x01,  0xC0,  0x80, 0x41, 0x01,  0xC0,
    0x80, 0x41, 0x00,  0xC1,  0x81, 0x40
};

static const unsigned short t_crc16_l[] =
{//L
    0x00,   0xC0,   0xC1, 0x01,   0xC3, 0x03, 0x02,   0xC2,   0xC6, 0x06,
    0x07,   0xC7, 0x05,   0xC5,   0xC4, 0x04,   0xCC, 0x0C, 0x0D,   0xCD,
    0x0F,   0xCF,   0xCE, 0x0E, 0x0A,   0xCA,   0xCB, 0x0B,   0xC9, 0x09,
    0x08,   0xC8,   0xD8, 0x18, 0x19,   0xD9, 0x1B,   0xDB,   0xDA, 0x1A,
    0x1E,   0xDE,   0xDF, 0x1F,   0xDD, 0x1D, 0x1C,   0xDC, 0x14,   0xD4,
		  0xD5, 0x15,   0xD7, 0x17, 0x16,   0xD6,   0xD2, 0x12, 0x13,   0xD3,
    0x11,   0xD1,   0xD0, 0x10,   0xF0, 0x30, 0x31,   0xF1, 0x33,   0xF3,
		  0xF2, 0x32, 0x36,   0xF6,   0xF7, 0x37,   0xF5, 0x35, 0x34,   0xF4,
    0x3C,   0xFC,   0xFD, 0x3D,   0xFF, 0x3F, 0x3E,   0xFE,   0xFA, 0x3A,
    0x3B,   0xFB, 0x39,   0xF9,   0xF8, 0x38, 0x28,   0xE8,   0xE9, 0x29,
		  0xEB, 0x2B, 0x2A,   0xEA,   0xEE, 0x2E, 0x2F,   0xEF, 0x2D,   0xED,
		  0xEC, 0x2C,   0xE4, 0x24, 0x25,   0xE5, 0x27,   0xE7,   0xE6, 0x26,
    0x22,   0xE2,   0xE3, 0x23,   0xE1, 0x21, 0x20,   0xE0,   0xA0, 0x60,
    0x61,   0xA1, 0x63,   0xA3,   0xA2, 0x62, 0x66,   0xA6,   0xA7, 0x67,
		  0xA5, 0x65, 0x64,   0xA4, 0x6C,   0xAC,   0xAD, 0x6D,   0xAF, 0x6F,
    0x6E,   0xAE,   0xAA, 0x6A, 0x6B,   0xAB, 0x69,   0xA9,   0xA8, 0x68,
    0x78,   0xB8,   0xB9, 0x79,   0xBB, 0x7B, 0x7A,   0xBA,   0xBE, 0x7E,
    0x7F,   0xBF, 0x7D,   0xBD,   0xBC, 0x7C,   0xB4, 0x74, 0x75,   0xB5,
    0x77,   0xB7,   0xB6, 0x76, 0x72,   0xB2,   0xB3, 0x73,   0xB1, 0x71,
    0x70,   0xB0, 0x50,   0x90,   0x91, 0x51,   0x93, 0x53, 0x52,   0x92,
		  0x96, 0x56, 0x57,   0x97, 0x55,   0x95,   0x94, 0x54,   0x9C, 0x5C,
    0x5D,   0x9D, 0x5F,   0x9F,   0x9E, 0x5E, 0x5A,   0x9A,   0x9B, 0x5B,
		  0x99, 0x59, 0x58,   0x98,   0x88, 0x48, 0x49,   0x89, 0x4B,   0x8B,
		  0x8A, 0x4A, 0x4E,   0x8E,   0x8F, 0x4F,   0x8D, 0x4D, 0x4C,   0x8C,
    0x44,   0x84,   0x85, 0x45,   0x87, 0x47, 0x46,   0x86,   0x82, 0x42,
    0x43,   0x83, 0x41,   0x81,   0x80, 0x40
};


- (IBAction)BluetoothCore:(id)sender
{
    
    NSLog(@"unlock cmd");
    
}
@end
