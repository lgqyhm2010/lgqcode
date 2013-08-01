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

#define KHeight  150

@interface WeddingViewController ()

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
    __block WeddingViewController *weddingVC = self;
    NSDictionary *params = @{@"op": @"wedding.getWedding",@"wedding.number":@"12345"};
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine getSelectionPicWithParam:params url:@"app/wedding/getWedding" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSArray class]]) {
            [weddingVC.selectionScrollerView setContentSize:CGSizeMake(310*[responseData count], KHeight)];
            for (int index = 0; index<[responseData count]; index++) {
                ParsePhotoParams *params = [[ParsePhotoParams alloc]init];
                [params parse:responseData[index]];
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(310*index, 0, 310, KHeight)];
                [imgView setImageWithURL:[NSURL URLWithString:params.url] placeholderImage:[UIImage imageNamed:@"defaultIcon@2x"]];
                [weddingVC.selectionScrollerView addSubview:imgView];
                [imgView release];
            }
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        //
    }];
    [engine release];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [weddingPlanVC release];
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

- (void)dealloc
{
    self.weddingInviteButton = nil;
    self.weddingScenceButton = nil;
    self.selectionScrollerView = nil;
    [super dealloc];
}

@end
