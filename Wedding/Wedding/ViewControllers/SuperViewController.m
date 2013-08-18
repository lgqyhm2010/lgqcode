//
//  SuperViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-8.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SuperViewController.h"
#import "UIViewController+Additions.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self addBackImgView];
    [self setDefaultNavigationBackground];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setDefaultBackClick:(SEL)back
{
    SEL backClick = back?back:@selector(backClick);
    [self setNavigationItemNormalImage:@"back_icon_normal.png" HightImage:@"back_icon_pressed.png" selector:backClick isRight:NO];
}

@end
