//
//  CookDetails.m
//  Cook
//
//  Created by chenlei on 13-11-13.
//  Copyright (c) 2013年 chenlei. All rights reserved.
//

#import "CookDetails.h"
#import "CookInfo.h"


@interface CookDetails ()
@property (weak, nonatomic) IBOutlet UILabel *lblText;
- (void)setDetailItem:(id)newDetailItem;
@end

@implementation CookDetails

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.lblText.text = @"Hello baby";
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
