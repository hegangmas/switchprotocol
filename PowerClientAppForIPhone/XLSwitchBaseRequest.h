//
//  XLSwitchBaseRequest.h
//  PowerClientAppForIPhone
//
//  Created by JY on 13-12-4.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLSwitchBaseRequest : NSObject

@property(nonatomic,assign) Byte AFN;
@property(nonatomic,retain) NSString* funcCode;
@property(nonatomic,assign) Byte *userData;

@property(nonatomic,retain) NSMutableDictionary *resultSet;

@property(nonatomic,assign) NSInteger pos;
@property(nonatomic,assign) NSInteger userDataLength;
@property(nonatomic,assign) NSInteger key;

-(void)parseUserData;

-(void)sendResult;


-(NSString*)getKeyString:(int)key;

/*－－－－－－－－－－－－－－－－－
 BIN to NSString
 －－－－－－－－－－－－－－－－－*/
-(NSString*)binToStringWithBytes:(Byte*)bin
                        withblen:(NSInteger)bytesLength;

@end
