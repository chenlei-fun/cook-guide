//
//  MaterialInfo.h
//  Cook
//
//  Created by chenlei on 13-11-13.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MaterialInfo : NSManagedObject
@property (nonatomic, retain) NSString * materialname;
@property (nonatomic) NSNumber * sequence;
@property (nonatomic, retain) NSString * quantity;
@end
