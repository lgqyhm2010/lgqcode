//
//  RegisterViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-22.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "RegisterViewController.h"
#import "RequstEngine.h"
#import "LoginViewController.h"
#import "ParseLoginParams.h"

@interface RegisterViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    NSData *imgeData;
}

@property (retain, nonatomic) IBOutlet UIButton *personImage;

- (IBAction)pickerImage:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)registerWedding:(id)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sex;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickerImage:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
    [sheet showInView:self.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setSex:nil];
    [self setPersonImage:nil];
    [super viewDidUnload];
}
- (IBAction)registerWedding:(id)sender {
    if (!imgeData) {
        [self showPromptView:@"请选择图片"];
        return ;
    }
    if (self.nameTextField.text.length<1) {
        [self showPromptView:@"请输入姓名"];
        return ;
    }
    [Notification showWaitView:@"正在注册" animation:YES];
    NSString *sexName = self.sex.selectedSegmentIndex == 0?KMan:KWoman;//1代表男，0代表女
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"user.regist",@"op",[UIDeviceHardware getDeviceUUID],@"user.simId",self.nameTextField.text,@"user.name",sexName,@"user.sex", nil];
   __weak RegisterViewController *weakRegister = self;
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine postDataWithParam:param imgData:imgeData url:@"app/user/regist" onCompletion:^(id responseData) {
        [Notification hiddenWaitView:NO];
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:responseData forKey:kLoginData];
        [archiver finishEncoding];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:KEnduringLoginData];
        
        ParseLoginParams *loginParams = [[ParseLoginParams alloc]init];
        [loginParams parseLogin:responseData];
        [[NSUserDefaults standardUserDefaults]setObject:loginParams.userID forKey:KUerID];
        [[NSUserDefaults standardUserDefaults]setObject:loginParams.name forKey:KuserName];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [weakRegister.navigationController pushViewController:loginVC animated:YES];
    } onError:^(int errorCode, NSString *errorMessage) {
        [Notification hiddenWaitView:NO];
        [Notification showMsgConfirm:nil title:KMsgDefault message:errorMessage tag:0];
    }];

}

#pragma mark actionsheet delegate

typedef NS_ENUM(NSInteger, ActionSheetIndex){
    IndexCamera,
    IndexAlbum
};

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case IndexCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagPickerVC = [[UIImagePickerController alloc]init];
                imagPickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagPickerVC.delegate = self;
                [self presentModalViewControllerMy:imagPickerVC animated:YES];
            }else
                [Notification showMsgConfirm:self title:KMsgDefault message:KNotSuppor tag:1];
        }
            break;
        case IndexAlbum:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagPickerVC = [[UIImagePickerController alloc]init];
                imagPickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagPickerVC.delegate = self;
                [self presentModalViewControllerMy:imagPickerVC animated:YES];
                
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark uiimagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimatedMy:YES];
    [self.personImage setImage:pickerImage forState:UIControlStateNormal];
    imgeData = [UIImageJPEGRepresentation(pickerImage, 0.1)copy];
        
}

#pragma mark uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    return YES;
}

@end
