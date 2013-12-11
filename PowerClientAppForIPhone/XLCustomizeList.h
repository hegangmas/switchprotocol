//
//  XLCustomizeList.h
//  PowerClientAppForIPhone
//
//  Created by JY on 13-11-21.
//  Copyright (c) 2013年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XLCustomizeList : NSManagedObject

@property (nonatomic, retain) NSString * functionId;
@property (nonatomic, retain) NSNumber * afnCode;
@property (nonatomic, retain) NSString * fnCode;
@property (nonatomic, retain) NSNumber * pos;

@end
