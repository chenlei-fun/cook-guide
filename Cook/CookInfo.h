//
//  CookInfo.h
//  Cook
//
//  Created by chenlei on 13-11-12.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CookInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * material;
@property (nonatomic, retain) NSString * record;
@property (nonatomic, retain) NSString * triedtimes;
@property (nonatomic, retain) NSString * imagename;
@property (nonatomic, retain) NSString * introduction;
@property (nonatomic, retain) NSString * createdby;
@property (nonatomic, retain) NSString * tips;
@property (nonatomic, retain) NSMutableSet * materialInfos;
@property (nonatomic, retain) NSMutableSet * stepInfos;

@end
