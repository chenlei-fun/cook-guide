//
//  CookTableViewController.h
//  Cook
//
//  Created by chenlei on 13-11-5.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookInfo.h"
#import "MaterialInfo.h"
#import "StepInfo.h"


//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;
@interface CookTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, retain) NSMutableArray * arrOfMenu;
@property (nonatomic, retain) NSMutableArray * filterdArrOfMenu;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void) saveContent;
-(NSURL *)applicationDocumentDirectory;

@end




