//
//  UIViewController+Additions.h
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

-(void)presentModalViewControllerMy:(UIViewController *)modalViewController animated:(BOOL)animated;
-(void)dismissModalViewControllerAnimatedMy:(BOOL)animated;
-(void)setRightNavigationItemTitle:(NSString*)title selector:(SEL)selector;
-(void)setLeftNavigationItemTitle:(NSString*)title selector:(SEL)selector;
-(void)setNavigationTitle:(NSString *)title withColor:(UIColor *)color;
-(void)setNavigationTitle:(NSString *)title ;

-(void)setLeftNavigationItemImage:(NSString*)imageName selector:(SEL)selector ;
-(void)setRightNavigationItemImage:(NSString*)imageName target:(id)targer selector:(SEL)selector ;
-(void)setBackNavigationItemTitle:(NSString*)title selector:(SEL)selector;
-(void)setBackNavigationItemTitle:(NSString*)title ;

- (void)setNavigationBackgroundImage:(NSString*)image ;
-(void)setDefaultNavigationBackground ;
-(void)addBackImgView;

//弹窗
-(void)showPromptView:(NSString*)tipStr;
@end
