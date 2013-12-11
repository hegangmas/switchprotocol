//
//  XLSwitchFrameData.m
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchFrameData.h"
#import "XLSwitchBaseRequest.h"

//帧起始符
#define FRAME_START_BYTE 0x68
//帧结束符
#define FRAME_END_BYTE   0x16


@interface XLSwitchFrameData()
{
    int                frameLength;     //帧总长
    Byte              *frameData;       //帧数据
    
    int                userDataLength;  //用户数据长度
    
    XLSwitchBaseRequest *baseRequest;
}

-(unsigned short)getCheckSum:(Byte *)userData :(int)length;     //获取校验和

-(int) parseUserDataLength;                           //解析用户数据长度

-(void) parseFuncCode;

-(BOOL)frameCheck;                                    //帧检查

-(void)initBaseRequest;

-(NSString*)getHexString:(Byte)byte;

@end

@implementation XLSwitchFrameData

@synthesize receivedData;

/*－－－－－－－－－－－－－－－－－
 初始化
 －－－－－－－－－－－－－－－－－*/
-(id)initWithData:(NSData*)recData
{
    if (self=[super init]) {
        
        self.receivedData = recData;
        
        frameLength =  [self.receivedData length];
        
        frameData   =   malloc(frameLength);
        
        memcpy(frameData, (Byte*)[self.receivedData bytes],
               frameLength);
    }
    return self;
}

/*－－－－－－－－－－－－－－－－－
 帧检查
 －－－－－－－－－－－－－－－－－*/
-(BOOL)frameCheck
{
    if ([self.receivedData length]!=0) {
        
        userDataLength = [self parseUserDataLength];
        
        if (userDataLength == -1) {
            return NO;
        }
        /*检查起始位结束位*/
        if ( *(frameData)               != FRAME_START_BYTE ||
            *(frameData+5)             != FRAME_START_BYTE ||
            *(frameData+frameLength-1) != FRAME_END_BYTE) {
            
            NSLog(@"开始位结束位检查出错");
            return NO;
        }
        
        if (frameLength!=userDataLength+9) {
            NSLog(@"长度检查出错");
            return NO;
        }
        
        /*检查帧校验和*/
        if ([self getCheckSum:frameData + 6 :userDataLength]
            != *(unsigned short*)(frameData+frameLength-3)) {
            NSLog(@"校验和检查出错");
            return NO;
        }
    } else {
        return NO;
    }
    
    return YES;
}

/*－－－－－－－－－－－－－－－－－
 获取校验和
 －－－－－－－－－－－－－－－－－*/
-(unsigned short)getCheckSum:(Byte *)userData :(int)length
{
    Byte *pos = userData;
    unsigned short total = 0;
    
    for ( int i =0; i<length; ++i)
    {
        total += *pos;
        ++pos;
    }
    
    //    NSLog(@"校验和%2x",total);
    return total;
}


/*－－－－－－－－－－－－－－－－－
 解析用户数据长度
 －－－－－－－－－－－－－－－－－*/
-(int)parseUserDataLength
{
    unsigned short* lengthField = (unsigned short*)(frameData+1);
    
    return (*lengthField);
}

-(void)parseFuncCode{
    baseRequest.funcCode = [self getHexString:*(Byte*)(frameData + 8)];
}

-(void)initBaseRequest{
    
    baseRequest.userDataLength = userDataLength;
    [self parseFuncCode];
    
    
    baseRequest.userData = malloc(userDataLength - 3);
    memcpy(baseRequest.userData,(Byte*)(frameData + 9),userDataLength - 3);
    
    free(frameData);
}


/*－－－－－－－－－－－－－－－－－
 HEX 4 Class Name
 －－－－－－－－－－－－－－－－－*/
-(NSString*)getHexString:(Byte)byte
{
    return [[NSString stringWithFormat:@"%x",byte] uppercaseString];
}


#pragma mark - frames hand out
/*－－－－－－－－－－－－－－－－－
 PARSE
 －－－－－－－－－－－－－－－－－*/
-(void)parseUserData
{
    if (![self frameCheck]) {
        return;
    }
    
    NSString *afnClass = [NSString stringWithFormat:@"%@%@",
                          NSLocalizedString(@"CLASS_PREFIX", nil),
                          [self getHexString:*(Byte*)(frameData + 7) & 0x0f]];
    
    baseRequest = [[NSClassFromString(afnClass) alloc] init];
    
    [self initBaseRequest];
    
    [baseRequest parseUserData];
}

@end
