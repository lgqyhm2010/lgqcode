//
//  LoginViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-29.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "LoginViewController.h"
#import "RequstEngine.h"
#import "GuidePhotoViewController.h"
#import "ParseWeddingParams.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *InviteWedding;
- (IBAction)entranceWedding:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.InviteWedding.delegate =self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidUnload {
    [self setInviteWedding:nil];
    [super viewDidUnload];
}
- (IBAction)entranceWedding:(id)sender {
    [Notification showWaitView:@"正在登录" animation:YES];
    NSDictionary *param = @{@"op": @"wedding.getWedding",@"wedding.number":self.InviteWedding.text};
    __weak LoginViewController *logingVC = self;
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine getDataWithParam:param url:@"app/wedding/getWedding" onCompletion:^(id responseData) {
        [Notification hiddenWaitView:NO];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
            if ([responseData jsonObjectForKey:@"wedding"]) {
                NSDictionary *weddingDic = [responseData jsonObjectForKey:@"wedding"];
                [archiver encodeObject:weddingDic forKey:kWedding];
                ParseWeddingParams *weddingParam = [[ParseWeddingParams alloc]initWithParase:weddingDic];
                [defauls setObject:weddingParam.weddingID forKey:KWeddingID];
            }
            if ([responseData jsonObjectForKey:@"pictures"]) {
                NSArray *photosArray = [responseData jsonObjectForKey:@"pictures"];
                [archiver encodeObject:photosArray forKey:KPictures];
            }
            if ([responseData jsonObjectForKey:@"enterprise"]) {
                NSDictionary *enterpriseDic = [responseData jsonObjectForKey:@"enterprise"];
                [archiver encodeObject:enterpriseDic forKey:KEnterprise];
            }
            if ([responseData jsonObjectForKey:@"hotel"]) {
                NSDictionary *hotelDic = [responseData jsonObjectForKey:@"hotel"];
                [archiver encodeObject:hotelDic forKey:KHotel];
            }
            if ([responseData jsonObjectForKey:@"invitation"]) {
                NSDictionary *invitationDic = [responseData jsonObjectForKey:@"invitation"];
                [archiver encodeObject:invitationDic forKey:KInvitation];
            }
            [archiver finishEncoding];
            [defauls setObject:data forKey:KWeddingData];
            [defauls setBool:YES forKey:KIsLogin];
            [defauls setObject:self.InviteWedding.text forKey:KWeddingInviteNumber];
            [defauls synchronize];
            GuidePhotoViewController *guiPhotoVC = [[GuidePhotoViewController alloc]init];
            [logingVC.navigationController pushViewController:guiPhotoVC animated:YES];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        [Notification hiddenWaitView:NO];
        
       
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.InviteWedding resignFirstResponder];
    return YES;
}
@end
