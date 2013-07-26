//
//  SocialViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SocialViewController.h"
#import "RequstEngine.h"

@interface SocialViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *socialTableView;
@property (nonatomic,retain)NSMutableArray *context;

@end

@implementation SocialViewController

#pragma mark getter

- (NSMutableArray *)context
{
    if (!_context) {
        _context = [[NSMutableArray alloc]init];
    }
    return _context;
}

- (UITableView *)socialTableView
{
    if (!_socialTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame) - 88;
        _socialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
        _socialTableView.delegate = self;
        _socialTableView.dataSource = self;
        
    }
    return _socialTableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        RequstEngine *engine = [[RequstEngine alloc]init];
        NSDictionary *params = @{@"po": @"bless.getAfterTimestamp",@"bless.timeStamp":@"1371743645272",@"bless.weddingId":KUerID};
        [engine getDataWithParam:params url:@"app/bless/getAfterTimestamp" onCompletion:^(id responseData) {
            DLog(@"%@",responseData);
            self.context =(NSMutableArray *) responseData;
            [self.socialTableView reloadData];
        } onError:^(int errorCode, NSString *errorMessage) {
            //
        }];
        [engine release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"亲友圈"];
    
    [self.view addSubview:self.socialTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.socialTableView = nil;
    self.context = nil;
    [super dealloc];
}

#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.context count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *contexDic= self.context[indexPath.row];
    cell.textLabel.text = [contexDic jsonObjectForKey:@"name"];
    cell.detailTextLabel.text = [contexDic jsonObjectForKey:@"content"];;
    return cell;
}

@end
