//
//  PersonalInformationViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PersonalInformationViewController.h"

@interface PersonalInformationViewController ()

@end

@implementation PersonalInformationViewController

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
    [self setNavigationTitle:@"个人信息"];
    [self setBackNavigationItemTitle:@"返回"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
