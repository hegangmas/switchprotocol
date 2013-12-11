//
//  XLSwitchFrameData.h
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSwitchFrameData : NSObject

@property (nonatomic,retain) NSData *receivedData;

-(id)initWithData:(NSData*)recData;
-(void)parseUserData;

@end
