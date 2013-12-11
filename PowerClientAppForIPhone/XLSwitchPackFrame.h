//
//  XLSwitchPackFrame.h
//  XLDistributionBoxApp
//
//  Created by admin on 13-11-25.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSwitchPackFrame : NSObject



//定义保护定值结构体
typedef struct protectedValueStruct
{
    Byte  protectedValueParameterType;//定值参数数据类型
    Byte  protectedValueDataType;  //定值数据类型
    unsigned int  protectedValue;  //保护定值
    
}protectedValue;

//定义Ip地址结构体
typedef struct ipAddressStruce
{
    unsigned int ipAddress;  //ip1 ip2 ip3 ip4
    unsigned short portNumber;//端口号
    
}ipAddress;

+(XLSwitchPackFrame*)sharedXLSwitchPackFrame;  //保证单帧实例

//-(NSData*) readTelemeterwithTelemetry:(unsigned short)telemetryOffset withCount:(unsigned short)telemetryCount;

//-(NSData*)readFileWithFileName:(NSString*)fileName
                   //withReadPtr:(unsigned int)readPtr
                  //   withCount:(unsigned short)count
                 //  withEndFlag:(Byte)endFlag;  //读文件组帧

-(NSData*)readSystemClock; //读取系统时钟

-(NSData*) readTelemeterWithEquipName:(unsigned int)equipName
                  withTelemetryOffset:(unsigned short)telemetryOffset
                            withCount:(unsigned short)telemetryCount;  //读遥测



-(NSData*) readTelemeterPrimaryValueOrSecondaryValueWithEquipName:
(unsigned int)equipName
                                              withTelemeterOffset:(unsigned short)telemetryOffset
                                               withTelemeterCount:(unsigned short)telemetryCount
                                                withTelemeterType:(unsigned int)
type;    //读取遥测一次值与二次值





//-(NSData*)readTelesignalWithEquipName:(unsigned int)equipName
//                           withOffset:(unsigned short)telesignalOffset withCount: (unsigned short) telesignalCount ;   //读遥信





-(NSData*)readTelesignalWithEquipName:(unsigned int)equipName
                           withOffset:(unsigned short)telesignalOffset withCount: (unsigned short) telesignalCount
                             withType:(unsigned short)telesignalType;
                            //读取单点遥信和双点遥信


//-(NSData*)readSoeEventWithEquipName:(unsigned int)equipName
//                       withSoecount:(unsigned short)soeCount
//                        withReadPtr:(unsigned short)readPtr
//                       withWritePtr:(unsigned short)writePtr
//                      withBufferLen:(unsigned short)bufferLen; //读soe事件




-(NSData*)readSoeEventWithEquipName:(unsigned int)equipName
                       withSoecount:(unsigned short)soeCount
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen
                           withType:(unsigned short)soeType;
                    //读取单点soe和双点soe




-(NSData*)readEnergyWithEquipName:(unsigned int)equipName
                       withOffset:(unsigned short)energyOffset
                        withCount: (unsigned short) energyCount;//读取电度


-(NSData*)readCosEventWithEquipName:(unsigned int)equipName
                       withCoscount:(unsigned short)cosCount
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen; //读取cos事件



-(NSData*)readHistroryWithEquipName:(unsigned int)equipName
                           withType:(unsigned short)dataType
                          withPoint:(unsigned short)pointNumber
                      withStartTime: (unsigned int)startTime
                  withFrozenDensity:(unsigned short)frozenDensity
                          withCount:(unsigned short)Count;  //读取历史遥测与历史电度


-(NSData*)readEventWithEquipName:(unsigned int)equipName
                       withCount:(unsigned short)Count
                     withReadPtr:(unsigned short)readPtr
                    withWritePtr:(unsigned short)writePtr
                   withBufferLen:(unsigned short)bufferLen
                   withEventType:(unsigned short)eventType;    //读取事件

-(NSData*)readPointDescribeWithEquipName:(unsigned int)equipName
                           withPointType:(Byte)pointType
                         withPointOffset:(unsigned short)pointOffset
                          withPointCount:(unsigned short)pointCount;  //读取点号描述

-(NSData*)readLoopDataWithEquipName:(unsigned int)equipName
                          withCount:(unsigned short)count
                        withReadPtr:(unsigned short)readPtr
                       withWritePtr:(unsigned short)writePtr
                      withBufferLen:(unsigned short)bufferLen;   //读取回线数据


-(NSData*)readRunStatusWithEquipName:(unsigned int)equipName
                       withRunStatus:(unsigned int)runStatus;     //读取运行状态


-(NSData*)readProtectedValueWithEquipName:(unsigned int)equipName
                           withLoopNumber:(unsigned short)loopNumber
                          withPointOffset:(unsigned short)pointOffset
                          withPointNumber:(unsigned short)pointCount;  //读取保护定值


-(NSData*)modifySystemClockWithYear:(unsigned short)year
                          withMonth:(Byte)month
                            withDay:(Byte)day
                           withWeek:(Byte)week
                           withHour:(Byte)hour
                         withMinute:(Byte)minute
                         withSecond:(Byte)second
                      withMilSecond:(unsigned short)milSecond;//修改系统时钟

-(NSData*)readRunInformationWithEquipName:(unsigned int)equipName
                                withCount:(unsigned short)count
                              withReadPtr:(unsigned short)readPtr
                             withWritePtr:(unsigned short)writePtr
                            withBufferLen:(unsigned short)bufferLen;  //读取运行信息

-(NSData*)readSamplingWaveformWithEquipName:(unsigned int)equipName
                                  withFlag1:(Byte)flag1
                                  withFlag2:(Byte)flag2
                             withLoopNumber:(unsigned short)loopNumber
                             withCurveCount:(unsigned short)curveCount;//读取采样波形

-(NSData*)readVersionInfomationWithEquipName:(unsigned int)equipName
                                   withCount:(unsigned short)count
                                 withReadPtr:(unsigned short)readPtr
                                withWritePtr:(unsigned short)writePtr
                               withBufferLen:(unsigned short)bufferLen;  //读取版本信息

-(NSData*)readDevceAddressWithEquipName:(unsigned int)equipName;  //读取装置地址


-(NSData*)readGprsAddressWithEquipName:(unsigned int)equipName;  //读取GPRS地址

-(NSData*)remoteControlWithEquipName:(unsigned int)equipName
             withRemoteControlNumber:(unsigned short)remoteControlNumber
          withRemoteControlAttribute:(unsigned short)remoteControlAttribute
               withRemoteControlType:(unsigned int)controlType; //遥控操作

-(NSData*)remoteInvolutionWithEquipName:(unsigned int)equipName;   //故障远方复归

-(NSData*)BatteryActivationWithEquipName:(unsigned int)equipName
                      withExcitationFlag:(Byte)flag;   //设置电池活化

-(NSData*) remoteExitWithEquipName:(unsigned int)equipName;//设置远方退出

-(NSData*)addressSetCommandWithEquipName:(unsigned int)equipName
                       withDeviceAddress:(Byte)deviceAddress
                         withNetAddress1:(unsigned int)netAddress1
                         withNetAddress2:(unsigned int)netAddress2;  //地址设置命令

-(NSData*)clearRecordWithEquipName:(unsigned int)equipName
                    withRecordType:(Byte)recordType;  //纪录清除

-(NSData*)openOrCloseWirelessWithEquipName:(unsigned int)equipName
                            withRecordType:(Byte)recordType; // 打开或关闭无线通讯模块

-(NSData*)protectedValueSetWithEquipName:(unsigned int)equipName
                          withLoopNumber:(unsigned short)loopNumber
                         withPointOffset:(unsigned short)pointOffset
                          withPointCount:(unsigned short)pointCount
                      withProtectedValue:(protectedValue[])value;  //设置保护定值


-(NSData*)gprsAddressSetWithEquipName:(unsigned int)equipName
                           withHostIp:(ipAddress)hostIp
                         withBackupIp:(ipAddress)backupIp; //设置GPRS地址


-(NSData*)readFileWithFileName:(NSString*)fileName
                   withReadPtr:(unsigned int)readPtr
                     withCount:(unsigned short)count
                   withEndFlag:(Byte)endFlag;     //读文件组帧

-(NSData*)writeFileWithFileName:(NSString*)fileName
                    withFileLen:(unsigned int)fileLen
                   withWritePtr:(unsigned int)writePtr
                    withByteLen:(unsigned short)bytesLen
                    withEndFlag:(Byte)endFlag
                       withData:(Byte*)fileData;   //写文件组帧


-(NSData*)readCatalogueWithFilePath:(NSString*)filePath
                        withReadPtr:(unsigned short)readPtr;   //读目录组帧

-(NSData*)createCatalogueWithFilePath:(NSString*)filePath;  //创建目录组帧

-(NSData*)modifyFileNameWithSrcFilePath:(NSString*)srcFilePath
                        withDesFilePath:(NSString*)desFilePath
                         withModifyType:(int)modifyType;//文件改名组帧和目录改名组帧


-(NSData*)modifyFileAttributeWithFilePath:(NSString*)filePath
                    withFileAttributeData:(Byte*)fileAttributeData
                     withFileAttributeLen:(unsigned short)fileAttributeLen;//修改文件属性


-(NSData*)readFileStatusWithFileName:(NSString*)fileName
                            withType:(int)type;//读取文件状态、删除文件和删除目录

@end
