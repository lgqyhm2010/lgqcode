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


- (void)viewDidUnload {
    [self setInviteWedding:nil];
    [super viewDidUnload];
}
- (IBAction)entranceWedding:(id)sender {
    
    NSDictionary *param = @{@"op": @"wedding.getWedding",@"wedding.number":self.InviteWedding.text};
    __block LoginViewController *logingVC = self;
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine getDataWithParam:param url:@"app/wedding/getWedding" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            GuidePhotoViewController *guiPhotoVC = [[GuidePhotoViewController alloc]init];
            [logingVC.navigationController pushViewController:guiPhotoVC animated:YES];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        //
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.InviteWedding resignFirstResponder];
    return YES;
}
@end
