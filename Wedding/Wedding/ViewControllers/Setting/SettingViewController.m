//
//  SettingViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-10.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SettingViewController.h"
#import "PersonalInformationViewController.h"
#import "UserHelpViewController.h"
#import "AboutRomanticViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIButton(Addition).h"
#import "FeedbackViewController.h"
#import "RequstEngine.h"

#define KMessageContent @"爱浪漫"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,retain) UITableView *settingTableView;
@property (nonatomic,retain) NSArray *titles;   //所有的设置标题文案
@property (nonatomic,strong) UIView *footView;

@end

@implementation SettingViewController


#pragma mark getter

- (NSArray *)titles
{
    if (!_titles) {
        NSArray *firstSectonTitle = @[@"个人信息",@"分享给好友"];
        NSArray *seconSectionTitle = @[@"意见反馈",@"检查更新",@"关于爱浪漫"];
        _titles = [[NSArray alloc]initWithObjects:firstSectonTitle,seconSectionTitle, nil];
    }
    return _titles;
}

- (UITableView *)settingTableView
{
    if (!_settingTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame)-88;
        _settingTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStyleGrouped];
        _settingTableView.backgroundColor = [UIColor clearColor];
        _settingTableView.backgroundView =nil;
        _settingTableView.dataSource = self;
        _settingTableView.delegate = self;
    }
return _settingTableView;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        UIImage *normal = [UIImage imageNamed:@"action_sheet_button_delete_normal"];
        UIImage *select = [UIImage imageNamed:@"action_sheet_button_delete_click"];
        UIButton *btn  = [UIButton customButtonWithTitle:@"退出婚礼" tag:1 target:self selector:@selector(quitWedding) frame:CGRectMake(10, 20, 300, 50) image:normal imagePressed:select];
        [_footView addSubview:btn];
    }
    return _footView;
}

#pragma mark view lifeStyle

- (void)quitWedding
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"退出后将不会删除任何历史数据，下次登录依然可以使用该账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出婚礼" otherButtonTitles:nil, nil];
    [sheet showInView:self.tabBarController.view];
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
    
    [self setNavigationTitle:@"设置"];
    
    [self.view addSubview:self.settingTableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableview dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section]count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 100;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return self.footView;
    }
    return nil;
}

typedef enum {
    PersonalInformation=0,  //个人信息
    ShareTofriend           //分享给好友
}FirstSection;

typedef enum {
    UserHelp = 0,       //用户帮助
    CheckUpdate,        //检查更新
    AboutRomantic       //关于爱浪漫
}SecondSection;

//==================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case PersonalInformation:
            {
                PersonalInformationViewController *personalIndromationVC = [[PersonalInformationViewController alloc]init];
                personalIndromationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:personalIndromationVC animated:YES];
            }
                break;
                case ShareTofriend:
            {
                
                if ([MFMessageComposeViewController canSendText]) {
                    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
                    message.messageComposeDelegate = self;
                    [message setBody:KMessageContent];
                    [self presentModalViewControllerMy:message animated:YES];
                    
                }else
                    [Notification showMsgConfirm:self title:KMsgDefault message:KNotSuppor tag:1];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1)   {
        switch (indexPath.row) {
            case UserHelp:
            {
                FeedbackViewController *feedBack = [[FeedbackViewController alloc]init];
                feedBack.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feedBack animated:YES];
            }
                break;
        
             case CheckUpdate:
            {
                [Notification showWaitViewInView:self.view text:@"正在检查新版本" animation:YES];
                NSDictionary *params = @{@"op": @"version.getNewVersion",@"version.type":@"1"};
                RequstEngine *checkUpdate = [[RequstEngine alloc]init];
                __weak typeof(self) weakSelf = self;
                [checkUpdate getDataWithParam:params url:@"app/version/getNewVersion" onCompletion:^(id responseData) {
                    if ([responseData isKindOfClass:[NSDictionary class]]) {
                        [Notification hiddenWaitView:NO];
                        NSString *title = [responseData jsonObjectForKey:@"title"];
                        NSString *info = [responseData jsonObjectForKey:@"info"];
                        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:title message:info delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alerView show];
                    }else
                        [Notification showWaitViewInView:nil animation:YES withText:@"暂无新版本" withDuration:1.0 hideWhenFinish:YES showIndicator:NO];
                    
                } onError:^(int errorCode, NSString *errorMessage) {
                    [Notification showWaitViewInView:nil animation:YES withText:@"请检查网络" withDuration:1.0 hideWhenFinish:YES showIndicator:NO];
                }];
               
            }
                break;
                case AboutRomantic:
            {
                UserHelpViewController *aboutRomanticVC = [[UserHelpViewController alloc]init];
                aboutRomanticVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutRomanticVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark messageDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimatedMy:YES];
}

#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:KIsLogin];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:KCancelWedding object:nil];
    }
}

@end
