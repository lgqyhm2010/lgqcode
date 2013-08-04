//
//  AboutRomanticViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "AboutRomanticViewController.h"
#import "FeedbackViewController.h"
#import "IntroducedFunctionViewController.h"
#import "GuidePhotoViewController.h"

@interface AboutRomanticViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *aboutTableView;
@property (nonatomic,retain) NSArray *titleArray;

@end


@implementation AboutRomanticViewController

#pragma mark getter

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc]initWithObjects:@"新版本说明",@"功能介绍",@"意见反馈", nil];
    }
    return _titleArray;
}

- (UITableView *)aboutTableView
{
    if (!_aboutTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame) - 44;
        _aboutTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStyleGrouped];
        _aboutTableView.backgroundColor = [UIColor clearColor];
        _aboutTableView.backgroundView = nil;
        _aboutTableView.delegate = self;
        _aboutTableView.dataSource = self;
    }
    return _aboutTableView;
}

#pragma mark view lifestyle
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
    [self setNavigationTitle:@"关于爱浪漫"];
    [self setBackNavigationItemTitle:@"返回"];
    
    [self.view addSubview:self.aboutTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
    
}

#pragma mark tableview delegate

typedef NS_ENUM(NSInteger, KRow){
      RowNewVersion,
      RowIntroduceFormation,
      RowFeedback
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case RowNewVersion:
            //
        break;
            case RowIntroduceFormation:
        {
            GuidePhotoViewController *introduceVC = [[GuidePhotoViewController alloc]initWithEntryType:EntryIntroduceType];
            [self.navigationController pushViewController:introduceVC animated:YES];
        }
            break;
            case RowFeedback:
        {
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
            
        }
            
        default:
            break;
    }
}

@end
