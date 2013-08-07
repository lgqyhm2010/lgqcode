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

#define KHeight  150

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
        [imgView setImageWithURL:[NSURL URLWithString:params.url] placeholderImage:[UIImage imageNamed:@"defaultIcon@2x"]];
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
        
        NSArray *picturesArray = [[unarchiver decodeObjectForKey:KPictures]copy];
        pictures = [[NSMutableArray alloc]initWithCapacity:pictures.count];
        for (int index = 0; index<[picturesArray count]; index ++) {
            NSDictionary *pictureDic = picturesArray[index];
            ParsePhotoParams *photo = [[ParsePhotoParams alloc]init];
            [photo parse:pictureDic];
            [pictures addObject:photo];
        }
        
        NSDictionary *enterpriseDic = [unarchiver decodeObjectForKey:KEnterprise];
        enterprise = [[ParseEnterpriseParams alloc]initWithParse:enterpriseDic];
        
        NSDictionary *hotelDic = [unarchiver decodeObjectForKey:KHotel];
        hotel = [[ParseHotelParams alloc]initWithParseData:hotelDic];
        
        NSDictionary *invitationDic = [unarchiver decodeObjectForKey:KInvitation];
        invitation = [[ParseInvitationParams alloc]initWithParseData:invitationDic];
        
        [unarchiver finishDecoding];
           }
    return self;
}

- (void)loadView
{
    [super loadView];
    CGFloat heigt = 200;
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, heigt, 158, 100);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"wedding_info_hotel.jpg"] forState:UIControlStateNormal];
    self.weddingScenceButton = btn1;
    [self.view addSubview:self.weddingScenceButton];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(162, heigt, 158, 100);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"invitation_card.jpg"] forState:UIControlStateNormal];
    self.weddingInviteButton = btn2;
    [self.view addSubview:self.weddingInviteButton];

    // Custom initialization
    
    [self getSelectionPicData];
   
}

- (void)aboutRomantic
{
    WeddingPlanViewController *weddingPlanVC = [[WeddingPlanViewController alloc]init];
    weddingPlanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weddingPlanVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"爱浪漫"];
    [self setNavigationItemNormalImage:@"about_icon_normal.png" HightImage:@"about_icon_pressed.png" selector:@selector(aboutRomantic) isRight:NO];
    
    [self.view addSubview:self.selectionScrollerView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
