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
#import "FeedbackViewController.h"
#import "AboutRomanticViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *settingTableView;
@property (nonatomic,retain) NSArray *titles;   //所有的设置标题文案

@end

@implementation SettingViewController


#pragma mark getter

- (NSArray *)titles
{
    if (!_titles) {
        NSArray *firstSectonTitle = @[@"个人信息",@"分享给好友"];
        NSArray *seconSectionTitle = @[@"用户帮助",@"意见反馈",@"检查更新",@"关于爱浪漫"];
        _titles = [[NSArray alloc]initWithObjects:firstSectonTitle,seconSectionTitle, nil];
    }
    return _titles;
}

- (UITableView *)settingTableView
{
    if (!_settingTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame)-108;
        _settingTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStyleGrouped];
        _settingTableView.backgroundColor = [UIColor clearColor];
        _settingTableView.backgroundView =nil;
        _settingTableView.dataSource = self;
        _settingTableView.delegate = self;
    }
return _settingTableView;
}

#pragma mark view lifeStyle

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

- (void)dealloc
{
    self.settingTableView = nil;
    [super dealloc];
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
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark tableview delegate

typedef enum {
    PersonalInformation=0,
    ShareTofriend
}FirstSection;

typedef enum {
    UserHelp = 0,
    Feedback,
    CheckUpdate,
    AboutRomantic
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
                [personalIndromationVC release];personalIndromationVC = nil;
            }
                break;
                case ShareTofriend:
            {
                
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1)   {
        switch (indexPath.row) {
            case UserHelp:
            {
                UserHelpViewController *userHelpVC = [[UserHelpViewController alloc]init];
                userHelpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userHelpVC animated:YES];
                [userHelpVC release];userHelpVC = nil;
            }
                break;
              case Feedback:
            {
                FeedbackViewController *feedbaceVC = [[FeedbackViewController alloc]init];
                feedbaceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:feedbaceVC animated:YES];
                [feedbaceVC release];feedbaceVC = nil;
            }
                break;
             case CheckUpdate:
            {
                
            }
                break;
                case AboutRomantic:
            {
                AboutRomanticViewController *aboutRomanticVC = [[AboutRomanticViewController alloc]init];
                aboutRomanticVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutRomanticVC animated:YES];
                [aboutRomanticVC release];aboutRomanticVC = nil;
            }
                break;
            default:
                break;
        }
    }
}

@end
