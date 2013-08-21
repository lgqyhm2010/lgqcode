//
//  PersonalInformationViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "ParseLoginParams.h"
#import "UIImageView+WebCache.h"
#import "RequstEngine.h"

#define KPickerImgaeTag 1100
#define KChangeSexTag   1101

@interface PersonalInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    ParseLoginParams *loginParams;
    NSData *imgData;
    NSString *userName;
    NSString *sex;
}

@property (nonatomic,retain)UITableView *informationTableView;
@property (nonatomic,retain)NSArray *titleArray;

@end

@implementation PersonalInformationViewController

- (UITableView *)informationTableView
{
    if (!_informationTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame)-44;
        _informationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStyleGrouped];
        _informationTableView.backgroundColor = [UIColor clearColor];
        _informationTableView.backgroundView = nil;
        _informationTableView.delegate = self;
        _informationTableView.dataSource = self;
    }
    return _informationTableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc]initWithObjects:@"头像",@"姓名",@"性别", nil];
    }
    return _titleArray;
}

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
    NSMutableData *data = [[NSUserDefaults standardUserDefaults]objectForKey:KEnduringLoginData];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSDictionary *dic = [unarchiver decodeObjectForKey:kLoginData];
    [unarchiver finishDecoding];
    loginParams = [[ParseLoginParams alloc]init];
    [loginParams parseLogin:dic];
    userName = loginParams.name;
    sex = loginParams.sex;
}

- (void)updateInformation
{
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:KUerID];
    NSDictionary *params = @{@"op": @"user.update",@"user.id":userID,@"user.simId":[UIDeviceHardware getDeviceUUID],@"user.name":userName,@"user.sex":sex};
    [Notification showWaitView:@"正在更新" animation:YES];
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine postDataWithParam:params imgData:imgData url:@"app/user/update" onCompletion:^(id responseData) {
        [Notification hiddenWaitView:NO];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:responseData forKey:kLoginData];
            [archiver finishEncoding];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:KEnduringLoginData];
            [[NSUserDefaults standardUserDefaults]synchronize];

        }
    } onError:^(int errorCode, NSString *errorMessage) {
        [Notification hiddenWaitView:NO];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"个人信息"];
    [self setDefaultBackClick:nil];
    [self setNavigationItemNormalImage:@"send_icon_normal.png" HightImage:@"send_icon_click.png" selector:@selector(updateInformation) isRight:YES];

    [self.view addSubview:self.informationTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview datasourc

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 70;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (imgData) {
                UIImage *img = [UIImage imageWithData:imgData];
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 5, 60, 60)];
                imgView.image = img;
                [cell.contentView addSubview:imgView];

            }else   {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 5, 60, 60)];
                [imgView setImageWithURL:[NSURL URLWithString:loginParams.pictureUrl] placeholderImage:nil];
                [cell.contentView addSubview:imgView];
            }
            
                    }
            break;
    case 1:
        {
            cell.detailTextLabel.text = userName;
        }
            break;
    case 2:
        {
            NSString *sexName = [NSString stringWithFormat:@"%@",sex];
            NSString *sexDisPlay = [sexName isEqualToString:KMan]?@"男":@"女";
            cell.detailTextLabel.text = sexDisPlay;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma tabelview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选择本地图片", nil];
        sheet.tag = KPickerImgaeTag;
        [sheet showInView:self.view];
    }else if (indexPath.row == 1)
    {
        UIAlertView *changeName = [[UIAlertView alloc]initWithTitle:@"修改名字" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        changeName.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[changeName textFieldAtIndex:0]setText:userName];
        [changeName show];
    }else if (indexPath.row == 2)   {
        UIActionSheet *changeSex = [[UIActionSheet alloc]initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女",@"男", nil];
        changeSex.tag = KChangeSexTag;
        [changeSex showInView:self.view];
    }
    
    
}

typedef NS_ENUM(NSInteger, ActionSheetIndex){
    IndexCamera,
    IndexAlbum
};
#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == KPickerImgaeTag) {
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

    }else if (actionSheet.tag == KChangeSexTag)  {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            sex = [NSString stringWithFormat:@"%d",buttonIndex];
            [self.informationTableView reloadData];
        }
        
    }
    
   }

#pragma mark uiimagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imgData = UIImageJPEGRepresentation(pickerImage, 0.1f);
    [self.informationTableView reloadData];
    [self dismissModalViewControllerAnimatedMy:YES];
    
}

#pragma mark alerview

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        userName = [alertView textFieldAtIndex:0].text;
        [self.informationTableView reloadData];
    }
}

@end
