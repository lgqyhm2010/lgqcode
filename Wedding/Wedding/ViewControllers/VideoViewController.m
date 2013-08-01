//
//  VideoViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-10.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "VideoViewController.h"
#import "ParseVideoParams.h"
#import "RequstEngine.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MPMoviePlayerViewController *movie;
}

@property (nonatomic,retain) UITableView *videoTableView;
@property (nonatomic,retain) NSMutableArray *videoList;

@end

@implementation VideoViewController

#pragma mark getter

- (NSMutableArray *)videoList
{
    if (!_videoList) {
        _videoList = [[NSMutableArray alloc]init];
    }
    return _videoList;
}

- (UITableView *)videoTableView
{
    if (!_videoTableView) {
        CGFloat height = CGRectGetHeight(self.view.frame)-88;
        _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStylePlain];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.backgroundView = nil;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _videoTableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getvieoData
{
    NSDictionary *param = @{@"op": @"wedding.getVideoList",@"wedding.id":KUerID};
    RequstEngine *engine = [[RequstEngine alloc]init];
    if (self.videoList) {
        [self.videoList removeAllObjects];
    }
    __block VideoViewController *videoVC = self;
    [engine getDataWithParam:param url:@"app/wedding/getVideoList" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSArray class]]) {
            for (int index = 0; index <[responseData count]; index++) {
                NSDictionary *data = responseData[index];
                ParseVideoParams *videoParams = [[ParseVideoParams alloc]init];
                [videoParams parseVideoParmas:data];
                [videoVC.videoList addObject:videoParams];
                [videoParams release];
            }
            [videoVC.videoTableView reloadData];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        //
    }];
    [engine release];

}

- (void)loadView
{
    [super loadView];
    [self getvieoData];
    [self.view addSubview:self.videoTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"视频集"];
    [self setNavigationItemNormalImage:@"refresh_icon_normal.png" HightImage:@"refresh_icon_pressed.png" selector:@selector(getvieoData) isRight:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.videoTableView = nil;
    self.videoList = nil;
    if(movie)
    [movie release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ParseVideoParams *params = self.videoList[indexPath.row];
    UIImage *img = [UIImage imageNamed:@"feedback_content"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 130)];
    [imgView setImageWithURL:[NSURL URLWithString:params.thumbnailUrl] placeholderImage:img];
    [cell.contentView addSubview:imgView];
    [imgView release];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 200, 10)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor blackColor];
    lable.font = [ToolSet customNormalFontWithSize:12];
    lable.text = params.info;
    [cell.contentView addSubview:lable];
    [lable release];
    return cell;
}

#pragma mark tableviw delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]init]autorelease];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParseVideoParams *params = self.videoList[indexPath.row];
    movie =  [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:params.url]];
    [movie.moviePlayer setFullscreen:YES];
    [movie.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:movie];

}

@end
