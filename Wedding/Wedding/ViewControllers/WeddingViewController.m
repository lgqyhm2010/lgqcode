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

#define KHeight  207

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

- (void)getWeddingData
{
//    NSDictionary *params = @{@"op": @"hotel.getHotelPicture",@"hotelPicture.hotelId":@"c476c2f5-86f3-4fcf-9eb5-89dcec01b71b"};
//    RequstEngine *engine = [[RequstEngine alloc]init];
//    [engine getDataWithParam:params url:@"app/hotel/getHotelPicture" onCompletion:^(id responseData) {
//        if ([responseData isKindOfClass:[NSArray class]]) {
//            UIImage *img = [UIImage imageNamed:@"defaultIcon@2x"];
//            
//            NSDictionary *dic1 = responseData[0];
//            NSString *url1 = [dic1 jsonObjectForKey:@"url"];
//            [self.weddingScenceButton setBackgroundImageWithURL:[NSURL URLWithString:url1] forState:UIControlStateNormal placeholderImage:img];
//            
//            NSDictionary *dic2 = responseData[1];
//            NSString *url2 = [dic2 jsonObjectForKey:@"url"];
//            [self.weddingInviteButton setBackgroundImageWithURL:[NSURL URLWithString:url2] forState:UIControlStateNormal placeholderImage:img];
//        }
//    } onError:^(int errorCode, NSString *errorMessage) {
//        //
//    }];
//    [engine release];
    

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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 220, 158, 100);
    self.weddingScenceButton = btn1;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(162, 220, 158, 100);
    self.weddingInviteButton = btn2;
    
    // Custom initialization
    
    [self getWeddingData];
    [self getSelectionPicData];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"首页"];
    
    [self.view addSubview:self.weddingScenceButton];
    [self.view addSubview:self.weddingInviteButton];
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
