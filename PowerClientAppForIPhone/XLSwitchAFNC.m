//
//  XLSwitchAFNC.m
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchAFNC.h"

@implementation XLSwitchAFNC




/*读遥测解析*/
-(void)F10{
    
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 4;
    
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    for(int i = 0;i<count;i++){
        
        //先保存到数组  遥测值   遥测品质描述
        NSMutableArray *array = [NSMutableArray array];
        
        float value = *(long*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:value]];
        self.pos += 4;
        
        [array addObject:[self parseDesc:*(Byte*)(self.userData + self.pos)]];
        self.pos += 1;
        
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
    }
    
    NSLog(@"遥测解析结束");
}

-(NSString*)parseDesc:(Byte)desc{
    
    NSString *D0 = (desc & 0x01) ? @"有效" : @"无效";
    NSString *D1 = (desc & 0x02) ? @"被封锁" : @"未被封锁";
    NSString *D2 = (desc & 0x04) ? @"被取代" : @"未被取代";
    NSString *D3 = (desc & 0x08) ? @"非当前值" : @"当前值";
    NSString *D4 = (desc & 0x10) ? @"溢出" : @"未溢出";
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@",D0,D1,D2,D3,D4];
}

//遥信状态字节解析
-(NSString*)parseTelesignalStatus:(Byte)status
{
    NSString *_status = (status == 0x81) ? @"合闸" : @"分闸";
    
    return [NSString stringWithFormat:@"%@",_status];
    
}




-(NSString*)dateToStringWith:(NSDate*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // NSDate *date=[formatter dateFromString:@"1970年1月1日"];
    NSString *date=[formatter stringFromDate: datetime];
    
    return date;
}



/*日期 分钟转换*/
-(NSDate*)dateMinuteTransitionWith:(unsigned int)second withStartData :(NSString*)datetime
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setSecond : second];
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // NSDate *date=[formatter dateFromString:@"1970年1月1日"];
    NSDate *date=[formatter dateFromString: datetime];
    
    
    //将字符串转换成NSData
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:date options:0];
    return newDate;
}


/*读遥信解析*/
-(void)F11
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    //遥信偏移量
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    
    //遥信个数
    self.pos += 2;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    //遥信只有品质描述
    for(int i = 0;i<count;i++){
        
        //先保存到数组 遥信只有品质描述
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:[self parseDesc:*(Byte*)(self.userData + self.pos)]];
        self.pos += 1;
        
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
    }
    
    NSLog(@"遥信解析结束");
}

/*读取单点soe*/
-(void)F12
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    //soe个数
    NSInteger soeCount = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:soeCount]
                      forKey:[self getKeyString:self.key++]];
    
    //读指针
    self.pos += 2;
    
    NSInteger readPtr = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    //写指针
    self.pos += 2;
    NSInteger writePtr =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:writePtr]
                      forKey:[self getKeyString:self.key++]];
    
    //缓冲区长度
    self.pos += 2;
    NSInteger bufferLen =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:bufferLen]
                      forKey:[self getKeyString:self.key++]];
    
    //soe内容  9*个数
    self.pos+=2;
    
    //将soe内容写入字典
    for(int i =0;i<soeCount;i++)
    {
        //先将soe事件保存到数组
        NSMutableArray *array = [NSMutableArray array];
        //遥信点号 2
        unsigned short  pointNumber =*(unsigned short*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:pointNumber]];
        self.pos += 2;
        
        //遥信状态 1
        Byte status  = *(self.userData + self.pos);
        
        
        [array addObject:[NSNumber numberWithFloat:status]];
        self.pos+=1;
        
        //绝对时间分钟 4个字节
        unsigned int  absoluteMinute=*(unsigned int*)(self.userData + self.pos);
        //需要将绝对时间进行转换成日期
        NSDate* data= [self dateMinuteTransitionWith:absoluteMinute*60 withStartData:@"1970年1月1日0时0分"];
        
        self.pos+=4;
        
        //时间毫秒 2
        unsigned short absoluteMilSecond =*(unsigned short*)(self.userData + self.pos);
        
        NSString *dateString = [self dateToStringWith:data];
        dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@"%d秒%d毫秒",absoluteMilSecond/1000,absoluteMilSecond%1000]];
        [array addObject:dateString];
        
        self.pos+=2;
        
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
        
    }
}

/*读取电度*/
-(void)F13
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //电度偏移量 不解析
    self.pos+=2;
    
    //电度个数
    NSInteger energyCount = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:energyCount]
                      forKey:[self getKeyString:self.key++]];
    
    
    //电度数据
    self.pos+=2;
    for(int i =0;i<energyCount;i++)
    {
        
        //将电度数据保存到数组
        NSMutableArray *array = [NSMutableArray array];
        unsigned int energyData =*(unsigned int*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:energyData]];
        
        self.pos+=4;
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
    }
    
    NSLog(@"电度解析结束");
}

/*读取单点cos事件*/
-(void)F14
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //cos个数
    unsigned short  cosCout =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:cosCout]
                      forKey:[self getKeyString:self.key++]];
    
    
    //读指针
    self.pos+=2;
    unsigned short  readPtr =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    
    
    //写指针
    self.pos+=2;
    unsigned short  writePtr =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:writePtr]
                      forKey:[self getKeyString:self.key++]];
    
    
    //缓冲区长度
    self.pos+=2;
    unsigned short  bufferLen =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:bufferLen]
                      forKey:[self getKeyString:self.key++]];
    
    //cos内容
    self.pos+=2;
    for(int i=0;i<cosCout;i++)
    {
        
        NSMutableArray *array = [NSMutableArray array];
        //遥信点号
        unsigned short telesignalNumber =*(unsigned short*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:telesignalNumber]];
        
        self.pos+=2;
        //遥信状态 0x81 合闸   0x01 分闸
        // Byte telesignalStatus =*(Byte*)(self.userData + self.pos);
        [array addObject:[self parseTelesignalStatus:*(Byte*)(self.userData + self.pos)]];
        self.pos+=1;
        
        //将解析内容写入字典
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
        
    }
    NSLog(@"cos事件解析结束");
}



/*读取双点遥信*/
-(void)F1C
{
    //解析方法与单点遥信相同  单点遥信f11
    [self F11];
    
}
/*读取双点SOE事件*/
-(void)F1D
{
    //解析方法与单点soe事件相同  单点soef12
    
    [self F12];
    
}


/*读取历史遥测*/
-(void)F16
{
    //装置需要配置
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //点号
    unsigned short  pointNumber =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointNumber]
                      forKey:[self getKeyString:self.key++]];
    
    //起始时间
    self.pos+=2;
    unsigned int  startTime =*(unsigned int*)(self.userData + self.pos);
    NSDate* date= [self dateMinuteTransitionWith:startTime*60 withStartData:@"1970年1月1日0时0分"];
    //data转换成NSstring  将绝对时间转换成系统时间写入字典
    NSString *dateString = [self dateToStringWith:date];
    [self.resultSet setValue:dateString forKey:[self getKeyString:self.key++]];
    //    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:startTime]
    //                      forKey:[self getKeyString:self.key++]];
    
    //数据冻结密度
    self.pos+=4;
    unsigned short freezeDensity =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:freezeDensity]
                      forKey:[self getKeyString:self.key++]];
    
    //个数
    self.pos+=2;
    unsigned short count =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    
    //数据内容
    self.pos+=2;
    
    for(int i=0;i<count;i++)
    {
        NSMutableArray *array = [NSMutableArray array];
        //数据内容
        unsigned int data =*(unsigned int*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:data]];
        self.pos+=4;
        
        //将解析内容写入字典
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
    }
    NSLog(@"历史遥测解析结束");
}


/*读取压板状态解析*/
-(void)F1A
{
    
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    
    //压板偏移量
    unsigned short plateOffset =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:plateOffset]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=2;
    
    //压板个数
    unsigned short plateCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:plateCount]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    //数据内容
    for(int i =0;i<plateCount;i++)
    {
        
        Byte status =*(Byte*)(self.userData + self.pos);
        switch (status) {
            case 0: //无效
                [self.resultSet setValue:@"压板无效"
                                  forKey:[self getKeyString:self.key++]];
                break;
            case 0x81://压板投入
                [self.resultSet setValue:@"压板投入"
                                  forKey:[self getKeyString:self.key++]];
                break;
            case 0x01://压板退出
                [self.resultSet setValue:@"压板退出"
                                  forKey:[self getKeyString:self.key++]];
                break;
            default:
                [self.resultSet setValue:@"终端回复数据出错"
                                  forKey:[self getKeyString:self.key++]];
                break;
        }
        self.pos+=1;
        
    }
    
    NSLog(@"读取压板状态解析结束");
    
}

/*读取历史电度*/
-(void)F17
{
    
    [self F16];
    
    
}
/*读取采样波形*/
-(void)F20
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //标志1  1-回线数据  2-遥测曲线
    Byte flag1 =*(Byte*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:flag1]
                      forKey:[self getKeyString:self.key++]];
    
    //标志2 对回线有效
    self.pos+=1;
    Byte flag2 =*(Byte*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:flag2]
                      forKey:[self getKeyString:self.key++]];
    
    
    //回线号／遥测号
    self.pos+=1;
    unsigned short number =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:number]
                      forKey:[self getKeyString:self.key++]];
    
    //曲线点个数
    self.pos+=2;
    unsigned short count =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    
    //曲线数据内容
    self.pos+=2;
    
    for(int i=0;i<count;i++)
    {
        NSMutableArray *array = [NSMutableArray array];
        //数据内容
        unsigned short data =*(unsigned short*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:data]];
        self.pos+=2;
        
        //将解析内容写入字典
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
        
    }
    
    NSLog(@"采样波形解析结束");
    
}

/*读取变化遥测*/
-(void)F1B
{
    //读取变化遥测解析
    //解析方法与解析单点遥测相同
    [self F10];
}

/*读取遥测极值*/
-(void)F1E
{
    
    //解析遥测极值
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    
    //点号
    unsigned short pointNumber =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointNumber]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    
    //起始时间  绝对时间分钟 4个字节
    
    unsigned int startTime =*(unsigned int*)(self.userData + self.pos);
    
    //将绝对时间转换成系统时间
    NSDate* date= [self dateMinuteTransitionWith:startTime*60 withStartData:@"1970年1月1日0时0分"];
    //data转换成NSstring  将绝对时间转换成系统时间写入字典
    NSString *dateString = [self dateToStringWith:date];
    [self.resultSet setValue:dateString forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=4;
    
    //冻结密度
    unsigned short frozenDensity=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:frozenDensity]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    //个数
    unsigned short count=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    //数据内容
    for(int i=0;i<count;i++)
    {
        
        //最大数据 4个字节
        
        unsigned int maxData =*(unsigned int*)(self.userData + self.pos);
        [self.resultSet setValue:[NSNumber numberWithUnsignedChar:maxData]
                          forKey:[self getKeyString:self.key++]];
        self.pos+=4;
        
        
        //绝对时间 分钟 4个字节
        unsigned int  absoluteMinuteMax=*(unsigned int*)(self.userData + self.pos);
        //需要将绝对时间进行转换成日期
        NSDate* dataMax= [self dateMinuteTransitionWith:absoluteMinuteMax*60 withStartData:@"1970年1月1日0时0分"];
        
        self.pos+=4;
        
        //绝对时间毫秒 2个字节
        unsigned short absoluteMilSecondMax =*(unsigned short*)(self.userData + self.pos);
        NSString *dateString = [self dateToStringWith:dataMax];
        dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@"%d秒%d毫秒",absoluteMilSecondMax/1000,absoluteMilSecondMax%1000]];
        
        [self.resultSet setValue:dateString forKey:[self getKeyString:self.key++]];
        self.pos+=2;
        
        //最小数据： 4个字节
        unsigned int minData =*(unsigned int*)(self.userData + self.pos);
        [self.resultSet setValue:[NSNumber numberWithUnsignedChar:minData]
                          forKey:[self getKeyString:self.key++]];
        self.pos+=4;
        
        
        //绝对时间 分钟 4个字节
        unsigned int  absoluteMinuteMin=*(unsigned int*)(self.userData + self.pos);
        //需要将绝对时间进行转换成日期
        NSDate* dataMin= [self dateMinuteTransitionWith:absoluteMinuteMin*60 withStartData:@"1970年1月1日0时0分"];
        
        self.pos+=4;
        
        //绝对时间毫秒 2个字节
        unsigned short absoluteMilSecondMin =*(unsigned short*)(self.userData + self.pos);
        NSString *dateStringMin= [self dateToStringWith:dataMin];
        dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@"%d秒%d毫秒",absoluteMilSecondMin/1000,absoluteMilSecondMin%1000]];
        
        [self.resultSet setValue:dateStringMin forKey:[self getKeyString:self.key++]];
        self.pos+=2;
    }
    
    NSLog(@"读取遥测极值解析结束");
}



/*读取压板定值解析*/
-(void)F25
{
    //
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    
    
    //回路序号
    unsigned short loopNumber =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:loopNumber]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=2;
    
    //点号偏移
    unsigned short pointOffset =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointOffset]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=2;
    //点号个数
    unsigned short pointNumber =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointNumber]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    //点号内容
    
    for(int i=0;i<pointNumber;i++)
    {
        
        Byte plateValue =*(Byte*)(self.userData + self.pos);
        
        switch (plateValue) {
            case 0: //无效
                [self.resultSet setValue:@"压板无效" forKey:[self getKeyString:self.key++]];
                
                break;
            case 0x81://压板投入
                [self.resultSet setValue:@"压板投入" forKey:[self getKeyString:self.key++]];
                break;
            case 0x01://压板退出
                [self.resultSet setValue:@"压板退出" forKey:[self getKeyString:self.key++]];
                break;
            default:
                [self.resultSet setValue:@"定值出错" forKey:[self getKeyString:self.key++]];
                break;
        }
        self.pos+=1;
    }
}

//读取装置压板状态
//读取装置运行状态

///*读取装置地址F*/
//-(void)F24
//{
//
//    NSLog(@"执行方法:%s",__func__);
//
//    self.resultSet = nil;
//    self.resultSet = [[NSMutableDictionary alloc] init];
//    //设备名称 不解析
//    self.pos += 4;
//
//
//    //地址信息
//    unsigned int  addressInfo =((*(unsigned int*)(self.userData + self.pos))&0xf);
//    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:addressInfo]
//                      forKey:[self getKeyString:self.key++]];
//
//    //net1
//    self.pos+=4;
//    unsigned int  net1 =*(unsigned int*)(self.userData + self.pos);
//    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:net1]
//                      forKey:[self getKeyString:self.key++]];
//
//    self.pos+=4;
//    unsigned int  net2 =*(unsigned int*)(self.userData + self.pos);
//    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:net2]
//                      forKey:[self getKeyString:self.key++]];
//
//    NSLog(@"装置地址解析结束");
//}
/*读取保护定值*/
-(void)F27
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //回路序号
    unsigned short loopNumber=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:loopNumber]
                      forKey:[self getKeyString:self.key++]];
    
    //点号偏移
    self.pos+=2;
    unsigned short pointOffset=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointOffset]
                      forKey:[self getKeyString:self.key++]];
    
    //点号个数
    self.pos+=2;
    unsigned short pointCount=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointCount]
                      forKey:[self getKeyString:self.key++]];
    //定值描述 58个字节
    self.pos+=2;
    
    self.pos+=58;
    //定值内容
    
    for(int i=0;i<pointCount;i++)
    {
        
        NSMutableArray *array = [NSMutableArray array];
        //定值参数类型
        Byte  parameterType=*(Byte*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:parameterType]];
        self.pos+=1;
        
        //定值数据类型
        Byte  dataType=*(Byte*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:dataType]];
        self.pos+=1;
        
        //定值类型
        float  data=*(float*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:data]];
        self.pos+=4;
        
        //将解析内容写入字典
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
        
        
    }
    NSLog(@"读取保护定值解析结束");
    
}
/*读gprs地址*/
-(void)F2A
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //主ip地址
    unsigned int hostIpAddress =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:hostIpAddress]
                      forKey:[self getKeyString:self.key++]];
    
    //主端口号
    self.pos+=4;
    unsigned short hostPort =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:hostPort]
                      forKey:[self getKeyString:self.key++]];
    
    
    //备份ip地址
    self.pos+=2;
    unsigned int backupAddress =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:backupAddress]
                      forKey:[self getKeyString:self.key++]];
    //备份端口号
    self.pos+=4;
    unsigned short backupPort =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:backupPort]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=2;
    
    //apn 32个字节
    
    
    
    //vpn 32个字节
    self.pos+=32;
    
    //psw 32个字节
    self.pos+=32;
    
    NSLog(@"读取gprs地址解析结束");
}
/*读遥测一次值*/
-(void)F2B
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //遥测偏移
    unsigned short offset =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    
    //遥测个数
    self.pos+=2;
    unsigned short count =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    //遥测数据
    self.pos+=2;
    for(int i=0;i<count;i++)
    {
        NSMutableArray *array = [NSMutableArray array];
        //遥测数据
        float parameterType=*(float*)(self.userData + self.pos);
        [array addObject:[NSNumber numberWithFloat:parameterType]];
        self.pos+=4;
        
        //单位 8个字节  字符串
        //        double uint =*(double*)(self.userData + self.pos);
        //        [array addObject:[NSNumber numberWithFloat:uint]];
        
        
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *desc = [[NSString alloc] initWithData: data encoding:enc];
        
        [array addObject:desc];
        
        
        
        self.pos+=8;
        //self.pos += len+1;
        
        
        //将解析内容写入字典
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
        
    }
    
    NSLog(@"读取遥测一次值解析结束");
}
/*读遥测二次值*/
-(void)F2c
{
    
    
    //解析方法与遥测一次值相同
    
    [self F2B];
    
    
}
/*读取运行状态*/
-(void)F2D
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    //运行状态 4个字节 数据
    
    unsigned int data=*(int*)(self.userData + self.pos);
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self getRunStatus:data]];
    
    //将运行状态数据保存到字典
    [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
}

-(NSString*)getRunStatus:(unsigned int)status
{
    
    NSString *D0 = (status & 0x01) ? @"运行异常" : @"运行正常";
    NSString *D1 = (status & 0x02) ? @"告警异常" : @"告警正常";
    NSString *D2 = (status & 0x04) ? @"通讯异常" : @"通讯正常";
    NSString *D3 = (status & 0x08) ? @"零序电流状态异常" : @"零序电流状态正常";
    NSString *D4 = (status & 0x10) ? @"过流状态异常" : @"过流状态正常";
    
    NSString *D5 = ((status>>31) & 0x01) ? @"开关分闸" : @"开关合闸";
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@，%@",D0,D1,D2,D3,D4,D5];
    
    
}

/*－－－－－－－－－－－－－－/
 杨柏山
 /－－－－－－－－－－－－－－*/
/*－－－－－－－－－－－－－－/
 读点号描述
 /－－－－－－－－－－－－－－*/
-(void)F22{
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 5;
    
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    for(int i = 0; i< count;i++){
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *desc = [[NSString alloc] initWithData: data encoding:enc];
        [self.resultSet setValue:desc forKey:[self getKeyString:self.key++]];
        self.pos += len+1;
    }
}


/*－－－－－－－－－－－－－－/
 读版本信息
 /－－－－－－－－－－－－－－*/
-(void)F23{
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 4;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 6;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    for(int i = 0; i< count;i++){
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *desc = [[NSString alloc] initWithData: data encoding:enc];
        [self.resultSet setValue:desc forKey:[self getKeyString:self.key++]];
        self.pos += len+1;
    }
}
/*－－－－－－－－－－－－－－/
 读装置地址
 /－－－－－－－－－－－－－－*/
-(void)F24{
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 5;
    
    for(int i = 0; i < 2; i++){
        NSString *net = [self binToStringWithBytes:self.userData + self.pos withblen:4];
        [self.resultSet setValue:net forKey:[self getKeyString:self.key++]];
        self.pos += 4;
    }
}

/*－－－－－－－－－－－－－－/
 读有效值
 /－－－－－－－－－－－－－－*/
-(void)F28{
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 4;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 6;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    for(int i = 0; i< count;i++){
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *desc = [[NSString alloc] initWithData: data encoding:enc];
        [self.resultSet setValue:desc forKey:[self getKeyString:self.key++]];
        self.pos += len+1;
    }
}

/*－－－－－－－－－－－－－－/
 读取事件
 /－－－－－－－－－－－－－－*/
-(void)F18
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 4;
    
    //事件个数
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    
    
    
    //读指针  不保存
    self.pos+=2;
    unsigned short readPtr = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    
    //写指针
    self.pos+=2;
    unsigned short writePtr = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:writePtr]
                      forKey:[self getKeyString:self.key++]];
    
    
    //缓冲区长度
    self.pos+=2;
    unsigned short bufferLen = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:bufferLen]
                      forKey:[self getKeyString:self.key++]];
    
    
    //事件类型
    self.pos+=2;
    unsigned short eventType = *(unsigned short*)(self.userData + self.pos);
    
    switch(eventType)
    {
        case 0://动作事件
        case 1:
        case 2:
            [self.resultSet setValue:[NSNumber numberWithUnsignedChar:eventType]
                              forKey:[self getKeyString:self.key++]];
            break;
        default:
            NSLog(@"事件类型错误");
            return;
            
    }
    
    self.pos+=2;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //事件内容    字符串 ＋绝对时间分钟＋绝对时间毫秒，参照soe解析
    for(int i=0;i<count;i++)
    {
        
        NSMutableArray *array = [NSMutableArray array];
        
        //绝对时间分钟 4个字节
        unsigned int  absoluteMinute=*(unsigned int*)(self.userData + self.pos);
        //需要将绝对时间进行转换成日期
        NSDate* data= [self dateMinuteTransitionWith:absoluteMinute*60 withStartData:@"1970年1月1日0时0分"];
        
        self.pos+=4;
        
        //时间毫秒 2个字节
        unsigned short absoluteMilSecond =*(unsigned short*)(self.userData + self.pos);
        NSString *dateString = [self dateToStringWith:data];
        dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@"%d秒%d毫秒",absoluteMilSecond/1000,absoluteMilSecond%1000]];
        
        [array addObject:dateString];
        
        self.pos+=2;  //事件内容 128个字符串
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *datastring = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *desc = [[NSString alloc] initWithData: datastring encoding:enc];
        
        //self.pos += len+1;
        
        self.pos+=128;
        
        [array addObject:desc];
        
        [self.resultSet setValue:desc forKey:[self getKeyString:self.key++]];
    }
}



/*读取遥测浮点型*/
-(void)F1F
{
    //与解析遥测一次值类似
    //单位6个字节
}


/*读取装置列表*/
-(void)F29
{
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
    self.pos += 4;
    
    
    //装置个数
    unsigned short deviceCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:deviceCount]
                      forKey:[self getKeyString:self.key++]];
    self.pos+=2;
    
    
    
    //读指针
    
    unsigned short readPtr=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    self.pos+=2;
    
    
    //写指针
    unsigned short writePtr=*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:writePtr]
                      forKey:[self getKeyString:self.key++]];
    self.pos+=2;
    
    
    
    //装置总个数
    unsigned short totalCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:totalCount]
                      forKey:[self getKeyString:self.key++]];
    self.pos+=2;
    
    
    for(int i =0;i<deviceCount;i++)
    {
        //装置地址 1个字节
        
        Byte address =*(Byte*)(self.userData + self.pos);
        [self.resultSet setValue:[NSNumber numberWithUnsignedChar:address]
                          forKey:[self getKeyString:self.key++]];
        self.pos+=1;
        
        
        //装置DWNAME  4个字节
        unsigned int deviceName =*(unsigned int*)(self.userData + self.pos);
        [self.resultSet setValue:[NSNumber numberWithUnsignedChar:deviceName]
                          forKey:[self getKeyString:self.key++]];
        self.pos+=4;
    }
}


@end
