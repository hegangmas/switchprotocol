//
//  XLSwitchBaseRequest.m
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchBaseRequest.h"

@implementation XLSwitchBaseRequest

/*－－－－－－－－－－－－－－－－－
 初始化数据集
 －－－－－－－－－－－－－－－－－*/
-(id)init
{
    if (self = [super init]) {
        
        NSLog(@"解析类: %@",[self class]);
        
        self.pos = 0;
        
        self.resultSet = [[NSMutableDictionary alloc] init];
        
//        self.setting = [XLSettingsManager sharedXLSettingsManager];
//        
//        self.notifyName  = [NSString stringWithFormat:@"%@NotificationFor%@",
//                            [self class],
//                            self.setting.notifyPrefix];
        
    }
    return self;
}

dispatch_queue_t   queue;
dispatch_group_t   group;

-(void)parseUserData{
    SEL       fnMethod;
    group = dispatch_group_create();
    queue = dispatch_queue_create("COM.XLCOMBINE.QUEUE", DISPATCH_QUEUE_SERIAL);
 
    fnMethod =  NSSelectorFromString([NSString stringWithFormat:@"F%@",self.funcCode]);
    
    //方法block
    dispatch_block_t _block = ^(void){
        
        //            if(!self.setting.cancelSend){
#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Warc-performSelector-leaks"
        [self performSelector:fnMethod];
#pragma clang diagnostic pop
        //            }
    };
    
    dispatch_group_async(group, queue, _block);
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    [self sendResult];
}

#pragma mark -send
/*－－－－－－－－－－－－－－－－－
 POST DATA
 －－－－－－－－－－－－－－－－－*/
-(void)performNotificationWith:(NSString*)notifyNames
                    withObject:(NSObject*)objc
                    withResult:(NSDictionary*)resultDic{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyNames
                                                        object:objc
                                                      userInfo:resultDic];
    NSLog(@"发出通知:%@",notifyNames);
}

/*－－－－－－－－－－－－－－－－－
 Send
 －－－－－－－－－－－－－－－－－*/
-(void)sendResult{
//    if (!self.setting.cancelSend) {
        [self performNotificationWith:@"test"
                           withObject:nil
                           withResult:self.resultSet];
//    }
}


-(NSString*)getKeyString:(int)key
{
    return [NSString stringWithFormat:@"%d",key];
}


/*－－－－－－－－－－－－－－－－－
 BIN to NSString
 －－－－－－－－－－－－－－－－－*/
-(NSString*)binToStringWithBytes:(Byte*)bin
                        withblen:(NSInteger)bytesLength{
    
    NSString *result = @"";
    NSString *temp;
    for(int i = 0; i < bytesLength; i++){
        
        temp = [NSString stringWithFormat:@"%d", *(Byte*)(bin + i)];
        
        result = [result stringByAppendingString:temp];
        
        if (i!=bytesLength-1) {
            result = [result stringByAppendingString:@":"];
        }
    }
    return result;
}


@end
