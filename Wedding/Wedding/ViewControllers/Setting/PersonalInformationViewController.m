//
//  PersonalInformationViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "RPCRequestEngine.h"

#define KImage @"image"

@interface PersonalInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"个人信息"];
    [self setBackNavigationItemTitle:@"返回"];
    
    [self.view addSubview:self.informationTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.informationTableView = nil;
    self.titleArray = nil;
    [super dealloc];
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
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:KImage];
            UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 5, 60, 60)];
            imgView.image = image;
            [cell.contentView addSubview:imgView];
            [imgView release];
        }
            break;
    case 1:
        {
            cell.detailTextLabel.text = @"罗国球";
        }
            break;
    case 2:
        {
            cell.detailTextLabel.text = @"男";
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
        [sheet showInView:self.view];
    }
    
    
}

typedef NS_ENUM(NSInteger, ActionSheetIndex){
    IndexCamera,
    IndexAlbum
};
#pragma mark actionsheet delegate

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
    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:pickerImage];
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:KImage];
    [self dismissModalViewControllerAnimatedMy:YES];
    
}


@end
