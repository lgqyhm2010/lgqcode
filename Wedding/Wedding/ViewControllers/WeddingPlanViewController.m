//
//  WeddingPlanViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-8-2.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WeddingPlanViewController.h"

@interface WeddingPlanViewController ()

@property (nonatomic,retain) UIImageView *backContent;

@end

@implementation WeddingPlanViewController

- (UIImageView *)backContent
{
    if (!_backContent) {
        _backContent = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame)-44)];
        _backContent.image = [UIImage imageNamed:@"about_content_bg"];
    }
    return _backContent;
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
    [self setNavigationTitle:@"婚庆策划"];
    [self setBackNavigationItemTitle:@"返回"];
    
    [self.view addSubview:self.backContent];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
