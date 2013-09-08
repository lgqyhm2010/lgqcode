//
//  WeddingViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WeddingViewController.h"
#import "RequstEngine.h"
#import "UIButton+WebCache.h"
#import "ParsePhotoParams.h"
#import "UIImageView+WebCache.h"
#import "WeddingPlanViewController.h"
#import "ParseEnterpriseParams.h"
#import "ParseWeddingParams.h"
#import "ParseHotelParams.h"
#import "ParseInvitationParams.h"
#import "WeddingCardViewController.h"
#import "InvitationViewController.h"
#import "UIButton+WebCache.h"

#define KHeight  200

@interface WeddingViewController ()
{
    ParseEnterpriseParams *enterprise;
    NSMutableArray *pictures ;
    ParseWeddingParams *wedding;
    ParseHotelParams *hotel;
    ParseInvitationParams *invitation;
    
}

@property (nonatomic,retain)UIButton *weddingScenceButton;
@property (nonatomic,retain)UIButton *weddingInviteButton;
@property (nonatomic,retain)UIScrollView *selectionScrollerView;

@end

@implementation WeddingViewController



- (UIScrollView *)selectionScrollerView
{
    if (!_selectionScrollerView) {
        _selectionScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 5, 310, KHeight)];
        _selectionScrollerView.pagingEnabled = YES;
    }
    return _selectionScrollerView;
}


- (void)getSelectionPicData
{
   [self.selectionScrollerView setContentSize:CGSizeMake(310*[pictures count], KHeight)];
    for (int index = 0; index<[pictures count]; index++) {
        ParsePhotoParams *params = pictures[index];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(310*index, 0, 310, KHeight)];
        [imgView setImageWithURL:[NSURL URLWithString:params.url] placeholderImage:[UIImage imageNamed:@"photo_bg"]];
        [self.selectionScrollerView addSubview:imgView];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:KWeddingData];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        NSDictionary *weddingDic = [[unarchiver decodeObjectForKey:kWedding]copy];
        wedding = [[ParseWeddingParams alloc]initWithParase:weddingDic];
        DLog(@"wedding-->%@",weddingDic);
        
        NSArray *picturesArray = [[unarchiver decodeObjectForKey:KPictures]copy];
        pictures = [[NSMutableArray alloc]initWithCapacity:pictures.count];
        for (int index = 0; index<[picturesArray count]; index ++) {
            NSDictionary *pictureDic = picturesArray[index];
            ParsePhotoParams *photo = [[ParsePhotoParams alloc]init];
            [photo parse:pictureDic];
            [pictures addObject:photo];
        }
        
        NSDictionary *enterpriseDic = [[unarchiver decodeObjectForKey:KEnterprise]copy];
        enterprise = [[ParseEnterpriseParams alloc]initWithParse:enterpriseDic];
        DLog(@"enterprise-->%@",enterpriseDic);
        
        NSDictionary *hotelDic = [[unarchiver decodeObjectForKey:KHotel]copy];
        hotel = [[ParseHotelParams alloc]initWithParseData:hotelDic];
        DLog(@"hotel-->%@",hotelDic);
        
        NSDictionary *invitationDic = [[unarchiver decodeObjectForKey:KInvitation]copy];
        invitation = [[ParseInvitationParams alloc]initWithParseData:invitationDic];
        DLog(@"invitation-->%@",invitationDic);
        
        [unarchiver finishDecoding];
           }
    return self;
}

- (void)invite
{
    InvitationViewController *inviteVC = [[InvitationViewController alloc]init];
    inviteVC.hotelParams = hotel;
    [inviteVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (void)weddingCard
{
    WeddingCardViewController *weddingCardVC = [[WeddingCardViewController alloc]init];
    weddingCardVC.weddingParams = wedding;
    [self presentModalViewControllerMy:weddingCardVC animated:YES];
}

- (void)loadView
{
    [super loadView];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"message_big_bg3.jpg"];
    [self.view addSubview:backView];
    
    CGFloat heigt = KHeight + 10;
    UIView *themeView = [[UIView alloc]initWithFrame:CGRectMake(3, heigt, 316, 40)];
    heigt += 40;
    themeView.backgroundColor = [UIColor colorWithHexString:@"a05a98"];
    themeView.alpha = 0.7;
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300, 30)];
    info.textAlignment = UITextAlignmentLeft;
    info.font = [UIFont systemFontOfSize:12];
    info.textColor = [UIColor whiteColor];
    info.text = [wedding info];
    info.backgroundColor = [UIColor clearColor];
    [themeView addSubview:info];
    
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(280, 20, 30, 20)];
    labe.text = @"主题";
    labe.textAlignment = UITextAlignmentRight;
    labe.font = [UIFont systemFontOfSize:12];
    [labe setHighlighted:YES];
    labe.highlightedTextColor = [UIColor whiteColor];
    labe.backgroundColor = [UIColor clearColor];
    [themeView addSubview:labe];
    
    [self.view addSubview:themeView];
    heigt += 5;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, heigt, 158, 100);
    [btn1 setBackgroundImageWithURL:[NSURL URLWithString:hotel.pictureUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"photo_bg"]];
//    [btn1 setBackgroundImage:[UIImage imageNamed:@"wedding_info_hotel.jpg"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(invite) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weddingScence = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    weddingScence.text = @"婚礼现场";
    weddingScence.textAlignment = UITextAlignmentCenter;
    weddingScence.font = [UIFont systemFontOfSize:12];
    weddingScence.textColor = [UIColor whiteColor];
    weddingScence.backgroundColor = [UIColor grayColor];
    weddingScence.alpha = 0.8;
    [btn1 addSubview:weddingScence];
    
    self.weddingScenceButton = btn1;
    [self.view addSubview:self.weddingScenceButton];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(162, heigt, 158, 100);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"wedding_info_card.jpg"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(weddingCard) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weddingCard = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    weddingCard.text = @"婚礼请帖";
    weddingCard.textAlignment = UITextAlignmentCenter;
    weddingCard.font = [UIFont systemFontOfSize:12];
    weddingCard.textColor = [UIColor whiteColor];
    weddingCard.backgroundColor = [UIColor grayColor];
    weddingCard.alpha = 0.8;
    [btn2 addSubview:weddingCard];
    self.weddingInviteButton = btn2;
    [self.view addSubview:self.weddingInviteButton];

    // Custom initialization
    
    [self getSelectionPicData];
   
}

- (void)aboutRomantic
{
    WeddingPlanViewController *weddingPlanVC = [[WeddingPlanViewController alloc]init];
    weddingPlanVC.enterpriseParams = enterprise;
    weddingPlanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weddingPlanVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"爱浪漫"];
    [self setNavigationItemNormalImage:@"about_icon_normal.png" HightImage:@"about_icon_click.png" selector:@selector(aboutRomantic) isRight:NO];
    
    [self.view addSubview:self.selectionScrollerView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
