//
//  XLSwitchAFN5.m
//  PowerClientAppForIPhone
//
//  Created by JYTest on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchAFN5.h"

@implementation XLSwitchAFN5

/*- - - - - - - - - - - -
 遥控预置
 - - - - - - - - - - - - */
-(void)F20
{
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //遥控开关号低字节高字节
    self.pos += 2;
    //遥控属性低字节
    NSInteger attributeLow = *(Byte*)(self.userData + self.pos);
    NSString *openOrClose = @"";
    switch (attributeLow) {
        case 0x05:
            openOrClose = @"合闸";
            break;
        case 0x06:
            openOrClose = @"分闸";
            break;
        default:
            break;
    }
    self.pos++;
    //遥控属性高字节
    NSInteger attributeHigh = *(Byte*)(self.userData + self.pos);
    NSString *rmtResult = @"";
    switch (attributeHigh) {
        case 0x00:
            rmtResult = @"遥控预置成功";
            break;
        case 0x01:
            rmtResult = @"点号非法";
            break;
        case 0x02:
            rmtResult = @"该点正在被操作";
            break;
        case 0x03:
            rmtResult = @"控制硬件有问题";
            break;
        default:
            break;
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"遥控属性：%@\r%@",openOrClose,rmtResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}

/*- - - - - - - - - - - -
 遥控执行
 - - - - - - - - - - - - */
-(void)F21
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //遥控开关号低字节高字节
    self.pos += 2;
    //遥控属性低字节
    NSInteger attributeLow = *(Byte*)(self.userData + self.pos);
    NSString *openOrClose = @"";
    switch (attributeLow) {
        case 0x05:
            openOrClose = @"合闸";
            break;
        case 0x06:
            openOrClose = @"分闸";
            break;
        default:
            break;
    }
    self.pos++;
    //遥控属性高字节
    NSInteger attributeHigh = *(Byte*)(self.userData + self.pos);
    NSString *rmtResult = @"";
    switch (attributeHigh) {
        case 0x00:
            rmtResult = @"遥控预置成功";
            break;
        case 0x01:
            rmtResult = @"点号非法";
            break;
        case 0x02:
            rmtResult = @"该点正在被操作";
            break;
        case 0x03:
            rmtResult = @"控制硬件有问题";
            break;
        default:
            break;
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"遥控属性：%@\r%@",openOrClose,rmtResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}


/*- - - - - - - - - - - -
 遥控撤消
 - - - - - - - - - - - - */
-(void)F22
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //遥控开关号低字节高字节
    self.pos += 2;
    //遥控属性低字节
    NSInteger attributeLow = *(Byte*)(self.userData + self.pos);
    NSString *openOrClose = @"";
    switch (attributeLow) {
        case 0x05:
            openOrClose = @"合闸";
            break;
        case 0x06:
            openOrClose = @"分闸";
            break;
        default:
            break;
    }
    self.pos++;
    //遥控属性高字节
    NSInteger attributeHigh = *(Byte*)(self.userData + self.pos);
    NSString *rmtResult = @"";
    switch (attributeHigh) {
        case 0x00:
            rmtResult = @"遥控预置成功";
            break;
        case 0x01:
            rmtResult = @"点号非法";
            break;
        case 0x02:
            rmtResult = @"该点正在被操作";
            break;
        case 0x03:
            rmtResult = @"控制硬件有问题";
            break;
        default:
            break;
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"遥控属性：%@\r%@",openOrClose,rmtResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}


/*- - - - - - - - - - - -
 故障远方复归
 - - - - - - - - - - - - */
-(void)F23
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
}



/*- - - - - - - - - - - -
 设置电池活化
 - - - - - - - - - - - - */
-(void)F27
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //活化标志
    NSInteger flag = *(Byte*)(self.userData + self.pos);
    NSString *flagResult =@"";
    switch (flag) {
        case 0:
            flagResult = @"无效";
            break;
        case 1:
            flagResult = @"立即活化";

            break;
        case 2:
            flagResult = @"停止活化";

            break;
        default:
            break;
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"活化标志：%@\r",flagResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}

/*- - - - - - - - - - - -
 远程退出命令
 - - - - - - - - - - - - */
-(void)F28
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
}

/*- - - - - - - - - - - -
 地址设置命令
 - - - - - - - - - - - - */
-(void)F29
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //装置地址
    NSInteger addr = *(Byte*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:addr]
                      forKey:[self getKeyString:self.key++]];
    self.pos++;
    //NET1地址
    NSString *net1String = @"NET1:";
    for(int i=0;i<4;i++)
    {
        NSInteger net1 = *(Byte*)(self.userData + self.pos);
        net1String = [net1String stringByAppendingString:[NSString stringWithFormat:@"%d ",net1]];
    }
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",net1String] forKey:[self getKeyString:self.key++]];
    self.pos += 4;
    //NET2地址
    NSString *net2String = @"NET1:";
    for(int i=0;i<4;i++)
    {
        NSInteger net2 = *(Byte*)(self.userData + self.pos);
        net2String = [net2String stringByAppendingString:[NSString stringWithFormat:@"%d ",net2]];
    }
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",net2String] forKey:[self getKeyString:self.key++]];
    self.pos += 4;
}

/*- - - - - - - - - - - -
 清除纪录命令
 - - - - - - - - - - - - */
-(void)F2B
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //纪录类型
    NSInteger type = *(Byte*)(self.userData + self.pos);
    NSString *typeResult =@"";
    for(int i=0;i<3;i++)
    {
        NSInteger flag;
        flag  = ((type>>i)&0x01);
        switch (i) {
            case 0:
                if(flag > 0)
                {
                    typeResult =  [typeResult stringByAppendingString:@" 事件纪录 "];
                }
                break;
            case 1:
                if(flag > 0)
                {
                    typeResult = [typeResult stringByAppendingString:@" 曲线纪录 "];
                }
                break;
            case 2:
                if(flag > 0)
                {
                    typeResult = [typeResult stringByAppendingString:@" SOE纪录 "];
                }
                break;
                
            default:
                break;
        }
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"纪录类型：%@\r",typeResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}

/*- - - - - - - - - - - -
 打开／关闭无线通讯模块电源
 - - - - - - - - - - - - */
-(void)F2C
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //开关标志
    NSInteger flag = *(Byte*)(self.userData + self.pos);
    NSString *flagResult =@"";
    
    switch (flag) {
        case 0:
            flagResult = @"无效";
            break;
        case 1:
            flagResult = @"开";
            break;
        case 2:
            flagResult = @"关";
            break;
            
        default:
            break;
    }
    self.pos++;
    NSString *result = [NSString stringWithFormat:@"开关标志：%@\r",flagResult];
    
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",result]
                      forKey:[self getKeyString:self.key++]];
    
}
/*- - - - - - - - - - - -
设置保护定值
 - - - - - - - - - - - - */
-(void)F2D{
    
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    self.pos += 4;
    
    NSInteger serial = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:serial]
                    forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
    
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    NSInteger count = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:count]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    
    for(int i = 0;i<count;i++){
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSString *value = [self protectionValue];
        [array addObject:[NSString stringWithFormat:@"%@",value]];
        
        [self.resultSet setValue:array forKey:[self getKeyString:self.key++]];
    }
    
}

/*- - - - - - - - - - - -
 GPRS地址设置命令
 - - - - - - - - - - - - */
-(void)F2E
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称低字节 设备名称
    self.pos += 2;
    //设备名称 设备名称高字节
    self.pos += 2;
    //装置地址
    NSInteger addr = *(Byte*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:addr]
                      forKey:[self getKeyString:self.key++]];
    self.pos++;
    //主IP地址
    NSString *net1String = @"主IP:";
    for(int i=0;i<4;i++)
    {
        NSInteger net1 = *(Byte*)(self.userData + self.pos);
        net1String = [net1String stringByAppendingString:[NSString stringWithFormat:@"%d ",net1]];
    }
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",net1String] forKey:[self getKeyString:self.key++]];
    
    self.pos += 4;
    //端口
    NSInteger port1 = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:port1]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
    //备IP地址
    NSString *net2String = @"备IP:";
    for(int i=0;i<4;i++)
    {
        NSInteger net2 = *(Byte*)(self.userData + self.pos);
        net2String = [net2String stringByAppendingString:[NSString stringWithFormat:@"%d ",net2]];
    }
    [self.resultSet setValue:[NSString stringWithFormat:@"%@",net2String] forKey:[self getKeyString:self.key++]];
    self.pos += 4;
    //端口
    NSInteger port2 = *(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:port2]
                      forKey:[self getKeyString:self.key++]];
    self.pos += 2;
}

-(NSString*)protectionValue
{
    NSString *valueResult=@"";
    NSString *typeDescribe = @"";
    NSString *typeOperate = @"";
    for(int i=0;i<8;i++)
    {
        NSInteger tmp = (((*(Byte*)(self.userData+self.pos))>>i)&0x01);
        if(tmp >0)
        {
            switch (i) {
                case 0:
                    typeDescribe = [typeDescribe stringByAppendingString:@"电压"];
                    break;
                case 1:
                    typeDescribe = [typeDescribe stringByAppendingString:@"电流"];
                    break;
                case 2:
                    typeDescribe = [typeDescribe stringByAppendingString:@"控制字"];
                    break;
                case 3:
                    typeDescribe = [typeDescribe stringByAppendingString:@"时间"];
                    break;
                case 4:
                    typeOperate = [typeOperate stringByAppendingString:@"可读"];
                    break;
                case 5:
                    typeOperate =  [typeOperate stringByAppendingString:@"可写"];
                    break;
                case 6:
                    typeOperate =  [typeOperate stringByAppendingString:@"隐藏"];
                    break;
                case 7:
                    break;
                
                default:
                    break;
            }
        }
        self.pos++;
        NSInteger decCount = *(Byte*)(self.userData+self.pos);
        self.pos++;
        float value = *(int*)(self.userData+self.pos);
        self.pos += 4;
        value = value/(pow(10, decCount));
        valueResult = [NSString stringWithFormat:@"参数类型：%@ 操作类型：%@ 定值：%f ",typeDescribe,typeOperate,value];
        return valueResult;
    }
    
    return valueResult;
    
}

/*设置压板定值*/
-(void)F26
{

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
    unsigned short pointCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:pointCount]
                      forKey:[self getKeyString:self.key++]];
    self.pos+=2;
    
    //压板值
    
    for(int i=0;i<pointCount;i++)
    {
        
        Byte plateValue =*(Byte*)(self.userData + self.pos);
        
        switch (plateValue) {
            case 0:
                [self.resultSet setValue:@"压板无效" forKey:[self getKeyString:self.key++]];
                break;
            case 0x01:
                [self.resultSet setValue:@"压板退出" forKey:[self getKeyString:self.key++]];
                break;
            case 0x81:
                [self.resultSet setValue:@"压板投入" forKey:[self getKeyString:self.key++]];
            default:
                [self.resultSet setValue:@"压板定值出错" forKey:[self getKeyString:self.key++]];
                break;
        }
        self.pos+=1;
    
    }
}



@end
