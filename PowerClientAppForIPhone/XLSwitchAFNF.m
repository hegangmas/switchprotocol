//
//  XLSwitchAFNF.m
//  PowerClientAppForIPhone
//
//  Created by admin on 13-12-6.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchAFNF.h"
//#import "XLSwitchAFNC.h"



@implementation XLSwitchAFNF


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
/*日期NSdate转换成NSString对象*/
-(NSString*)dateToStringWith:(NSDate*)datetime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    // NSDate *date=[formatter dateFromString:@"1970年1月1日"];
    NSString *date=[formatter stringFromDate: datetime];
    
    return date;
}


/*- - - - - - - - - - - -
读文件方法解析
 - - - - - - - - - - - - */

-(void)F30
{

    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    //设备名称 不解析
//    self.pos += 4;
//    //遥信偏移量
//    NSInteger offset = *(unsigned short*)(self.userData + self.pos);
//    
//    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:offset]
//                      forKey:[self getKeyString:self.key++]];
    
    //文件名称 64个字节  以\0为结束的字符串
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
   
    NSInteger len = strlen((char*)(self.userData + self.pos));
    
    NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
    NSString *fileName = [[NSString alloc] initWithData: data encoding:enc];
    [self.resultSet setValue:fileName forKey:[self getKeyString:self.key++]];
    
   // self.pos += len+1;
    self.pos+=64;
    
    
    
    
    
    //文件长度 4个字节
    NSInteger fileLen  =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:fileLen]
                      forKey:[self getKeyString:self.key++]];
    
    
    
    self.pos+=4;
    
    //读指针    4个字节
    NSInteger readPtr  =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=4;
    
    
    //本文件包的字节长度 2个字节
    unsigned short filePackLen  =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:filePackLen]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    
    //文件结束标志
    Byte endFlag  =*(Byte*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:endFlag]
                      forKey:[self getKeyString:self.key++]];

    self.pos+=1;
    
    //文件包的数据内容  需要完善
    {
        //将文件数据
//        [self writeDataToLocalFileWithFileName:@"ida.cfg"];
        NSData* fileData =[[NSData alloc] initWithBytes:self.userData + self.pos length:filePackLen];
        
        NSLog(@"%@",[fileData description]);
        [self.resultSet setValue:fileData
                          forKey:[self getKeyString:self.key++]];
    }

}
/*- - - - - - - - - - - -
 写文件方法解析
 - - - - - - - - - - - - */
-(void)F31
{
    //回的确认与否认帧
}
/*- - - - - - - - - - - -
 读目录回复报文接卸
 - - - - - - - - - - - - */
-(void)F32
{
    
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    
    
    //文件名称 64个字节  以\0为结束的字符串
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSInteger len = strlen((char*)(self.userData + self.pos));
    
    NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
    NSString *fileName = [[NSString alloc] initWithData: data encoding:enc];
    [self.resultSet setValue:fileName forKey:[self getKeyString:self.key++]];
    
    // self.pos += len+1;
    self.pos+=64;
    
    //读指针
    
    unsigned short readPtr  =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:readPtr]
                      forKey:[self getKeyString:self.key++]];
    
    self.pos+=2;
    
    //本帧发送的目录条目数
    unsigned short catalogCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:catalogCount]
                      forKey:[self getKeyString:self.key++]];
    
    
    
    self.pos+=2;
    
    //目录条目总数
    unsigned short totalCount =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:totalCount]
                      forKey:[self getKeyString:self.key++]];
    
    
    
    
    self.pos+=2;
    
    //读取目录的数据内容
    //将本帧发送的目录个数写入到字典中
    for(int i =0;i<catalogCount;i++)
    {
    
        //条目1的目录／文件名称 64
        
        NSInteger len = strlen((char*)(self.userData + self.pos));
        
        NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
        NSString *catalogName = [[NSString alloc] initWithData: data encoding:enc];
        [self.resultSet setValue:catalogName forKey:[self getKeyString:self.key++]];
        
        // self.pos += len+1;
        self.pos+=64;

        //条目1的目录／文件大小  4个字节
        unsigned int fileSize =*(unsigned int*)(self.userData + self.pos);
        [self.resultSet setValue:[NSNumber numberWithUnsignedChar:fileSize]
                          forKey:[self getKeyString:self.key++]];
        
        
        
        self.pos+=4;
        
        //条目1的目录／文件属性 4个字节
        unsigned int fileAttribute =*(unsigned int*)(self.userData + self.pos);
        
        switch(fileAttribute)
        {
            case 0x4000:
                        [self.resultSet setValue:@"文件属性:目录" forKey:[self getKeyString:self.key++]];
                break;
        
                default:
                 [self.resultSet setValue:@"文件属性:文件" forKey:[self getKeyString:self.key++]];
                break;
        }
        
        
        self.pos+=4;
        //条目1的目录／文件创建时间 4个字节  将绝对时间转换成系统时间
        
        unsigned int fileCreateTime =*(unsigned int*)(self.userData + self.pos);
        //将绝对时间进行转换
        NSDate* date= [self dateMinuteTransitionWith:fileCreateTime withStartData:@"1970年1月1日0时0分"];

        NSString *dateString = [self dateToStringWith:date];
        //将时间写入字典中
        [self.resultSet setValue:dateString forKey:[self getKeyString:self.key++]];
        
        self.pos+=4;
    }
    
}
/*- - - - - - - - - - - -
 读取文件状态回复报文解析
 - - - - - - - - - - - - */
-(void)F37
{
    
    //回复文件状态或Nack报文
    NSLog(@"执行方法:%s",__func__);
    
    self.resultSet = nil;
    self.resultSet = [[NSMutableDictionary alloc] init];
    
    
    
    //文件名称 64个字节  以\0为结束的字符串
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSInteger len = strlen((char*)(self.userData + self.pos));
    
    NSData   *data = [NSData dataWithBytes:(self.userData + self.pos) length:len];
    NSString *fileName = [[NSString alloc] initWithData: data encoding:enc];
    [self.resultSet setValue:fileName forKey:[self getKeyString:self.key++]];
    
    // self.pos += len+1;
    self.pos+=64;
    
    
    
    //文件大小  4个字节
    unsigned int fileSize =*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:fileSize]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=4;
    
    //文件属性 4个字节
    unsigned int fileAttribute =*(unsigned int*)(self.userData + self.pos);
    
    switch(fileAttribute)
    {
        case 0x4000:
            [self.resultSet setValue:@"文件属性:目录" forKey:[self getKeyString:self.key++]];
            break;
            
        default:
            [self.resultSet setValue:@"文件属性:文件" forKey:[self getKeyString:self.key++]];
            break;
    }
    
    self.pos+=4;
    
    //文件创建时间 4
    
    unsigned int fileCreateTime =*(unsigned int*)(self.userData + self.pos);
    //将绝对时间进行转换
    NSDate* date= [self dateMinuteTransitionWith:fileCreateTime withStartData:@"1970年1月1日0时0分"];
    NSString *dateString = [self dateToStringWith:date];
    //将时间写入字典中
    [self.resultSet setValue:dateString forKey:[self getKeyString:self.key++]];
    
    self.pos+=4;
    
    //文件校验码 2
    unsigned short fileCrc  =*(unsigned short*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:fileCrc]
                      forKey:[self getKeyString:self.key++]];
    
    
    self.pos+=2;
    
    //临时文件大小 4
    unsigned int tempFileSize=*(unsigned int*)(self.userData + self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:tempFileSize]
                      forKey:[self getKeyString:self.key++]];

    
    self.pos+=4;
    //临时文件属性 4
    unsigned int tempFileAttribute=*(unsigned int*)(self.userData + self.pos);
//    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:tempFileSize]
//                      forKey:[self getKeyString:self.key++]];
    switch(tempFileAttribute)
    {
    
        case 0x4000:
            [self.resultSet setValue:@"临时文件属性:目录" forKey:[self getKeyString:self.key++]];
            break;
            
        default:
            [self.resultSet setValue:@"临时文件属性:文件" forKey:[self getKeyString:self.key++]];
            break;
    }
    self.pos+=4;
    //临时文件创建时间 4
    
    unsigned int tempFileCreatTime =*(unsigned int*)(self.userData+self.pos);
    
    //将时间进行转换
    NSDate* tempFileDate= [self dateMinuteTransitionWith:tempFileCreatTime withStartData:@"1970年1月1日0时0分"];
    NSString *tempFiledateString = [self dateToStringWith:tempFileDate];
    //将时间写入字典中
    [self.resultSet setValue:tempFiledateString forKey:[self getKeyString:self.key++]];
    
    self.pos+=4;

    //临时文件校验码 2个字节
    unsigned short tempFileCrc =*(unsigned short*)(self.userData+self.pos);
    [self.resultSet setValue:[NSNumber numberWithUnsignedChar:tempFileCrc]
                         forKey:[self getKeyString:self.key++]];
    self.pos+=2;
}

/*- - - - - - - - - - - -
 创建目录、文件改名、目录改名
 修改文件属性的报文回复的都是确认／否认报文帧
 - - - - - - - - - - - - */


/*- - - - - - - - - - - -
 删除文件、删除目录回复的报文都是确认／否认报文帧
 - - - - - - - - - - - - */


/*- - - - - - - - - - - -
 读取配置文件数据，并转换成字节序列
 - - - - - - - - - - - - */
-(void)readDataFromFileWithFileName:(NSString*)fileName
{
    //读取本地配置文件信息

}
/*- - - - - - - - - - - -
 将从中断获取的配置文件信息写入文件中
 - - - - - - - - - - - - */
-(void)writeDataToLocalFileWithFileName:(NSString*)fileName
{
    
    
    
    
    
    
    
    
    
    
    
    
}


@end
