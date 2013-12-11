//
//  XLViewController.m
//  PowerClientAppForIPhone
//
//  Created by JY on 13-11-15.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLViewController.h"
#import "XLSwitchPackFrame.h"
#import "XLSwitchPackFrame.h"
#import "XLSocketManager.h"


@interface XLViewController ()

@end

@implementation XLViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response:)
                                                 name:@"test"
                                               object:nil];
    
    NSLog(@"注册通知:%@",@"test");
      NSLog(@"%d",38471/1000);
         NSLog(@"%.3f",(38471%1000)/1000.0);
    
    
//    //读遥测数据解析
    //    XLSwitchPackFrame *packFrame = [XLSwitchPackFrame sharedXLSwitchPackFrame];
//    
//    
//    //读遥测数据解析
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame readTelemeterWithEquipName:4096 withTelemetryOffset:0 withCount:20]];

    
    //读单点遥信数据解析
    //[[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame readTelesignalWithEquipName:4096 withOffset:0 withCount:20]];
    
    
    //读取单点soe事件解析
     // [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame
        //readSoeEventWithEquipName:4096 withSoecount:20 withReadPtr:0 withWritePtr:0 withBufferLen:256]];
    
    
    
    //读取电度解析测试
   // [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame
    //readEnergyWithEquipName:4096 withOffset:0 withCount:20]];
    
    //读取单点cos事件
    
        //[[XLSocketManager sharedXLSocketManager] packRequestFrame:[
                                                                 //  packFrame readCosEventWithEquipName:4096 withCoscount:20 withReadPtr:0 withWritePtr:0 withBufferLen:256]];
    
    //读取历史遥测  dataType:1:历史遥测   2:历史电度  －需要测试
    //[[XLSocketManager sharedXLSocketManager] packRequestFrame:[
    // packFrame readHistroryWithEquipName:4096 withType:1 withPoint:1 withStartTime:258573 withFrozenDensity:5 withCount:20]];
    
    //读取运行信息
    
    //读取事件 事件类型:0 动作事件 1 操作事件 2 告警事件
        //[[XLSocketManager sharedXLSocketManager] packRequestFrame:[
         //packFrame readEventWithEquipName:4096 withCount:20 withReadPtr:0 withWritePtr:0 withBufferLen:0 withEventType:1
                                                                 //  ]];
    
    
    //读取采样波形
    
    
    
    
    
    
    
    //读取点号描述
    
    
    
    
    
    //读取版本信息
    
    
    
    
    //读保护定值
    
    
    
    //读有效值
    
    

    //读gprs地址
    
    
    //读遥测一次值
    
    
    
    //读遥测二次值
    
    
    //读取装置运行状态
    
    
    //读电压、电流合格率
    
    
    
    //遥控预置 执行  、撤销
//   [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//    [packFrame remoteControlWithEquipName:4096 withRemoteControlNumber:1
//                withRemoteControlAttribute:0 withRemoteControlType:2]];
    

    
    //故障远方复归
//   [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame remoteInvolutionWithEquipName:4096]];
    
    //设置电池活化
//[[XLSocketManager sharedXLSocketManager] packRequestFrame:
//   [packFrame BatteryActivationWithEquipName:4096 withExcitationFlag:1]];
    
    
    
    
//    //远程退出
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame remoteExitWithEquipName:4096]];
//
//    
//    
//    
//    //地址设置命令
//    //[[XLSocketManager sharedXLSocketManager] packRequestFrame:
//    // [packFrame addressSetCommandWithEquipName:4096 withDeviceAddress:<#(Byte)#> withNetAddress1:<#(unsigned int)#> withNetAddress2:<#(unsigned int)#>:4096]];
//    
//    
//    //纪录清除
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame clearRecordWithEquipName:4096 withRecordType:1]];
//
//    
//    //打开／关闭无线通讯模块  0-无效 
//    //1-开
//    //2-关
//    
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame openOrCloseWirelessWithEquipName:4096 withRecordType:0]];
//
//    
//
//    
//    
//    
//    
//    
//    
//    //设置保护定植
//    protectedValue value[3]={{0,0,0}};
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame protectedValueSetWithEquipName:4096 withLoopNumber:0 withPointOffset:0 withPointCount:3 withProtectedValue:value]];
//
    
    
    //GPRS地址设置命令
    
    
    
    //读文件
    
    
    //写文件
    
}

-(void)response:(NSNotification*)notify{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary* dcs = notify.userInfo;
        
//        NSInteger count = [[dcs valueForKey:@"1"] integerValue];
//        
//        NSLog(@"遥测个数:%d",count);
//        
//        for(int i = 0; i<count;i++){
//            
//            NSArray *array = [dcs valueForKey:[NSString stringWithFormat:@"%d",i+2]];
//            
//            NSLog(@"遥测值：%f",[[array objectAtIndex:0] floatValue]);
//            NSLog(@"遥测描述:%@",[array objectAtIndex:1]);
//        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequest:(id)sender {
    //读遥测数据解析
    XLSwitchPackFrame *packFrame = [XLSwitchPackFrame sharedXLSwitchPackFrame];
    
    
    //读遥测数据解析
   // [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame readTelemeterWithEquipName:4096 withTelemetryOffset:0 withCount:20]];
    
    
    //    //设置保护定植
//    protectedValue value[3]={{0,0,0}};
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame protectedValueSetWithEquipName:4096 withLoopNumber:0 withPointOffset:0 withPointCount:3 withProtectedValue:value]];
    
    
    //点号描述 通过

//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame readPointDescribeWithEquipName:4096 withPointType:2 withPointOffset:0 withPointCount:20]];
    
    //版本描述 通过
//        [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame readVersionInfomationWithEquipName:4096 withCount:20 withReadPtr:0 withWritePtr:0 withBufferLen:0]];
    
    
    //读有效值
//            [[XLSocketManager sharedXLSocketManager] packRequestFrame:[packFrame
//            readLoopDataWithEquipName:4096 withCount:20 withReadPtr:0 withWritePtr:0 withBufferLen:0]];
    
    
    //读遥信
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//     [packFrame readTelesignalWithEquipName:4096 withOffset:0 withCount:20]];
    
    //读soe事件 通过
//    
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//    [packFrame readSoeEventWithEquipName:4096 withSoecount:20 withReadPtr:0 withWritePtr:0 withBufferLen:0]];
    
    //读保护定值  测试通过
  //  [[XLSocketManager sharedXLSocketManager] packRequestFrame:
  // [packFrame  readProtectedValueWithEquipName:4096 withLoopNumber:0 withPointOffset:0 withPointNumber:20]];   //pointNumber:点号个数   f27
    
    
    
    
    //读遥测一次值 或二次值  测试通过
    
//    [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//    [packFrame readTelemeterPrimaryValueOrSecondaryValueWithEquipName:4096 withTelemeterOffset:0 withTelemeterCount:20 withTelemeterType:1]];
    
    
//    //读取运行状态   测试通过
//    
//        [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//        [packFrame readRunStatusWithEquipName:4096 withRunStatus:0]];
    
    
    
    
    //读取采样波形   1:回线曲线   2:遥测曲线  需要测试   f20
//    
//   [[XLSocketManager sharedXLSocketManager] packRequestFrame:
//   [packFrame readSamplingWaveformWithEquipName:4096 withFlag1:1 withFlag2:1 withLoopNumber:1 withCurveCount:5]];
//
//
//    //读取历史遥测  dataType:1:历史遥测   2:历史电度  －需要测试  f16
//   [[XLSocketManager sharedXLSocketManager] packRequestFrame:[
//   packFrame readHistroryWithEquipName:4096 withType:1 withPoint:1 withStartTime:0 withFrozenDensity:5 withCount:20]];
    
    //读取事件 事件类型:0 动作事件 1 操作事件 2 告警事件  需要测试   f18
//  [[XLSocketManager sharedXLSocketManager] packRequestFrame:[
// packFrame readEventWithEquipName:4096 withCount:20 withReadPtr:0 withWritePtr:0 withBufferLen:0 withEventType:1
//     ]];
    
    
    
    
    //读取文件
       [[XLSocketManager sharedXLSocketManager] packRequestFrame:[
       packFrame readFileWithFileName:@"/tffsa/cfg/ida00.cfg" withReadPtr:0 withCount:256 withEndFlag:0]];
    
}
@end
