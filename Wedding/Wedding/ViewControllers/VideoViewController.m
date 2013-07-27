//
//  VideoViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-10.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *videoTableView;
@property (nonatomic,retain) NSMutableArray *vieoList;

@end

@implementation VideoViewController

#pragma mark getter

- (NSMutableArray *)vieoList
{
    
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
    [self setNavigationTitle:@"视频集"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.videoTableView = nil;
    [super dealloc];
}

@end
