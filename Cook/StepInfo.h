//
//  StepInfo.h
//  Cook
//
//  Created by chenlei on 13-11-13.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface StepInfo : NSManagedObject
@property (nonatomic, retain) NSString * introduction;
@property (nonatomic) NSNumber * sequence;
@property (nonatomic, retain) NSString * imagename;
@end
