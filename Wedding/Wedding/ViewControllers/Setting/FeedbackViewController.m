//
//  FeedbackViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-16.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation FeedbackViewController

- (void)sendFeedback
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
    // Do any additional setup after loading the view from its nib.
    [self setNavigationTitle:@"意见反馈"];
    [self setBackNavigationItemTitle:@"返回"];
    [self setRightNavigationItemTitle:@"发送" selector:@selector(sendFeedback)];
    
    self.phoneNumberTextField.delegate = self;
    self.feedbackTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneNumberTextField:nil];
    [self setFeedbackTextView:nil];
    [self setFeedbackLabel:nil];
    [super viewDidUnload];
}

#pragma mark uitextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int len = textField.text.length + string.length - range.length;
    if (len>11) {
        return NO;
    }
    return YES;
    
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
