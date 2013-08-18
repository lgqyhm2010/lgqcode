//
//  MCNotification.m
//  CaiYun
//
//  Created by penghanbin on 12-11-8.
//
//

#import "MCNotification.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration            1.6
#define kTransitionDuration  0.28

#define WAIT_VIEW_MIN_HEIGHT           93.0f

typedef void (^MCNotificationCompletionBlock)(void);

@interface WaitView : UIImageView

@property (nonatomic,assign) id delegate;

@end

@implementation WaitView

- (id)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchesEnded:withEvent:)]) {
//        [self.delegate touchesEnded:touches withEvent:event];
    }
}

@end

@interface MCNotification()
@property (nonatomic,assign) UIWindow *window;
@property (nonatomic,retain) WaitView *waitView;
@property (nonatomic,retain) UILabel *tipsLabel;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic,retain) UIView *view;
@property (nonatomic,assign) BOOL hideWhenFinish;

@end

@implementation MCNotification
@synthesize window = _window;
@synthesize waitView = _waitView;
@synthesize tipsLabel = _tipsLabel;
@synthesize indicatorView = _indicatorView;
@synthesize view = _view;


#pragma mark - getter and setter
- (UIWindow*)window {
    if (!_window) {
        _window = [AppDelegate window];
    }
    return _window;
}

- (UILabel*)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 54, 185.0f, 20)];
		_tipsLabel.font=[UIFont fontWithName:KFontDefault size:15];
		_tipsLabel.textAlignment=UITextAlignmentCenter;
		_tipsLabel.backgroundColor=[UIColor clearColor];
		_tipsLabel.textColor=[UIColor whiteColor];
		_tipsLabel.text=@"请稍候...";
    }
    return _tipsLabel;
}

- (UIActivityIndicatorView*)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)];
        _indicatorView.center=CGPointMake(93.5, 32.0f);
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}


- (WaitView*)waitView {
    if (!_waitView) {
        _waitView=[[WaitView alloc] init];
        _waitView.userInteractionEnabled = YES;
        _waitView.backgroundColor = [UIColor colorWithWhite:(CGFloat)42/255 alpha:1.0];
//        [_waitView setImage:[UIImage imageNamed:@"loading_bg.png"]];
        _waitView.layer.masksToBounds = YES;
        _waitView.layer.cornerRadius = 10;
		_waitView.hidden=YES;
		_waitView.frame=CGRectMake(0, 0, 185.0f, 93.0f);
		CGPoint point=CGPointMake(self.window.center.x, self.window.center.y);
		_waitView.center=point;
        _waitView.delegate = self;
        [_waitView addSubview:self.indicatorView];
        [_waitView addSubview:self.tipsLabel];
    }
    return _waitView;
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.hideWhenFinish) [self removeWaitViewByThread];
}

#pragma mark - hide method

- (void)removeWaitViewByThread {
    @autoreleasepool {
        self.view = self.view ? self.view : self.window;
        self.view.userInteractionEnabled=YES;
        [self.waitView stopAnimating];
        [self.waitView removeFromSuperview];
    }
}

- (void)removeWaitView {
    [self performSelectorOnMainThread:@selector(removeWaitViewByThread) withObject:nil waitUntilDone:NO];
}

-(void)hiddenWaitView:(BOOL)animated {
    
	if (animated) {
		self.waitView.alpha = 1;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(removeWaitView)];
		self.waitView.alpha = 0;
		[UIView commitAnimations];
	} else {
        [self removeWaitView];
	}
}


- (void)hiddenWaitView:(BOOL)animated completion:(void(^)(void))completion {
    
    __block MCNotification *tmp = self;
    void (^animations)(void) = ^(void) {
        [tmp hiddenWaitView:animated];
    };
    
    void (^comp)(BOOL finish) = ^(BOOL finish) {
        if (completion) {
            completion();
        }
    };
    
    [UIView animateWithDuration:kTransitionDuration animations:animations completion:comp];
}

- (void)hiddenWaitViewByThread {
    [self hiddenWaitView:YES];
}


#pragma mark show method
- (void)showWaitViewInViewWithoutIndicator:(UIView*)view text:(NSString*)text animation:(BOOL)animation hideWithAnimated:(BOOL)hideWithAnimated {
    [self showWaitViewInView:view
                   animation:animation
                    withText:text
                withDuration:kDuration
              hideWhenFinish:hideWithAnimated
               showIndicator:NO];
}
- (void)showWaitViewInViewWithoutIndicator:(UIView*)view text:(NSString*)text animation:(BOOL)animation hideWithAnimated:(BOOL)hideWithAnimated completion:(void(^)(void))completion {
    [self showWaitViewInView:view animation:animation withText:text withDuration:kDuration hideWhenFinish:hideWithAnimated showIndicator:noErr completion:completion];
}


- (void)showWaitView:(NSString*)text animation:(BOOL)animation hideWhenAnimated:(BOOL)hideWithAnimated {
    [self showWaitViewInView:self.window
                   animation:animation
                    withText:text
                withDuration:kDuration
              hideWhenFinish:hideWithAnimated
               showIndicator:YES];
}
- (void)showWaitView:(NSString*)text animation:(BOOL)animation hideWhenAnimated:(BOOL)hideWithAnimated completion:(void(^)(void))completion {
    [self showWaitViewInView:self.window animation:animation withText:text withDuration:kDuration hideWhenFinish:hideWithAnimated showIndicator:YES completion:completion];
}


- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation showIndicator:(BOOL)indicator {
    [self showWaitViewInView:view animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:indicator];
}
- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation showIndicator:(BOOL)indicator completion:(void(^)(void))completion {
    [self showWaitViewInView:view animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:indicator completion:completion];
}

- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation {
    [self showWaitViewInView:view animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:YES];
}

- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation completion:(void(^)(void))completion {
    [self showWaitViewInView:view animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:YES completion:completion];
}

- (void)showWaitView:(NSString*)text animation:(BOOL)animation {
    [self showWaitViewInView:self.window animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:YES];
}
- (void)showWaitView:(NSString*)text animation:(BOOL)animation completion:(void(^)(void))completion {
        [self showWaitViewInView:self.window animation:animation withText:text withDuration:kDuration hideWhenFinish:NO showIndicator:YES completion:completion];
}

-(void)showWaitViewInViewByThread:(NSMutableDictionary*)params {
    
    @autoreleasepool {
        UIView *view = [params objectForKey:@"view"];
        BOOL animated = [(NSNumber*)[params objectForKey:@"animated"] boolValue];
        NSString *text = [params objectForKey:@"text"];
        CGFloat duration = [(NSNumber*)[params objectForKey:@"duration"] floatValue];
        BOOL hideWhenFinish = [(NSNumber*)[params objectForKey:@"hideWhenFinish"] boolValue];
        BOOL indicator = [(NSNumber*)[params objectForKey:@"indicator"] boolValue];
        MCNotificationCompletionBlock completion = [params objectForKey:@"completion"];
        self.hideWhenFinish = hideWhenFinish;
        self.view.userInteractionEnabled = YES;
        self.view = view;
        self.view.userInteractionEnabled = NO;
        
        CGFloat margin = 8;
        if (!text.length) {
            [self.indicatorView startAnimating];
            self.tipsLabel.text=@"请稍候...";
            self.tipsLabel.numberOfLines=1;
            self.tipsLabel.frame=CGRectMake(0, 54, 185.0f, 20);
            self.tipsLabel.textColor = [UIColor grayColor];
            
        }else {
            
            self.tipsLabel.numberOfLines = 0;
            CGSize textSize = [text sizeWithFont:self.tipsLabel.font
                               constrainedToSize:CGSizeMake(185.0f - margin*2, CGFLOAT_MAX)
                                   lineBreakMode:UILineBreakModeWordWrap];
            
            if (indicator) [self.indicatorView startAnimating];
            else [self.indicatorView stopAnimating];
            self.tipsLabel.frame = CGRectMake(0,
                                              indicator ? CGRectGetMaxY(self.indicatorView.frame)+margin : margin*2,
                                              textSize.width,
                                              textSize.height);
            
            CGFloat height = CGRectGetMaxY(self.tipsLabel.frame) + margin + (indicator ? 0:margin*2);
            height = height > WAIT_VIEW_MIN_HEIGHT ? height : WAIT_VIEW_MIN_HEIGHT;
            
            self.waitView.frame = CGRectMake(CGRectGetMinX(self.waitView.frame),
                                             CGRectGetMinY(self.waitView.frame),
                                             CGRectGetWidth(self.waitView.frame),
                                             height);
            
            self.tipsLabel.center = CGPointMake(CGRectGetWidth(self.waitView.frame)/2,
                                                indicator ? self.tipsLabel.center.y : height/2);
            
            self.tipsLabel.text=text;
            self.tipsLabel.textColor = [UIColor grayColor];
            
        }
        
        CGPoint point = [self.window convertPoint:self.window.center toView:self.view];
        self.waitView.center = point;
        [self.window bringSubviewToFront:self.waitView];
        
        self.waitView.alpha = 0;
        if (!animated) self.waitView.alpha = 0.99;
        [self.view addSubview:self.waitView];
        self.waitView.hidden=NO;
        
        /*
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:kTransitionDuration];
         //    if (hideWhenFinish) {
         //        [UIView setAnimationDelegate:self];
         //        [UIView setAnimationDidStopSelector:@selector(hiddenWaitViewByThread)];
         //    }
         self.waitView.alpha = 1;
         [UIView commitAnimations];
         */
        
        __block MCNotification *tmp = self;
        [UIView animateWithDuration:kTransitionDuration animations:^{
            tmp.waitView.alpha = 1;
        } completion:^(BOOL finished) {
            if (!hideWhenFinish) {
                if (completion) completion();
            }
        }];
        
        
        if (hideWhenFinish) {
            double delayInSeconds = duration > 0 ? duration :  kDuration;
            NSLog(@"delay:%f" ,delayInSeconds);
            delayInSeconds = delayInSeconds > kTransitionDuration ? delayInSeconds :kTransitionDuration;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self hiddenWaitViewByThread];
                if (completion) completion();
            });
        }
        
        if (animated) {
        } else {
            self.waitView.alpha = 1;
        }

    }
    
}

-(void)showWaitViewInView:(UIView*)view
                animation:(BOOL)animated
                 withText:(NSString*)text
             withDuration:(CGFloat)duration
           hideWhenFinish:(BOOL)hideWhenFinish
showIndicator:(BOOL)indicator runInMainThread:(BOOL)inMainThread completion:(MCNotificationCompletionBlock)completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:view ? view : self.window forKey:@"view"];
    [params setObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    [params setObject:text ? text : @"" forKey:@"text"];
    [params setObject:[NSNumber numberWithFloat:duration] forKey:@"duration"];
    [params setObject:[NSNumber numberWithBool:hideWhenFinish] forKey:@"hideWhenFinish"];
    [params setObject:[NSNumber numberWithBool:indicator] forKey:@"indicator"];
    if (completion) [params setObject:completion forKey:@"completion"];
    
    if (inMainThread) [self performSelectorOnMainThread:@selector(showWaitViewInViewByThread:) withObject:params waitUntilDone:NO];
    else [self showWaitViewInViewByThread:params];
    
}


//在主线程同显示Notification
-(void)showWaitViewInView:(UIView*)view
                animation:(BOOL)animated
                 withText:(NSString*)text
             withDuration:(CGFloat)duration
           hideWhenFinish:(BOOL)hideWhenFinish
            showIndicator:(BOOL)indicator {
    
    [self showWaitViewInView:view animation:animated withText:text withDuration:duration hideWhenFinish:hideWhenFinish showIndicator:indicator runInMainThread:YES completion:NULL];
    
}

-(void)showWaitViewInView:(UIView*)view
                animation:(BOOL)animated
                 withText:(NSString*)text
             withDuration:(CGFloat)duration
           hideWhenFinish:(BOOL)hideWhenFinish
            showIndicator:(BOOL)indicator
               completion:(void(^)(void))completion {
    
        [self showWaitViewInView:view animation:animated withText:text withDuration:duration hideWhenFinish:hideWhenFinish showIndicator:indicator runInMainThread:NO completion:completion];
}

- (void)refreshWaitViewText:(NSString *)text
{
    self.tipsLabel.text = text;
}

-(void)showMsg:(id)delegate title:(NSString*)title message:(NSString*)msg tag:(NSInteger)tag
{
	UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
	alertView.tag=tag;
	[alertView show];
}


-(void)showMsgConfirm:(id)delegate title:(NSString*)title message:(NSString*)msg tag:(NSInteger)tag
{
	UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
	alertView.tag=tag;
	[alertView show];
}

-(void)showMsgWithBtnStr:(id)delegate title:(NSString*)title message:(NSString*)msg leftBtn:leftStr rightBtn:rightStr tag:(NSInteger)tag
{
	UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:leftStr otherButtonTitles:rightStr,nil];
	alertView.tag=tag;
	[alertView show];
}



#pragma mark -
- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}



@end
