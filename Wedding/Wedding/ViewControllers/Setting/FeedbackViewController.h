//
//  FeedbackViewController.h
//  Wedding
//
//  Created by lgqyhm on 13-7-16.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SuperViewController.h"

@interface FeedbackViewController : SuperViewController
@property (retain, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (retain, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (retain, nonatomic) IBOutlet UILabel *feedbackLabel;
@end
