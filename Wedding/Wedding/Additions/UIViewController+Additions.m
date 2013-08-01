//
//  UIViewController+Additions.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "UIViewController+Additions.h"
#import "UINavigationBar+Additions.h"

@interface NSObject (MethodExchange)
+(void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel;
@end

#import <objc/runtime.h>

@implementation NSObject (MethodExchange)

+(void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel{
    Class class = [self class];
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    if (!origMethod){
        origMethod = class_getClassMethod(class, origSel);
    }
    if (!origMethod)
        @throw [NSException exceptionWithName:@"Original method not found" reason:nil userInfo:nil];
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!newMethod){
        newMethod = class_getClassMethod(class, newSel);
    }
    if (!newMethod)
        @throw [NSException exceptionWithName:@"New method not found" reason:nil userInfo:nil];
    if (origMethod==newMethod)
        @throw [NSException exceptionWithName:@"Methods are the same" reason:nil userInfo:nil];
    method_exchangeImplementations(origMethod, newMethod);
}

@end

#define KTitleViewHeight 44

@implementation UIViewController (Additions)

#pragma mark -

-(UIBarButtonItem*)allocBarButtonItem:(NSString*)title selector:(SEL)selector selImg:(NSString*)selImg unselImg:(NSString*)unselImg {
    
    CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:14]
                        constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                            lineBreakMode:UILineBreakModeWordWrap];
	
	UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width+20, 32)];
	[btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	[btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
	[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[btn setTitle:title forState:UIControlStateNormal];
    
	UIImage *navBtn=nil;
	UIImage *navBtnSelect=nil;
    
    if (textSize.width>30) {
		navBtn=[[UIImage imageNamed:unselImg] stretchableImageWithLeftCapWidth:30.0f topCapHeight:20.0f];
		navBtnSelect=[[UIImage imageNamed:selImg] stretchableImageWithLeftCapWidth:30.0f topCapHeight:20.0f];//48.0f
	}else {
		navBtn=[UIImage imageNamed:unselImg];
		navBtnSelect=[UIImage imageNamed:selImg];//48.0f
	}
    
	[btn setBackgroundImage:navBtn forState:UIControlStateNormal];
	[btn setBackgroundImage:navBtnSelect forState:UIControlStateHighlighted];
	UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
	[btn release];
    return btnItem;
}

#pragma mark - Navigation
//设置右Navigation的文字
//该设置会自动添加固定的背景图片
-(void)setRightNavigationItemTitle:(NSString*)title selector:(SEL)selector
{
    UIBarButtonItem *item = [self allocBarButtonItem:title selector:selector selImg:@"blue_selected.png" unselImg:@"blue_unselected.png"];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
}
//设置左Navigation的文字
//该设置会自动添加固定的背景图片
-(void)setLeftNavigationItemTitle:(NSString*)title selector:(SEL)selector
{
    UIBarButtonItem *item = [self allocBarButtonItem:title selector:selector selImg:@"blue_selected" unselImg:@"blue_unselected"];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
}


-(void)setNavigationTitle:(NSString *)title {
    [self setNavigationTitle:title withColor:nil];
}
//设置标题
-(void)setNavigationTitle:(NSString *)title withColor:(UIColor *)color
{
    UIFont *font = [UIFont boldSystemFontOfSize:20];
	if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
		CGSize textSize = [title sizeWithFont:font
                            constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                lineBreakMode:UILineBreakModeWordWrap];
		CGSize size=self.navigationController.navigationBar.frame.size;
		UILabel *tempLbl=(UILabel*)self.navigationItem.titleView;
        tempLbl.textColor=[UIColor whiteColor];
		tempLbl.text=title;
		
		tempLbl.frame=CGRectMake(0, 0, textSize.width, KTitleViewHeight);
		tempLbl.center=CGPointMake(size.width/2.0, size.height/2.0);
		
		
	}else {
		CGSize textSize = [title sizeWithFont:font];
		
		UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, KTitleViewHeight)];//320
		CGSize size=self.navigationController.navigationBar.frame.size;
		lbl.center=CGPointMake(size.width/2.0, size.height/2.0);
		lbl.textColor=[UIColor whiteColor];
		[lbl setFont:font];
		[lbl setText:title];
		lbl.textAlignment=UITextAlignmentCenter;
		lbl.backgroundColor=[UIColor clearColor];
		self.navigationItem.titleView=lbl;
		[lbl release];
	}
}


//设置左NavigationItem的图片
//该设置会自动添加固定的背景图片
-(void)setLeftNavigationItemImage:(NSString*)imageName selector:(SEL)selector {
    
    UIImage *image = imageName.length ?[UIImage imageNamed:imageName] : nil;
	UIButton *leftButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 32)];
	[leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0,8,0,8);
	[leftButton setBackgroundImage:[UIImage imageNamed:@"blue_unselected.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"blue_selected.png"] forState:UIControlStateHighlighted];
	[leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setImage:image forState:UIControlStateHighlighted];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
	[leftButton release];
	[leftButtonItem release];
    
}

-(void)setNavigationItemNormalImage:(NSString*)imageName HightImage:(NSString *)hightImageName selector:(SEL)selector isRight:(BOOL)right
{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
	button.frame=CGRectMake(0, 0, 40, 26);
    button.imageEdgeInsets=UIEdgeInsetsMake(0,8,0,8);
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (right) {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }else
        self.navigationItem.leftBarButtonItem = buttonItem;
	[buttonItem release];

}

//设置左NavigationItem的图片
//该设置会自动添加固定的背景图片
-(void)setRightNavigationItemImage:(NSString*)imageName target:(id)targer selector:(SEL)selector {
    
    UIImage *image = imageName.length ?[UIImage imageNamed:imageName] : nil;
    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
	rightButton.frame=CGRectMake(0, 0, 48, 32);
    rightButton.imageEdgeInsets=UIEdgeInsetsMake(0,8,0,8);
	[rightButton addTarget:targer action:selector forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"blue_selected.png"] forState:UIControlStateHighlighted];
    //[rightButton  setCurHightedImage:[UIImage imageNamed:@"blue_selected.png"]  withFrame:CGRectMake(-3.0f, -9.0f,50.0f , 50.0f)];
	[rightButton setBackgroundImage:[UIImage imageNamed:@"blue_unselected.png"] forState:UIControlStateNormal];
	[rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setImage:image forState:UIControlStateHighlighted];
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	self.navigationItem.rightBarButtonItem = rightButtonItem;
	self.navigationItem.rightBarButtonItem.width=48;
	[rightButtonItem release];
}

//设置返回按钮的title
-(void)setBackNavigationItemTitle:(NSString*)title selector:(SEL)selector {
    
    
    NSString *leftTitle = title;
    if ([leftTitle length] == 0) {
        leftTitle = @"返回";
    }
    leftTitle = leftTitle.length > 5 ? [NSString stringWithFormat:@"%@..." ,[leftTitle substringToIndex:5]] : leftTitle;
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    CGSize size  = [leftTitle sizeWithFont:font];
    UIImage *norImage = [UIImage imageNamed:@"back_unselected.png"];
    norImage = [norImage stretchableImageWithLeftCapWidth:[norImage size].width/2 topCapHeight:[norImage size].height/2];
    UIImage *selImage = [UIImage imageNamed:@"back_selected.png"];
    selImage = [selImage stretchableImageWithLeftCapWidth:[norImage size].width/2 topCapHeight:[norImage size].height/2];
    
    CGFloat width = size.width + 20;
    width = width > 48 ? width : 48;
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    leftButton.titleLabel.font = font;
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setBackgroundImage:norImage forState:UIControlStateNormal];
    [leftButton setBackgroundImage:selImage forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftButton release];
    [leftItem release];
}

-(void)setBackNavigationItemTitle:(NSString*)title {
    [self setBackNavigationItemTitle:title selector:@selector(backMethod)];
}

- (void)backMethod {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setNavigationBackgroundImage:(NSString*)image {
    if (!image.length) image = @"topNav_bg.png";
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=50000
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:image] forBarMetrics:UIBarMetricsDefault];
        
        UIView *tempView=nil;
        for (UIView *img in [self.navigationController.navigationBar subviews]) {
            if([img isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]||[img isKindOfClass:NSClassFromString(@"UINavigationBarBackground")])
                
            {
                tempView.autoresizesSubviews=NO;
                tempView=img;
                //tempView.hidden=YES;
                //   NSLog(@"%@-----",img);
            }
        }
        
        if(tempView!=nil)
        {
            tempView.frame=CGRectMake(0,0,320,44);
            tempView.hidden=YES;
        }
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:image]];
        
#endif
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:image]];
    }
}

-(void)presentModalViewControllerMy:(UIViewController *)modalViewController animated:(BOOL)animated
{
    //    NSLog(@"self %@",self);
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=60000
        
[self presentViewController:modalViewController animated:animated completion:Nil];
           
    
#else
    [self presentModalViewController:modalViewController animated:animated];
    
#endif
    
    
}

-(void)dismissModalViewControllerAnimatedMy:(BOOL)animated
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=60000
        
    [self dismissViewControllerAnimated:animated completion:Nil];
 #else
    [self dismissModalViewControllerAnimated:animated];
#endif
    
}

-(void)setDefaultNavigationBackground {
    [self setNavigationBackgroundImage:@"topNav_bg.png"];
}

//by lgq add
#pragma backgroudView
-(void)addBackImgView
{
    
    //    UIScreen *screen = [UIScreen mainScreen];
    //    if (CGRectGetHeight(screen.bounds) > 480) {
    //        self.view.backgroundColor = [UIColor colorWithWhite:(CGFloat)250/255 alpha:1.0];
    //        return;
    //    }
    //
    //        UIImage *img1=nil;
    //        img1=[UIImage imageNamed:@"background.png"];
    //        UIImageView *img=[[UIImageView alloc] initWithImage:img1];
    //        img.frame=CGRectMake(0, 0, 320, 460);
    //        [self.view addSubview:img];
    //        //[self.view bringSubviewToFront:img];
    //        [self.view sendSubviewToBack:img];
    self.view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
  	
}

-(void)showPromptView:(NSString*)tipStr {
    [Notification showWaitViewInView:self.view animation:YES withText:tipStr withDuration:1.0 hideWhenFinish:YES showIndicator:NO];
    //[Notification showWaitViewInView:self.view text:tipStr animation:YES];
}

@end
