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
    [self setTopNav];
//    [self setDefaultNavigationBackground];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        // TODO: 需要适配
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
    }


}

#define KBackgroundColor [UIColor colorWithHexString:@"a05a98"]

-(void)setTopNav
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        // iOS7
        // navigation bar color
        [self.navigationController.navigationBar setBarTintColor:KBackgroundColor];
        // navigation title color
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],
                                                                          UITextAttributeTextShadowColor: [UIColor clearColor]}];
        // bar button item color
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        
        //Default is NO on iOS 6 and earlier. Always YES if barStyle is set to UIBarStyleBlackTranslucent
        //所以会在IOS7产生黑色边，故在此设为NO
        [self.navigationController.navigationBar setTranslucent:NO];
        
        
    }
    else if ([self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)])
    {
        // iOS6
        // navigation bar color
        [self.navigationController.navigationBar setTintColor:KBackgroundColor];
        // navigation title color
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],
                                                                          UITextAttributeTextShadowColor: [UIColor clearColor]}];
    }
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
