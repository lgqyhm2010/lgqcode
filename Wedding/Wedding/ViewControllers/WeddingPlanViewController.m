//
//  WeddingPlanViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-8-2.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WeddingPlanViewController.h"
#import "ParseEnterpriseParams.h"
#import "UIButton(Addition).h"

@interface WeddingPlanViewController ()

@property (nonatomic,retain) UIImageView *backContent;

@end

@implementation WeddingPlanViewController

- (UIImageView *)backContent
{
    if (!_backContent) {
        _backContent = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.frame)-44)];
        UIImage *image = [[UIImage imageNamed:@"about_content_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(200, 100, 200, 200)];
        _backContent.image = image;
    }
    return _backContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)openWebUrl:(UIButton *)sender
{
    NSString *url = nil;
    if (![self.enterpriseParams.webUrl hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"http://%@",self.enterpriseParams.webUrl];
    }else
        url = self.enterpriseParams.webUrl;
    NSURL *webUrl = [NSURL URLWithString:url];

    if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {
        [[UIApplication sharedApplication]openURL:webUrl];
    }
}

- (void)tellDial
{
    NSString *urlString = [NSString stringWithFormat:@"telprompt:%@",self.enterpriseParams.phone];
    NSURL *url = [NSURL URLWithString:urlString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        [Notification showMsgConfirm:self title:KMsgDefault message:@"该设备不支持此功能" tag:0];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"婚庆策划"];
    [self setDefaultBackClick:nil];
    
    [self.view addSubview:self.backContent];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 320, 30)];
    nameLabel.text = self.enterpriseParams.name;
    nameLabel.font = [ToolSet customNormalFontWithSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blueColor];
    [self.view addSubview:nameLabel];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 250, 100)];
    infoLabel.numberOfLines = 0;
    infoLabel.text = self.enterpriseParams.info;
    infoLabel.font = [ToolSet customNormalFontWithSize:14];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor blueColor];
    [self.view addSubview:infoLabel];

    
    CGFloat x = 200;
    CGFloat height = 20;
    CGFloat width = 100;
    CGFloat y = CGRectGetHeight(self.view.frame) - 44-90;
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width, height)];
    addressLabel.textColor = [UIColor blueColor];
    addressLabel.text = self.enterpriseParams.address;
    addressLabel.textAlignment = UITextAlignmentRight;
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [ToolSet customNormalFontWithSize:12];
    [self.view addSubview:addressLabel];
    y+=20;
    
    UIButton *webUrl = [UIButton linkButtonWithTitle:self.enterpriseParams.webUrl tag:1 target:self selector:@selector(openWebUrl:) frame:CGRectMake(x, y, width, height) font:[ToolSet customNormalFontWithSize:12] fontColor:[UIColor blueColor]];
    [self.view addSubview:webUrl];
    y+=20;
    
    UIButton *tellPhone = [UIButton linkButtonWithTitle:self.enterpriseParams.phone tag:2 target:self selector:@selector(tellDial) frame:CGRectMake(x, y, width, height) font:[ToolSet customNormalFontWithSize:12] fontColor:[UIColor blueColor]];
    [self.view addSubview:tellPhone];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
