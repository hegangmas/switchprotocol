//
//  XLSwitchAFNC.h
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import "XLSwitchBaseRequest.h"

@interface XLSwitchAFNC : XLSwitchBaseRequest


/*日期 分钟转换*/
-(NSDate*)dateMinuteTransitionWith:(unsigned int)second withStartData :(NSString*)datetime;   //绝对时间转换


@end
