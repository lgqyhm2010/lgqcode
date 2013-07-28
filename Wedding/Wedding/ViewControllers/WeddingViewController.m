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
#import "NSData+Base64.h"

@interface WeddingViewController ()

@property (nonatomic,retain)UIButton *weddingScenceButton;
@property (nonatomic,retain)UIButton *weddingInviteButton;

@end

@implementation WeddingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 100, 160, 130);
        self.weddingScenceButton = btn1;
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(160, 100, 160, 130);
        self.weddingInviteButton = btn2;

        // Custom initialization
        NSDictionary *params = @{@"op": @"hotel.getHotelPicture",@"hotelPicture.hotelId":@"c476c2f5-86f3-4fcf-9eb5-89dcec01b71b"};
        RequstEngine *engine = [[RequstEngine alloc]init];
        [engine getDataWithParam:params url:@"app/hotel/getHotelPicture" onCompletion:^(id responseData) {
            if ([responseData isKindOfClass:[NSArray class]]) {
                NSDictionary *dic1 = responseData[0];
                NSString *string1 = [dic1 jsonObjectForKey:@"url"];
                NSData *data1 = [NSData dataFromBase64String:string1];
                [self.weddingScenceButton setImage:[UIImage imageWithData:data1] forState:UIControlStateNormal];
                
                NSDictionary *dic2 = responseData[1];
                NSData *data2 = [[dic2 jsonObjectForKey:@"url"]objectFromJSONString];
                [self.weddingScenceButton setImage:[UIImage imageWithData:data2] forState:UIControlStateNormal];
            }
        } onError:^(int errorCode, NSString *errorMessage) {
            //
        }];
        [engine release];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
   }

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"首页"];
    
    [self.view addSubview:self.weddingScenceButton];
    [self.view addSubview:self.weddingInviteButton];
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
    [super dealloc];
}

@end
