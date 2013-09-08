//
//  WeddingCardViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-8-10.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WeddingCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "ParseWeddingParams.h"


@interface WeddingCardViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation WeddingCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    CGFloat height = CGRectGetHeight(self.view.frame)+20;

    [self.view setFrame:CGRectMake(0, -20, 320, height)];
}

- (void)backClick
{
    [self dismissModalViewControllerAnimatedMy:YES];
}

- (void)sendWeddingCard
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
        message.messageComposeDelegate = self;
        NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KuserName];
        NSString *inviteNumber = [[NSUserDefaults standardUserDefaults]objectForKey:KWeddingInviteNumber];
        NSString *body = [NSString stringWithFormat:@"你的好友(%@)发了一张喜帖给你，邀请你参加一场婚礼。\n\
                          爱浪漫下载地址：http://www.iloveuing.com/app/version/download\n\
                          打开爱浪漫后，请使用婚礼邀请码:%@ 或者通过扫描婚礼二维码进入婚礼，有更多的浪漫事情等着你哦！",userName,inviteNumber];
        [message setBody:body];
        [self presentModalViewControllerMy:message animated:YES];
        
    }else
        [Notification showMsgConfirm:self title:KMsgDefault message:KNotSuppor tag:1];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat height = CGRectGetHeight(self.view.frame);
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, height, 320)];
    backView.image = [UIImage imageNamed:@"invitation_card.jpg"];
    [self.view addSubview:backView];
    
    UIButton *backClickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backClickButton.frame = CGRectMake(10, 10, 50, 40);
    [backClickButton setTitle:@"返回" forState:UIControlStateNormal];
    [backClickButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backClickButton];
    
    UIButton *sendWeddingCard = [UIButton buttonWithType:UIButtonTypeCustom];
    sendWeddingCard.frame = CGRectMake(height - 100, 10, 80, 40);
    [sendWeddingCard setTitle:@"发喜帖" forState:UIControlStateNormal];
    [sendWeddingCard addTarget:self action:@selector(sendWeddingCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendWeddingCard];
    
    CGFloat y = 260.f;
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(50, y, 400, 20)];
    NSString *bridegroomInfo = self.weddingParams.bridegroomInfo;
    NSString *brideInfo = self.weddingParams.brideInfo;
    nameLable.text = [NSString stringWithFormat:@"%@ 与 %@",bridegroomInfo,brideInfo];
    nameLable.backgroundColor= [UIColor clearColor];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.font = [ToolSet customNormalFontWithSize:14];
    nameLable.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:nameLable];
    y += 20;
    
    UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(50, y, 400, 20)];
    NSString *creatTime = self.weddingParams.createTime;
    NSString *address = self.weddingParams.info;
    infoLable.text = [NSString stringWithFormat:@"于 %@在%@举行婚礼",creatTime,address];
    infoLable.backgroundColor= [UIColor clearColor];
    infoLable.textColor = [UIColor whiteColor];
    infoLable.font = [ToolSet customNormalFontWithSize:14];
    infoLable.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:infoLable];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);

}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft;
    
}

#pragma mark messageDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimatedMy:YES];
}

@end
