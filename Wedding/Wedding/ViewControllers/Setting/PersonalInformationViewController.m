//
//  PersonalInformationViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PersonalInformationViewController.h"

@interface PersonalInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

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
        _titleArray = [[NSArray alloc]initWithObjects:@"头像",@"性别",@"姓名", nil];
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

@end
