//
//  SocialViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SocialViewController.h"
#import "RequstEngine.h"
#import "ParseWishingParsms.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SendWishViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f


@interface SociaCell : UITableViewCell

@property (nonatomic,retain)UIImageView *personImage;
@property (nonatomic,retain)UILabel *name;
@property (nonatomic,retain)UIImageView *sex;
@property (nonatomic,retain)UILabel *content;
@property (nonatomic,retain)UILabel *createTime;
@property (nonatomic,retain)UIImageView *introView;
@property (nonatomic,retain)UIImageView *cellContextView;
@property (nonatomic,strong)UIImageView *creatTimeImg;
@property (nonatomic,strong) UIImageView *wishImage;


@end

@implementation SociaCell

#pragma mark getter

- (UIImageView *)personImage
{
    if (!_personImage) {
        _personImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        
    }
    return _personImage;
}

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 40, 15)];
        _name.textColor = [UIColor colorWithHexString:@"b0e7dc"];
        _name.backgroundColor = [UIColor clearColor];
        _name.font = [ToolSet customNormalFontWithSize:10];
    }
    return _name;
}

- (UIImageView *)sex
{
    if (!_sex) {
        _sex = [[UIImageView alloc]initWithFrame:CGRectMake(40, 25, 10, 10)];
    }
    return _sex;
}

- (UILabel *)content
{
    if (!_content) {
        _content = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 280, 70)];
        _content.textColor = [UIColor whiteColor];
        _content.backgroundColor = [UIColor clearColor];
        _content.numberOfLines = 0;
        _content.font = [ToolSet customNormalFontWithSize:10];

    }
    return _content;
}

- (UILabel *)createTime
{
    if (!_createTime) {
        _createTime = [[UILabel alloc]initWithFrame:CGRectMake(250, 125, 60, 20)];
        _createTime.textColor = [UIColor colorWithHexString:@"ff91b4"];
        _createTime.backgroundColor = [UIColor clearColor];
        _createTime.font = [ToolSet customNormalFontWithSize:10];
    }
    return _createTime;
}

- (UIImageView *)introView
{
    if (!_introView) {
        _introView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
        UIImage *img = [[UIImage imageNamed:@"message_item_content_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _introView.image =img ;
    }
    return _introView;
}

- (UIImageView *)cellContextView
{
    if (!_cellContextView) {
        _cellContextView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 290, 100)];
        UIImage *img = [[UIImage imageNamed:@"message_item_content_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
        _cellContextView.image = img;
    }
    return _cellContextView;
}

- (UIImageView *)wishImage
{
    if (!_wishImage) {
        _wishImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _wishImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.cellContextView addSubview:self.content];
        [self.cellContextView addSubview:self.wishImage];
        [self.contentView addSubview:self.cellContextView];
        
        [self.introView addSubview:self.personImage];
        [self.introView addSubview:self.name];
        [self.introView addSubview:self.sex];
        [self.contentView addSubview:self.introView];
        
        [self.contentView addSubview:self.createTime];
        
    }
return self;
}


@end

@interface SocialViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isDragging;
    BOOL isload;
   
    
}

@property (nonatomic,retain)UITableView *socialTableView;
@property (nonatomic,retain)NSMutableArray *context;
@property (nonatomic,retain)UIView *refreshHeaderView;
@property (nonatomic,retain)UILabel *refreshLabel;
@property (nonatomic,retain)UIImageView *refreshArrow;
@property (nonatomic,retain)UIActivityIndicatorView *refreshSpinner;
@property (nonatomic) BOOL isLoading;
@property (nonatomic,strong) NSString *beforeTimeStamp;
@property (nonatomic,strong) NSString *afterTimeStamp;

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
        _socialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _socialTableView.backgroundView = nil;
        _socialTableView.backgroundColor = [UIColor clearColor];
        
    }
    return _socialTableView;
}

- (UIView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        
    }
    return _refreshHeaderView;
}

- (UILabel *)refreshLabel
{
    if (!_refreshLabel) {
        _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
        _refreshLabel.backgroundColor = [UIColor clearColor];
        _refreshLabel.font = [ToolSet customNormalFontWithSize:14];
        _refreshLabel.textAlignment = UITextAlignmentCenter;

    }
    return _refreshLabel;
}

- (UIImageView *)refreshArrow
{
    if (!_refreshArrow) {
        _refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        _refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                        (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                        27, 44);

    }
    return _refreshArrow;
}

- (UIActivityIndicatorView *)refreshSpinner
{
    if (!_refreshSpinner) {
        _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
        _refreshSpinner.hidesWhenStopped = YES;

    }
    return _refreshSpinner;
}

#pragma mark view lifestyle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        __block SocialViewController *sociaVC = self;
        RequstEngine *engine = [[RequstEngine alloc]init];
        NSString *weddingID = [[NSUserDefaults standardUserDefaults]objectForKey:KWeddingID];
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970]*1000;
        
        NSString *timestamp = [NSString stringWithFormat:@"%lld",(long long)timeinterval];
        NSDictionary *params = @{@"op": @"bless.getBefortTimestamp",@"bless.timeStamp":timestamp,@"bless.weddingId":weddingID};
        [engine getDataWithParam:params url:@"app/bless/getBefortTimestamp" onCompletion:^(id responseData) {
            if ([responseData isKindOfClass:[NSArray class]]) {
                for (int index= [responseData count]-1; index>=0; index--) {
                    ParseWishingParsms *params = [[ParseWishingParsms alloc]init];
                    [params parseWishingData:responseData[index]];
                    [sociaVC.context addObject:params];
                    if (index == 0) {
                        sociaVC.afterTimeStamp = params.timeStamp;
                    }
                    if (index == [responseData count]-1) {
                       sociaVC.beforeTimeStamp = params.timeStamp;

                    }
                }
            }
            [sociaVC.socialTableView reloadData];
        } onError:^(int errorCode, NSString *errorMessage) {
            //
        }];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

- (void)sendWish
{
    SendWishViewController *sendWishVC = [[SendWishViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sendWishVC];
    [self presentModalViewControllerMy:nav animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"祝福墙"];
    [self setNavigationItemNormalImage:@"write_icon_normal.png" HightImage:@"write_icon_pressed.png" selector:@selector(sendWish) isRight:YES];
    
    CGFloat height = CGRectGetHeight(self.view.frame) - 88;
    self.socialTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    DLog(@"afer %@,before %@",self.afterTimeStamp,self.beforeTimeStamp);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isload) {
        UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
        backView.image = [UIImage imageNamed:@"message_big_bg3.jpg"];
        [self.view addSubview:backView];
//        [self.view sendSubviewToBack:backView];
        [self.refreshHeaderView addSubview:self.refreshLabel];
        [self.refreshHeaderView addSubview:self.refreshArrow];
        [self.refreshHeaderView addSubview:self.refreshSpinner];
        [self.socialTableView addSubview:self.refreshHeaderView];
        [self.view addSubview:self.socialTableView];
    }
    isload = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.context count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    SociaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SociaCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ParseWishingParsms *params= self.context[indexPath.row];
    [cell.personImage setImageWithURL:[NSURL URLWithString:params.pictureUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    if (params.pictures.length>0) {
        cell.wishImage.frame = CGRectMake(100, 90, 80, 100);
        [cell.wishImage setImageWithURL:[NSURL URLWithString:params.pictures] placeholderImage:[UIImage imageNamed:@"photo_bg"]];
        cell.createTime.frame = CGRectMake(CGRectGetMidX(cell.createTime.frame), CGRectGetMidY(cell.createTime.frame), CGRectGetWidth(cell.createTime.frame), CGRectGetHeight(cell.createTime.frame) + 100);
        cell.cellContextView.frame = CGRectMake(CGRectGetMinX(cell.cellContextView.frame), CGRectGetMinY(cell.cellContextView.frame), CGRectGetWidth(cell.cellContextView.frame), CGRectGetHeight(cell.cellContextView.frame)+100);
    }
    cell.name.text = params.name;
    cell.content.text = params.content;
    cell.createTime.text = params.createTime;
    
    return cell;
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParseWishingParsms *params= self.context[indexPath.row];
    if (params.pictures.length>0) {
        return 250;
    }
    return 150;
}

#pragma mark scrollerview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.socialTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.socialTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        __block SocialViewController *socialVC = self;
        [UIView animateWithDuration:0 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                socialVC.refreshLabel.text = @"放开以刷新...";
                [socialVC.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { // User is scrolling somewhere within the header
                socialVC.refreshLabel.text = @"下拉刷新...";
                [socialVC.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }

        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    self.isLoading = YES;
    
    // Show the header
    __block SocialViewController *socialVC = self;
    [UIView animateWithDuration:0.3 animations:^{
        [socialVC.socialTableView setContentInset:UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0)];
        socialVC.refreshLabel.text = @"正在刷新...";
        socialVC.refreshArrow.hidden = YES;
        [socialVC.refreshSpinner startAnimating];

    }];
    // Refresh action!
    [self refresh];
}


- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    __block SocialViewController *sociaVC = self;
    RequstEngine *engine = [[RequstEngine alloc]init];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:KUerID];

    NSDictionary *params = @{@"op": @"bless.getAfterTimestamp",@"bless.timeStamp":self.afterTimeStamp,@"bless.weddingId":userID};
    [engine getDataWithParam:params url:@"app/bless/getAfterTimestamp" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSArray class]]) {
//            if (sociaVC.context) {
//                [sociaVC.context removeAllObjects];
//            }
            for (int index= [responseData count]-1; index>=0; index--) {
                ParseWishingParsms *params = [[ParseWishingParsms alloc]init];
                [params parseWishingData:responseData[index]];
                [sociaVC.context addObject:params];
            }
        }
       sociaVC.isLoading = NO;
        [UIView animateWithDuration:0.3 animations:^{
            sociaVC.socialTableView.contentInset = UIEdgeInsetsZero;
            [sociaVC.refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        } completion:^(BOOL finished) {
            sociaVC.refreshLabel.text = @"下拉刷新...";
            sociaVC.refreshArrow.hidden = NO;
            [sociaVC.refreshSpinner stopAnimating];
            [sociaVC.socialTableView reloadData];
        }];

    } onError:^(int errorCode, NSString *errorMessage) {
        //
    }];

}



@end
