//
//  XLSwitchPackFrame.m
//  XLDistributionBoxApp
//
//  Created by admin on 13-11-25.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//




//智能开关app通信规约组帧
#import "XLSwitchPackFrame.h"
#import "XLSocketManager.h"


#define START 0x68  //帧开头
#define END 0x16   //帧结尾

#define OBJECT_ADDRESS 0x00 //对象地址0xff



//开关规约组帧
@interface XLSwitchPackFrame(){
    
    Byte *frame;
    int length;  //数据长度
    
}
@property(nonatomic,assign) NSInteger pos;//

@end

@interface XLSwitchPackFrame()

@property (nonatomic,strong) XLSocketManager *socketManager;

@end


@implementation XLSwitchPackFrame
SYNTHESIZE_SINGLETON_FOR_CLASS(XLSwitchPackFrame)  //实现组帧单例
//组帧

-(id)init{
    if (self = [super init]) {
        self.socketManager = [XLSocketManager sharedXLSocketManager];
    }
    return self;
}



/*－－－－－－－－－－－－－－
 功能：组报文头
 参数：userDataLen：数据区长度
 返回值：
 －－－－－－－－－－－－－－*/
-(void)packHeadWithLen:(unsigned short)userDataLen {
    
    
}
/*－－－－－－－－－－－－－－
 功能：求校验和
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(unsigned short)setCheckSum:(Byte *)userData
{
    Byte *pos = userData;
    unsigned short total = 0;
    
    for ( int i =0; i<length - 9; i++)
    {
        total += *pos;
        ++pos;
    }
    
    return total;//返回校验和
    
    
}
/*－－－－－－－－－－－－－－
 功能：组报文头
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(void)packHeader{
    
    
    frame =malloc(length);
    
    //设置开始位 结束位
    
    frame[self.pos++] = START;
    *(frame+5) = START;
    *(frame+length-1)=END;
    
    
    //设置长度
    unsigned short lengthField =length - 9;
    
    //长度L1
    frame[self.pos++]=(Byte)(lengthField&0x00ff);
    frame[self.pos++]=(Byte)((lengthField & 0xff00)>>8);
    
    //长度L2
    frame[self.pos++]=*(frame+1);
    frame[self.pos++]=*(frame+2);
    
    
    //偏移加加，跳到对象地址
    self.pos++;
    
    
    
    frame[self.pos++]=OBJECT_ADDRESS;//对象地址
}



/*－－－－－－－－－－－－－－
 功能：读取双点遥信
 参数：设备名称 withTelesignalOffset 遥信偏移  withTelesignalCount：遥信个数
 返回值：获取双点遥信功能报文
 －－－－－－－－－－－－－－*/
-(void)readDoubleTelesignalWithEquipName:(unsigned int)equipName
                    withTelesignalOffset:(unsigned short)telesignalOffset
                     withTelesignalCount:(unsigned short)telesignalCount
{
    
    
    
    unsigned short type =2;//双点遥信标志
    [self readTelesignalWithEquipName:equipName withOffset:telesignalOffset withCount:telesignalCount withType:type];
    
    
}

/*－－－－－－－－－－－－－－
 功能：读取压板状态
 参数：设备名称 plateOffset 遥信偏移 plateCount：遥信个数
 返回值：获取双点遥信功能报文
 －－－－－－－－－－－－－－*/
-(NSData*)readPlateStatusWithEquipName:(unsigned int)equipName
                       withPlateOffset:(unsigned short)plateOffset
                        withPlateCount:(unsigned short)plateCount
{
    
    
    //读取压板状态
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;  //
    length =userDataLen+9;
    
    
    [self packHeader];
    
    
    frame[self.pos++] = 0xc;
    
    //功能码
    frame[self.pos++]= 0x1a;
    
    
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //压板偏移 2个字节
    frame[self.pos++]=(Byte)(plateOffset&0x00ff);
    frame[self.pos++]=(Byte)((plateOffset & 0xff00)>>8);
    //压板个数
    frame[self.pos++]=(Byte)(plateCount&0x00ff);
    frame[self.pos++]=(Byte)((plateCount&0xff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
}


/*－－－－－－－－－－－－－－
 功能：读取双点soe
 参数：
 返回值：获取双点遥信功能报文
 －－－－－－－－－－－－－－*/
-(void)readDoubleSoeWithEquipName:(unsigned int)equipName
                     withSoeCount:(unsigned short)soeCount
                      withReadPtr:(unsigned short)readPtr
                     withWritePtr:(unsigned short)writePtr
                    withBufferLen:(unsigned short)bufferLen
{
    
    //单点soe 功能码 0x12
    //双点soe  功能码 0x1d
    unsigned short type=2;
    
    [self readSoeEventWithEquipName:equipName
                       withSoecount:soeCount
                        withReadPtr:readPtr
                       withWritePtr:writePtr
                      withBufferLen:bufferLen
                           withType: type];
    
    
}
/*－－－－－－－－－－－－－－
 功能：读遥测
 参数：设备名称 telemetryOffset 遥测偏移  telemetryCount：遥测个数
 返回值：获取遥测功能报文
 －－－－－－－－－－－－－－*/
-(NSData*) readTelemeterWithEquipName:(unsigned int)equipName
                  withTelemetryOffset:(unsigned short)telemetryOffset
                            withCount:(unsigned short)telemetryCount

{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;  //
    
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++]= 0x10;
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //遥测偏移 2个字节
    frame[self.pos++]=(Byte)(telemetryOffset&0x00ff);
    frame[self.pos++]=(Byte)((telemetryOffset & 0xff00)>>8);
    //遥测数量
    frame[self.pos++]=(Byte)(telemetryCount&0x00ff);
    frame[self.pos++]=(Byte)((telemetryCount&0xff00)>>8);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：读遥测一次值／读取遥测二次值  PrimaryValueOrSecondaryValue:一次侧与二次侧
 与读遥测相比，多了个单位值描述 8个字节
 参数：设备名称 telemetryOffset 遥测偏移  telemetryCount：遥测个数
 返回值：获取遥测一次值与二次值功能报文
 －－－－－－－－－－－－－－*/
-(NSData*) readTelemeterPrimaryValueOrSecondaryValueWithEquipName:
(unsigned int)equipName
                                              withTelemeterOffset:(unsigned short)telemetryOffset
                                               withTelemeterCount:(unsigned short)telemetryCount
                                                withTelemeterType:(unsigned int)type
{
    //读取遥测一次值或二次值
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;  //
    
    length =userDataLen+9;
    
    [self packHeader];
    
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    switch(type)
    {
        case 1: //遥测一次值
            frame[self.pos++]= 0x2b;
            break;
            
        case 2://遥测二次值
            frame[self.pos++]= 0x2c;
            break;
        default:
            NSLog(@"Type参数错误");
            return nil ;
    }
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //遥测偏移 2个字节
    frame[self.pos++]=(Byte)(telemetryOffset&0x00ff);
    frame[self.pos++]=(Byte)((telemetryOffset & 0xff00)>>8);
    //遥测数量
    frame[self.pos++]=(Byte)(telemetryCount&0x00ff);
    frame[self.pos++]=(Byte)((telemetryCount&0xff00)>>8);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 功能：读遥信  （包括单点遥信与双点遥信）
 功能码：单点：0x11  双点：0x1c
 参数:telesignalOffset：遥信偏移量 telesignalCount：遥信个数
 telesignalTypeype:1 单点遥信   2：双点遥信
 返回值：获取遥测功能报文telesignalisation
 －－－－－－－－－－－－－－*/
-(NSData*)readTelesignalWithEquipName:(unsigned int)equipName
                           withOffset:(unsigned short)telesignalOffset withCount: (unsigned short) telesignalCount
                             withType:(unsigned short)telesignalType
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;  //
    length =userDataLen+9;
    
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    switch (telesignalType) {
        case 1:
            frame[self.pos++]= 0x11;
            break;
            
        case 2:
            //双点遥信
            frame[self.pos++]= 0x1c;
            break;
        default:
            //默认，单点遥信
            frame[self.pos++]= 0x11;
            break;
    }
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //遥信偏移 2个字节
    frame[self.pos++]=(Byte)(telesignalOffset&0x00ff);
    frame[self.pos++]=(Byte)((telesignalOffset & 0xff00)>>8);
    //遥信数量
    frame[self.pos++]=(Byte)(telesignalCount&0x00ff);
    frame[self.pos++]=(Byte)((telesignalCount&0xff00)>>8);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 功能：读soe事件  区分单点soe与双点soe
 参数：soeCount:soe事件个数 readPtr：读指针 writePtr：写指针 bufferLen：缓冲区长度
 soeType：1 单点soe   2 双点soe 其它：默认单点
 返回值：读soe事件组帧报文
 －－－－－－－－－－－－－－*/
-(NSData*)readSoeEventWithEquipName:(unsigned int)equipName
                       withSoecount:(unsigned short)soeCount
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen
                           withType:(unsigned short)soeType
{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6;  //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    
    //功能码
    switch (soeType) {
        case 1:
            //单点soe
            frame[self.pos++]= 0x12;
            
            break;
        case 2:
            //双点soe
            frame[self.pos++]= 0x1d;
            break;
        default:
            frame[self.pos++]= 0x12;
            break;
    }
    
    
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //soe个数 2个字节
    frame[self.pos++]=(Byte)(soeCount&0x00ff);
    frame[self.pos++]=(Byte)((soeCount & 0xff00)>>8);
    //读指针
    frame[self.pos++]=(Byte)(readPtr&0x00ff);
    frame[self.pos++]=(Byte)((readPtr&0xff00)>>8);
    //写指针
    frame[self.pos++]=(Byte)(writePtr&0x00ff);
    frame[self.pos++]=(Byte)((writePtr&0xff00)>>8);
    //缓冲区长度
    frame[self.pos++]=(Byte)(bufferLen&0x00ff);
    frame[self.pos++]=(Byte)((bufferLen&0xff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 功能：读取电度
 参数：energyOffset：电度偏移  energyCount：电度个数
 返回值：读取电度报文
 －－－－－－－－－－－－－－*/
-(NSData*)readEnergyWithEquipName:(unsigned int)equipName
                       withOffset:(unsigned short)energyOffset
                        withCount: (unsigned short) energyCount
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;  //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++]= 0x13;
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    
    //电度偏移 2个字节
    frame[self.pos++]=(Byte)(energyOffset&0x00ff);
    frame[self.pos++]=(Byte)((energyOffset & 0xff00)>>8);
    //电度数量
    frame[self.pos++]=(Byte)(energyCount&0x00ff);
    frame[self.pos++]=(Byte)((energyCount&0xff00)>>8);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}


/*－－－－－－－－－－－－－－
 功能：读取单点cos
 参数：读指针，写指针，个数 缓冲取长度
 返回值：获取遥测功能报文   telecontrol：遥控英文
 －－－－－－－－－－－－－－*/
-(NSData*)readCosEventWithEquipName:(unsigned int)equipName
                       withCoscount:(unsigned short)cosCount
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen
{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6;  //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++]= 0x14;
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //cos个数 2个字节
    frame[self.pos++]=(Byte)(cosCount&0x00ff);
    frame[self.pos++]=(Byte)((cosCount & 0xff00)>>8);
    //读指针
    frame[self.pos++]=(Byte)(readPtr&0x00ff);
    frame[self.pos++]=(Byte)((readPtr&0xff00)>>8);
    //写指针
    frame[self.pos++]=(Byte)(writePtr&0x00ff);
    frame[self.pos++]=(Byte)((writePtr&0xff00)>>8);
    //缓冲区长度
    frame[self.pos++]=(Byte)(bufferLen&0x00ff);
    frame[self.pos++]=(Byte)((bufferLen&0xff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 读历史遥测和历史电度
 参数dataType:1:历史遥测   2:历史电度
 －－－－－－－－－－－－－－*/
-(NSData*)readHistroryWithEquipName:(unsigned int)equipName
                           withType:(unsigned short)dataType
                          withPoint:(unsigned short)pointNumber
                      withStartTime: (unsigned int)startTime
                  withFrozenDensity:(unsigned short)frozenDensity
                          withCount:(unsigned short)Count
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+4+2+2;  //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    switch(dataType)
    {
        case 1://历史遥测
            frame[self.pos++]= 0x16;
            break;
        case 2://历史电度
            frame[self.pos++]= 0x17;
            break;
        default:  //出错
            return nil;
    }
    
    //设备名称 4个字节
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //点号 2个字节
    frame[self.pos++]=(Byte)(pointNumber&0x00ff);
    frame[self.pos++]=(Byte)((pointNumber & 0xff00)>>8);
    //起始时间  4个字节
    frame[self.pos++]=(Byte)(startTime&0x000000ff);
    frame[self.pos++]=(Byte)((startTime&0x0000ff00)>>8);
    frame[self.pos++]=(Byte)((startTime&0x00ff0000)>>16);
    frame[self.pos++]=(Byte)((startTime&0xff000000)>>24);
    
    //数据冻结密度
    frame[self.pos++]=(Byte)(frozenDensity&0x00ff);
    frame[self.pos++]=(Byte)((frozenDensity & 0xff00)>>8);
    
    //数据个数
    frame[self.pos++]=(Byte)(Count&0x00ff);
    frame[self.pos++]=(Byte)((Count & 0xff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}


/*－－－－－－－－－－－－－－
 功能：读取事件
 参数：事件个数  读指针  写指针  缓冲区长度  事件类型:0 动作事件 1 操作事件 2 告警事件
 返回值：对应报文
 －－－－－－－－－－－－－－*/
-(NSData*)readEventWithEquipName:(unsigned int)equipName
                       withCount:(unsigned short)Count
                     withReadPtr:(unsigned short)readPtr
                    withWritePtr:(unsigned short)writePtr
                   withBufferLen:(unsigned short)bufferLen
                   withEventType:(unsigned short)eventType
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6+2; //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x18;
    
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //事件个数
    frame[self.pos++]= (Byte)(Count&0x000000ff);
    frame[self.pos++]= (Byte)((Count&0x0000ff00)>>8);
    //读指针
    frame[self.pos++]= (Byte)(readPtr&0x000000ff);
    frame[self.pos++]= (Byte)((readPtr&0x0000ff00)>>8);
    //写指针
    frame[self.pos++]= (Byte)(writePtr&0x000000ff);
    frame[self.pos++]= (Byte)((writePtr&0x0000ff00)>>8);
    //缓冲区长度
    frame[self.pos++]= (Byte)(bufferLen&0x000000ff);
    frame[self.pos++]= (Byte)((bufferLen&0x0000ff00)>>8);
    //事件类型
    
    switch(eventType)
    {
        case 0:
            
        case 1:
            
        case 2://事件类型
            frame[self.pos++]= (Byte)(eventType&0x000000ff);
            frame[self.pos++]= (Byte)((eventType&0x0000ff00)>>8);
            break;
        default:
            return nil;
    }
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}

/*－－－－－－－－－－－－－－
 功能：读遥控点号描述
 参数：读指针，写指针，个数
 返回值：获取遥测功能报文   telecontrol：遥控英文
 －－－－－－－－－－－－－－*/
-(void)readTelecontrol{
    //读取遥控点号描述
    /*
     XLSwitchPackFrame* packframe =[XLSwitchPackFrame alloc];
     [packframe readPointDescribeWithEquipName:4096 withPointType:7
     withPointOffset:0
     withPointCount:50];
     */
    
}
/*－－－－－－－－－－－－－－
 功能：读点号描述
 参数：设备名称 点号类型 点号偏移   点号个数
 返回值：点号描述报文
 －－－－－－－－－－－－－－*/
-(NSData*)readPointDescribeWithEquipName:(unsigned int)equipName
                           withPointType:(Byte)pointType
                         withPointOffset:(unsigned short)pointOffset
                          withPointCount:(unsigned short)pointCount

{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+1+2+2; //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x22;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //点号类型
    switch(pointType)
    {
            
        case 1://遥测描述
        case 2://单点遥信描述
        case 3://双点遥信描述
        case 4://压板描述
        case 5://定植描述
        case 6://电度描述
        case 7://遥控描述
        case 8://回线描述
            frame[self.pos++]=pointType;  //点号类型
            break;
        default:
            return nil;
    }
    //点号偏移
    frame[self.pos++]= (Byte)(pointOffset&0x000000ff);
    frame[self.pos++]= (Byte)((pointOffset&0x0000ff00)>>8);
    //点号个数
    frame[self.pos++]= (Byte)(pointCount&0x000000ff);
    frame[self.pos++]= (Byte)((pointCount&0x0000ff00)>>8);
    
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}




/*－－－－－－－－－－－－－－
 功能：读取回线数据   通过读有效值获取回线数据
 参数：通过读有效值进行获取
 返回值：读取回线召测   LoopData：回线数据
 －－－－－－－－－－－－－－*/
-(NSData*)readLoopDataWithEquipName:(unsigned int)equipName
                          withCount:(unsigned short)count
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen

{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6; //
    length =userDataLen+9;
    
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x28;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //信息个数
    frame[self.pos++]= (Byte)(count&0x000000ff);
    frame[self.pos++]= (Byte)((count&0x0000ff00)>>8);
    //读指针
    frame[self.pos++]= (Byte)(readPtr&0x000000ff);
    frame[self.pos++]= (Byte)((readPtr&0x0000ff00)>>8);
    //写指针
    frame[self.pos++]= (Byte)(writePtr&0x000000ff);
    frame[self.pos++]= (Byte)((writePtr&0x0000ff00)>>8);
    //缓冲区长度
    frame[self.pos++]= (Byte)(bufferLen&0x000000ff);
    frame[self.pos++]= (Byte)((bufferLen&0x0000ff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}


/*－－－－－－－－－－－－－－
 功能：读取运行状态
 参数：
 返回值：读取运行状态
 －－－－－－－－－－－－－－*/
-(NSData*)readRunStatusWithEquipName:(unsigned int)equipName
                       withRunStatus:(unsigned int)runStatus
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4; //
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x2d;
    
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //运行状态
    frame[self.pos++]= (Byte)(runStatus&0x000000ff);
    frame[self.pos++]= (Byte)((runStatus&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((runStatus&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((runStatus&0xff000000)>>24);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：读取保护定值
 参数：loopNumber：回线序号
 返回值：返回保护定植数组
 －－－－－－－－－－－－－－*/
-(NSData*)readProtectedValueWithEquipName:(unsigned int)equipName
                           withLoopNumber:(unsigned short)loopNumber
                          withPointOffset:(unsigned short)pointOffset
                          withPointNumber:(unsigned short)pointCount
{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+2+2; //
    length =userDataLen+9;
    
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x27;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //回路序号
    frame[self.pos++]= (Byte)(loopNumber&0x000000ff);
    frame[self.pos++]= (Byte)((loopNumber&0x0000ff00)>>8);
    //点号偏移
    frame[self.pos++]= (Byte)(pointOffset&0x000000ff);
    frame[self.pos++]= (Byte)((pointOffset&0x0000ff00)>>8);
    //点号个数
    frame[self.pos++]= (Byte)(pointCount&0x000000ff);
    frame[self.pos++]= (Byte)((pointCount&0x0000ff00)>>8);
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}


/*－－－－－－－－－－－－－－
 功能：读取系统时钟
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readSystemClock{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3; //
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xa;
    //功能码
    frame[self.pos++] = 0x4;
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    //frame[self.pos++]=0x16;
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
    
}
/*－－－－－－－－－－－－－－
 功能：修改系统时钟
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)modifySystemClockWithYear:(unsigned short)year
                          withMonth:(Byte)month
                            withDay:(Byte)day
                           withWeek:(Byte)week
                           withHour:(Byte)hour
                         withMinute:(Byte)minute
                         withSecond:(Byte)second
                      withMilSecond:(unsigned short)milSecond
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+10; //
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x4;
    //功能码
    frame[self.pos++] = 0x5;
    
    //年
    frame[self.pos++]=(Byte)(year&0x00ff);
    frame[self.pos++]=(Byte)((year & 0xff00)>>8);
    //月
    frame[self.pos++]=month;
    //日
    frame[self.pos++]=day;
    //星期
    frame[self.pos++]=week;
    //时
    frame[self.pos++]=hour;
    //分
    frame[self.pos++]=minute;
    //秒
    frame[self.pos++]=second;
    //毫秒
    frame[self.pos++]=(Byte)(milSecond&0x00ff);
    frame[self.pos++]=(Byte)((milSecond & 0xff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
    
    
}




/*－－－－－－－－－－－－－－
 功能：读取运行信息
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readRunInformationWithEquipName:(unsigned int)equipName
                                withCount:(unsigned short)count
                              withReadPtr:(unsigned short)readPtr
                             withWritePtr:(unsigned short)writePtr
                            withBufferLen:(unsigned short)bufferLen




{
    
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6 ;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x19;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //信息个数
    frame[self.pos++]= (Byte)(count&0x000000ff);
    frame[self.pos++]= (Byte)((count&0x0000ff00)>>8);
    
    
    //读指针
    frame[self.pos++]= (Byte)(readPtr&0x000000ff);
    frame[self.pos++]= (Byte)((readPtr&0x0000ff00)>>8);
    //写指针
    frame[self.pos++]= (Byte)(writePtr&0x000000ff);
    frame[self.pos++]= (Byte)((writePtr&0x0000ff00)>>8);
    //缓冲区长度
    frame[self.pos++]= (Byte)(bufferLen&0x000000ff);
    frame[self.pos++]= (Byte)((bufferLen&0x0000ff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：读取采样信息
 参数：SamplingWaveform 采样波形
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readSamplingWaveformWithEquipName:(unsigned int)equipName
                                  withFlag1:(Byte)flag1
                                  withFlag2:(Byte)flag2
                             withLoopNumber:(unsigned short)loopNumber
                             withCurveCount:(unsigned short)curveCount

{
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+2+2 ;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x20;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //标志1
    frame[self.pos++]=flag1;
    //标志2
    frame[self.pos++]=flag2;
    //回线号／遥测号
    frame[self.pos++]= (Byte)(loopNumber&0x000000ff);
    frame[self.pos++]= (Byte)((loopNumber&0x0000ff00)>>8);
    //每个曲线的点个数
    frame[self.pos++]= (Byte)(curveCount&0x000000ff);
    frame[self.pos++]= (Byte)((curveCount&0x0000ff00)>>8);
    
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 功能：读取版本信息
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readVersionInfomationWithEquipName:(unsigned int)equipName
                                   withCount:(unsigned short)count
                                 withReadPtr:(unsigned short)readPtr
                                withWritePtr:(unsigned short)writePtr
                               withBufferLen:(unsigned short)bufferLen
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+6 ;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x23;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //信息个数
    frame[self.pos++]= (Byte)(count&0x000000ff);
    frame[self.pos++]= (Byte)((count&0x0000ff00)>>8);
    
    
    //读指针
    frame[self.pos++]= (Byte)(readPtr&0x000000ff);
    frame[self.pos++]= (Byte)((readPtr&0x0000ff00)>>8);
    //写指针
    frame[self.pos++]= (Byte)(writePtr&0x000000ff);
    frame[self.pos++]= (Byte)((writePtr&0x0000ff00)>>8);
    //缓冲区长度
    frame[self.pos++]= (Byte)(bufferLen&0x000000ff);
    frame[self.pos++]= (Byte)((bufferLen&0x0000ff00)>>8);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}



/*－－－－－－－－－－－－－－
 功能：读取装置地址
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readDevceAddressWithEquipName:(unsigned int)equipName
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4 ;//
    
    
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x24;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：读取Gprs地址
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readGprsAddressWithEquipName:(unsigned int)equipName
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4 ;//
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xc;
    //功能码
    frame[self.pos++] = 0x2a;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}


/*－－－－－－－－－－－－－－
 功能：遥控操作
 参数：操作类型  0x1:预置  0x2:执行 0x3:取消 遥控属性：0: 合闸 1:分闸
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)remoteControlWithEquipName:(unsigned int)equipName
             withRemoteControlNumber:(unsigned short)remoteControlNumber
          withRemoteControlAttribute:(unsigned short)remoteControlAttribute
               withRemoteControlType:(unsigned int)controlType
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+4;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    switch(controlType)
    {
        case 1://预置
            frame[self.pos++] = 0x20;
            break;
        case 2://执行
            frame[self.pos++] = 0x21;
            break;
        case 3://取消
            frame[self.pos++] = 0x22;
            break;
        default:
            return nil;
            
    }
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //遥控开关号
    frame[self.pos++]= (Byte)(remoteControlNumber&0x000000ff);
    frame[self.pos++]= (Byte)((remoteControlNumber&0x0000ff00)>>8);
    // 遥控属性
    switch(remoteControlAttribute)
    {
        case 0://合闸
            frame[self.pos++]=0x05;
            frame[self.pos++]=0x00;
            break;
        case 1://分闸
            frame[self.pos++]=0x06;
            frame[self.pos++]=0x00;
            break;
        default:
            return nil;
    }
    /*frame[self.pos++]= (Byte)(remoteControlNumber&0x000000ff);
     frame[self.pos++]= (Byte)((remoteControlNumber&0x0000ff00)>>8);//高位为00*/
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：故障远方复归
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)remoteInvolutionWithEquipName:(unsigned int)equipName
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x23;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：设置电池活化
 参数：flag:0 无效  1: 立即活化  2:停止活化
 返回值：
 －－－－－－－－－－－－－－*/

-(NSData*)BatteryActivationWithEquipName:(unsigned int)equipName
                      withExcitationFlag:(Byte)flag
{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+1;//
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x27;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //活化标志
    frame[self.pos++] = flag;
    
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
    
    
}
/*－－－－－－－－－－－－－－
 功能：设置远程退出
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*) remoteExitWithEquipName:(unsigned int)equipName
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4;//
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x28;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}

/*－－－－－－－－－－－－－－
 功能：地址设置命令
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)addressSetCommandWithEquipName:(unsigned int)equipName
                       withDeviceAddress:(Byte)deviceAddress
                         withNetAddress1:(unsigned int)netAddress1
                         withNetAddress2:(unsigned int)netAddress2
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+1+4+4;//
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x29;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //装置地址
    frame[self.pos++] = deviceAddress;
    //net1地址
    frame[self.pos++]= (Byte)(netAddress1&0x000000ff);
    frame[self.pos++]= (Byte)((netAddress1&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((netAddress1&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((netAddress1&0xff000000)>>24);
    //net2地址
    frame[self.pos++]= (Byte)(netAddress2&0x000000ff);
    frame[self.pos++]= (Byte)((netAddress2&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((netAddress2&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((netAddress2&0xff000000)>>24);
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}

/*－－－－－－－－－－－－－－
 功能：纪录清除
 参数：D0：事件记录
 D1：曲线记录
 D2：SOE记录
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)clearRecordWithEquipName:(unsigned int)equipName
                    withRecordType:(Byte)recordType
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+1;//
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x2b;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //纪录类型
    frame[self.pos++] = recordType;
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}

/*－－－－－－－－－－－－－－
 功能：打开或关闭无线通讯模块
 参数：开关标志定义：（1字节）
 0-无效
 1-开
 2-关
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)openOrCloseWirelessWithEquipName:(unsigned int)equipName
                            withRecordType:(Byte)recordType

{
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+1;//
    length =userDataLen+9;
    
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x2c;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //纪录类型
    frame[self.pos++] = recordType;
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    
    free(frame);
    return data;
}






/*－－－－－－－－－－－－－－
 功能：设置保护定值
 参数：equipName：设备名称  loopNumber：回线序号 pointOffset：点号偏移  pointCount：点号个数
 value：保护定值数据
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)protectedValueSetWithEquipName:(unsigned int)equipName
                          withLoopNumber:(unsigned short)loopNumber
                         withPointOffset:(unsigned short)pointOffset
                          withPointCount:(unsigned short)pointCount
                      withProtectedValue:(protectedValue[])value
{
    
    if(pointCount==0)//保护定值个数为0
    {
        return nil;
    }
    if(value==nil) //保护定值为空，返回
    {
        return nil;
        
    }
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+2+2+2+(6*pointCount);//
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x2d;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    //回路序号
    frame[self.pos++] =(Byte) (loopNumber&0x00ff);
    frame[self.pos++] = (Byte) ((loopNumber&0xff00)>>8);
    //点号偏移
    frame[self.pos++] =(Byte) (pointOffset&0x00ff);
    frame[self.pos++] = (Byte) ((pointOffset&0xff00)>>8);
    //点号个数
    frame[self.pos++] =(Byte) (pointCount&0x00ff);
    frame[self.pos++] = (Byte) ((pointCount&0xff00)>>8);
    //定值类型
    for(int i=0;i<pointCount;i++)
    {
        
        //保护定值赋值
        frame[self.pos++]=value[i].protectedValueParameterType;//定值参数类型
        frame[self.pos++]=value[i].protectedValueDataType;//定值数据类型
        //保护定值数据
        frame[self.pos++]=(Byte)(value[i].protectedValue&0x000000ff);
        frame[self.pos++]=(Byte)(value[i].protectedValue&0x0000ff00);
        frame[self.pos++]=(Byte)(value[i].protectedValue&0x00ff0000);
        frame[self.pos++]=(Byte)(value[i].protectedValue&0xff000000);
    }
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
}



/*－－－－－－－－－－－－－－
 功能：设置GPRS地址
 参数：hostIp：主ip地址  backupIp：备份ip地址
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)gprsAddressSetWithEquipName:(unsigned int)equipName
                           withHostIp:(ipAddress)hostIp
                         withBackupIp:(ipAddress)backupIp
{
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+4+6+6;//
    length =userDataLen+9;
    
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0x5;
    //功能码
    frame[self.pos++] = 0x2e;
    //设备名称
    frame[self.pos++]= (Byte)(equipName&0x000000ff);
    frame[self.pos++]= (Byte)((equipName&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((equipName&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((equipName&0xff000000)>>24);
    
    //主ip地址
    frame[self.pos++]= (Byte)(hostIp.ipAddress&0x000000ff);
    frame[self.pos++]= (Byte)((hostIp.ipAddress&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((hostIp.ipAddress&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((hostIp.ipAddress&0xff000000)>>24);
    //主ip端口
    frame[self.pos++]= (Byte)(hostIp.portNumber&0x000000ff);
    frame[self.pos++]= (Byte)((hostIp.portNumber&0x0000ff00)>>8);
    
    //备ip地址
    frame[self.pos++]= (Byte)(backupIp.ipAddress&0x000000ff);
    frame[self.pos++]= (Byte)((backupIp.ipAddress&0x0000ff00)>>8);
    frame[self.pos++]= (Byte)((backupIp.ipAddress&0x00ff0000)>>16);
    frame[self.pos++]=  (Byte)((backupIp.ipAddress&0xff000000)>>24);
    //备份ip端口
    frame[self.pos++]= (Byte)(backupIp.portNumber&0x000000ff);
    frame[self.pos++]= (Byte)((backupIp.portNumber&0x0000ff00)>>8);
    
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：读文件组帧
 参数：fileName:文件名称64个字节 readPtr：读指针  count:要读取的字节数
 endFlag:文件结束标志
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readFileWithFileName:(NSString*)fileName
                   withReadPtr:(unsigned int)readPtr
                     withCount:(unsigned short)count
                   withEndFlag:(Byte)endFlag


{
    /* NSString *str = @"AA21f0c1762a3abc299c013abe7dbcc50001DD";
     
     NSData* bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
     Byte * myByte = (Byte *)[bytes bytes];
     NSLog(@"myByte = %s",myByte);
     */
    NSData* bytes = [fileName dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+4+2+1;//
    length =userDataLen+9;
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xf;
    //功能码
    frame[self.pos++] = 0x30;
    
    //文件名称 64个字节
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<fileName.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=fileName.length;i<64;i++)
    {
        frame[self.pos++] =0;
        
    }
    
    //读指针 4个字节
    frame[self.pos++] = (Byte)(readPtr&0x000000ff);
    frame[self.pos++] = (Byte)(readPtr&0x0000ff00)>>8;
    frame[self.pos++] = (Byte)(readPtr&0x00ff0000)>>16;
    frame[self.pos++] = (Byte)(readPtr&0xff000000)>>24;
    //读取的字节数
    frame[self.pos++] = (Byte)(count&0x000000ff);
    frame[self.pos++] = (Byte)((count&0x0000ff00)>>8);
    //文件结束标志
    frame[self.pos++] = 0x00;
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
}




/*－－－－－－－－－－－－－－
 功能：读取本地文件信息，并装换成字节序列
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(void)readDataFromFileWithFileName:(NSString*)fileName
{
    
    //读本地文件信息
    //并将本地文件转换成字节序列
    
    
}
/*－－－－－－－－－－－－－－
 功能：写文件命令
 参数：fileName:文件名称 fileLen：文件长度  writePtr：写指针  bytesLen：字节长度
 endFlag：文件结束标志    fileData：文件包的数据内容
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)writeFileWithFileName:(NSString*)fileName
                    withFileLen:(unsigned int)fileLen
                   withWritePtr:(unsigned int)writePtr
                    withByteLen:(unsigned short)bytesLen
                    withEndFlag:(Byte)endFlag
                       withData:(Byte*)fileData
{
    
    
    
    
    
    NSData* bytes = [fileName dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+4+4+2+1+bytesLen;//文件数据长度
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xf;
    //功能码
    frame[self.pos++] = 0x31;
    
    //文件名称  将文件名称转换称字节序
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<fileName.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=fileName.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    //文件长度
    frame[self.pos++] = (Byte)(fileLen&0x000000ff);
    frame[self.pos++] = (Byte)((fileLen&0x0000ff00)>>8);
    frame[self.pos++] = (Byte)((fileLen&0x00ff0000)>>16);
    frame[self.pos++] = (Byte)((fileLen&0xff000000)>>24);
    //写指针
    frame[self.pos++] = (Byte)(writePtr&0x000000ff);
    frame[self.pos++] = (Byte)((writePtr&0x0000ff00)>>8);
    frame[self.pos++] = (Byte)((writePtr&0x00ff0000)>>16);
    frame[self.pos++] = (Byte)((writePtr&0xff000000)>>24);
    //本文件包的字节长度
    frame[self.pos++] = (Byte)(bytesLen&0x000000ff);
    frame[self.pos++] = (Byte)((bytesLen&0x0000ff00)>>8);
    //文件结束标志
    frame[self.pos++] = endFlag;
    //文件包的数据内容
    for(int i=0;i<bytesLen;i++)
    {
        
        frame[self.pos++] = *(fileData+i);
    }
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
}

/*－－－－－－－－－－－－－－
 功能：读目录命令
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readCatalogueWithFilePath:(NSString*)filePath
                        withReadPtr:(unsigned short)readPtr
{
    
    NSData* bytes = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+6;//文件数据长度
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xf;
    //功能码
    frame[self.pos++] = 0x32;
    
    //文件路径名称  将文件名称转换称字节序
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<filePath.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=filePath.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    //读指针
    frame[self.pos++] = (Byte)(readPtr&0x000000ff);
    frame[self.pos++] = (Byte)((readPtr&0x0000ff00)>>8);
    //预留word类型 2个字节
    frame[self.pos++]=0;
    frame[self.pos++]=0;
    
    //预留word类型 2个字节
    frame[self.pos++]=0;
    frame[self.pos++]=0;
    
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
    
}

/*－－－－－－－－－－－－－－
 功能：创建目录命令
 参数：filePath 文件路径
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)createCatalogueWithFilePath:(NSString*)filePath
{
    NSData* bytes = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+6;//文件数据长度
    length =userDataLen+9;
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xf;
    //功能码
    frame[self.pos++] = 0x33;
    
    //创建目录的完整路径名称
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<filePath.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=filePath.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
}

/*－－－－－－－－－－－－－－
 功能：文件改名组帧和目录改名组帧
 参数：srcFilePath:原文件的完整路径名称  desFilePath：修改后的完整路径名称
 modifyType 1:文件改名   2:目录改名
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)modifyFileNameWithSrcFilePath:(NSString*)srcFilePath
                        withDesFilePath:(NSString*)desFilePath
                         withModifyType:(int)modifyType
{
    //源文件路径
    NSData* bytes = [srcFilePath dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    //目的文件路径
    NSData* bytes1 = [desFilePath dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes1 = (Byte *)[bytes1 bytes];//将字符串转换成字节序
    
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+64;//文件数据长度
    length =userDataLen+9;
    
    [self packHeader];
    
    //控制码
    frame[self.pos++] = 0xf;
    //功能码
    switch(modifyType)
    {
        case 1:
            frame[self.pos++] = 0x34;
            break;
        case 2:
            frame[self.pos++] = 0x35;
            break;
        default:
            return nil;
    }
    
    //源文件路径名称
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<srcFilePath.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=srcFilePath.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    //修改后的文件名称
    if(fileNameBytes1==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<desFilePath.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes1+i);
        
    }
    for(int i=desFilePath.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
}



/*－－－－－－－－－－－－－－
 功能：目录改名组帧
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(void)modifyCatalogueName{
    
    //见文件改名组帧方法
}
/*－－－－－－－－－－－－－－
 功能：修改文件属性
 参数：filePath:文件路径  fileAttributeData:文件属性内容
 fileAttributeLen:文件属性长度
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)modifyFileAttributeWithFilePath:(NSString*)filePath
                    withFileAttributeData:(Byte*)fileAttributeData
                     withFileAttributeLen:(unsigned short)fileAttributeLen
{
    
    //文件路径
    NSData* bytes = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64+fileAttributeLen;//文件数据长度
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xf;
    
    //功能码
    frame[self.pos++] = 0x36;
    
    //文件路径名称
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<filePath.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=filePath.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    //文件属性数据内容
    for(int i=0;i<fileAttributeLen;i++)
    {
        frame[self.pos++]=*(fileAttributeData+i);
    }
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
    
}
/*－－－－－－－－－－－－－－
 功能：读取文件状态、删除文件和删除目录
 参数：fileName 文件名称  type：操作类型   1:读取文件状态 2:删除文件 3:删除目录
 返回值：
 －－－－－－－－－－－－－－*/
-(NSData*)readFileStatusWithFileName:(NSString*)fileName
                            withType:(int)type
{
    
    //文件名称
    NSData* bytes = [fileName dataUsingEncoding:NSUTF8StringEncoding];
    Byte * fileNameBytes = (Byte *)[bytes bytes];//将字符串转换成字节序
    
    
    self.pos=0;  //偏移初始化为0
    unsigned short checksum=0;//校验和
    //组报文头
    unsigned short userDataLen=3+64;//文件数据长度
    length =userDataLen+9;
    
    [self packHeader];
    //控制码
    frame[self.pos++] = 0xf;
    
    //功能码
    switch(type)
    {
        case 1: //读取文件状态
            frame[self.pos++] = 0x37;
            break;
        case 2://删除文件
            frame[self.pos++] = 0x38;
            break;
        case 3://删除目录
            frame[self.pos++] = 0x39;
            break;
        default:
            return nil;
            
    }
    
    //文件名称
    if(fileNameBytes==nil)
    {
        //文件名为空
        return  nil;
    }
    for(int i=0;i<fileName.length;i++)
    {
        frame[self.pos++] =*(fileNameBytes+i);
        
    }
    for(int i=fileName.length;i<64;i++)
    {
        frame[self.pos++] =0;
    }
    
    //设置校验和
    checksum=[self setCheckSum:frame+6];
    frame[self.pos++]=(Byte)(checksum&0x00ff);
    frame[self.pos++]=(Byte)((checksum&0xff00)>>8);
    
    
    NSData *data =[NSData dataWithBytes:frame
                                 length:length];
    free(frame);
    return data;
    
}
/*－－－－－－－－－－－－－－
 功能：删除文件
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(void)deleteFile{
    //见读取文件状态
    
}
/*－－－－－－－－－－－－－－
 功能：删除目录
 参数：
 返回值：
 －－－－－－－－－－－－－－*/
-(void)deleteCatalogue
{
    //见读取文件状态
}
@end
