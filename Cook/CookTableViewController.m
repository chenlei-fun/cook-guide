//
//  CookTableViewController.m
//  Cook
//
//  Created by chenlei on 13-11-5.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import "CookTableViewController.h"
#import "CookDetails.h"


@interface CookTableViewController ()
@property (nonatomic, strong) UISearchBar * searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@end

@implementation CookTableViewController

@synthesize arrOfMenu;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContent];
}

-(void)saveContent{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if( managedObjectContext != nil){
        if( [managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(NSURL *)applicationDocumentDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext *)managedObjectContext{
    if(__managedObjectContext != nil){
        return __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if( coordinator != nil){
        __managedObjectContext = [[NSManagedObjectContext alloc]init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if( __managedObjectModel != nil){
        return __managedObjectModel;
    }
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    if(__persistentStoreCoordinator != nil){
        return __persistentStoreCoordinator;
    }
    NSURL * storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"TestApp6.sqlite"];
    
    NSError * error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if( ![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] ){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return __persistentStoreCoordinator;
}

- (void)insertCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    CookInfo * cookInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CookInfo" inManagedObjectContext:context];
    
    cookInfo.name = @"红烧肉";
    cookInfo.material = @"Hello";
    cookInfo.triedtimes = @"5";
    cookInfo.record = @"9.1";
    cookInfo.imagename = @"1";
    cookInfo.tips = @"tips";
    cookInfo.introduction = @"introduction";
    cookInfo.createdby = @"chenlei";
    
    NSMutableSet * materialInfos = [[NSMutableSet alloc] init];
    for (int i=0 ; i<5; i++) {
        MaterialInfo * materialInfo = [NSEntityDescription insertNewObjectForEntityForName:@"MaterialInfo" inManagedObjectContext:context];
        
        materialInfo.materialname = @"葱";
        materialInfo.sequence = [NSNumber numberWithInt:3];
        materialInfo.quantity = @"100克";
        
        [materialInfos addObject:materialInfo];
    }
    
    NSMutableSet * stepInfos = [[NSMutableSet alloc] init];
    for (int i=0 ; i<5; i++) {
        StepInfo * stepInfo = [NSEntityDescription insertNewObjectForEntityForName:@"StepInfo" inManagedObjectContext:context];
        
        stepInfo.introduction = @"先将葱姜蒜准备好！";
        stepInfo.sequence = [NSNumber numberWithInt:4];
        stepInfo.imagename = @"3";
        
        [stepInfos addObject:stepInfo];
    }
    
    NSError *error;
    if(![context save:&error]){
        NSLog(@"can not save %@", [error localizedDescription]);
    }
}

-(void)dataFeachRequest{
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CookInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    [arrOfMenu removeAllObjects];
    arrOfMenu = [[NSMutableArray alloc] init];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(CookInfo *info in fetchedObjects){
        [arrOfMenu addObject:info];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSBundle * bundle = [NSBundle mainBundle];
//    NSURL * plistURL = [bundle URLForResource:@"ProductList" withExtension:@"plist"];
//    NSMutableArray * array = [NSMutableArray arrayWithContentsOfURL:plistURL];
//    arrOfMenu = [[NSMutableArray alloc] initWithArray:array];
    
    [self dataFeachRequest];
    
    self.filterdArrOfMenu = [arrOfMenu mutableCopy];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = [UIColor blueColor];
    self.tableView.tableHeaderView = self.searchBar;
}

- (IBAction)addRecord:(id)sender {
    [self insertCoreData];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}

-(void)dealloc{
//    [dicOfMenu release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [self.searchBar text];
    
    [self updateFilteredArrayOfMenu:searchString];
    
    [self.tableView reloadData];
    
	[self.searchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    
    [self updateFilteredArrayOfMenu:@""];
    
    [self.tableView reloadData];

	[self.searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filterdArrOfMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CookInfo * info = (CookInfo *)[self.filterdArrOfMenu objectAtIndex:indexPath.row];
    
    UILabel * label;
    label = (UILabel *)[cell viewWithTag:2];
    label.text = info.name;
    
    label = (UILabel *)[cell viewWithTag:3];
    label.text = info.material;
    
    label = (UILabel *)[cell viewWithTag:4];
//    [NSString stringWithFormat:@"%d", indexPath.row];
    label.text = [NSString stringWithFormat:@"综合评分:%@",
                  info.record];
    
    label = (UILabel *)[cell viewWithTag:5];
    label.text = [NSString stringWithFormat:@"(%@人做过)",
                  info.triedtimes];
    
    NSString * imageName = info.imagename;
    NSString * imageUrlPath1 = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:imageUrlPath1];

    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = image1;
    
//    cell.imageView.image = image1;
    

    return cell;
}

- (void)updateFilteredArrayOfMenu:(NSString *)name{
    
    [self.filterdArrOfMenu removeAllObjects];
    
	if( name == nil || [name length] == 0 ){
        self.filterdArrOfMenu = [arrOfMenu mutableCopy];
    }
    else{
        for( CookInfo* info in arrOfMenu ){
            NSString * str = info.name;
            
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, str.length);
            NSRange foundRange = [str rangeOfString:name options:searchOptions range:productNameRange];
            if (foundRange.length > 0)
			{
				[self.filterdArrOfMenu addObject:info];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        CookInfo * info = (CookInfo *)[self.filterdArrOfMenu objectAtIndex:indexPath.row];

        [[segue destinationViewController] setDetailItem:info];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
