//
//  FeedbackViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-16.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "FeedbackViewController.h"
#import "RequstEngine.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)sendFeedback
{
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:KUerID];
    [Notification showWaitView:@"正在提交" animation:YES];
    NSDictionary *params = @{@"op": @"feedback.send",@"feedback.userId":userID,@"feedback.info":self.feedbackTextView.text};
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine PostSendDataWithParam:params url:@"app/feedback/send" onCompletion:^(id responseData) {
        if (responseData) {
            [Notification showWaitViewInView:nil animation:YES withText:@"提交成功" withDuration:1.0 hideWhenFinish:YES showIndicator:NO];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        [Notification hiddenWaitView:NO];
    }];
    
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
    // Do any additional setup after loading the view from its nib.
    [self setNavigationTitle:@"意见反馈"];
    [self setDefaultBackClick:nil];
    [self setNavigationItemNormalImage:@"send_icon_normal.png" HightImage:@"send_icon_click.png" selector:@selector(sendFeedback) isRight:YES];
    
    self.feedbackTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFeedbackTextView:nil];
    [self setFeedbackLabel:nil];
    [super viewDidUnload];
}

#pragma mark textView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length<1) {
        self.feedbackLabel.hidden = NO;
    }else
        self.feedbackLabel.hidden = YES;
    
}

@end
