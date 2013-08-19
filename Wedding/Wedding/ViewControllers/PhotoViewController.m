//
//  PhotoViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-10.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PhotoViewController.h"
#import "RequstEngine.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "ParsePhotoParams.h"
#import "PhotoDetailViewController.h"

#define KPhotoTag1      1000
#define KPhotoTag2      1001
#define KWidth          160


@interface PhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isLoad;
}

@property (nonatomic,strong) UITableView *photoTableview1;
@property (nonatomic,strong) UITableView *photoTableView2;
@property (nonatomic,strong) NSMutableArray *photoArray1;
@property (nonatomic,strong) NSMutableArray *photoArray2;
@property (nonatomic,strong) NSMutableArray *photoArray;

@end

@implementation PhotoViewController

#pragma mark getter
#define Height CGRectGetHeight(self.view.frame) - 88

- (UITableView *)photoTableview1
{
    if (!_photoTableview1) {
        _photoTableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KWidth, Height) style:UITableViewStylePlain];
        _photoTableview1.delegate = self;
        _photoTableview1.dataSource = self;
        _photoTableview1.showsVerticalScrollIndicator = NO;
        _photoTableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _photoTableview1.tag = KPhotoTag1;
    }
    return _photoTableview1;
}

- (UITableView *)photoTableView2
{
    if (!_photoTableView2) {
        _photoTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(KWidth, 0, KWidth, Height) style:UITableViewStylePlain];
        _photoTableView2.delegate = self;
        _photoTableView2.dataSource = self;
        _photoTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _photoTableView2.tag = KPhotoTag2;
    }
    return _photoTableView2;
}

- (NSMutableArray *)photoArray1
{
    if (!_photoArray1) {
        _photoArray1 = [[NSMutableArray alloc]init];
    }
    return _photoArray1;
}

- (NSMutableArray *)photoArray2
{
    if (!_photoArray2) {
        _photoArray2 = [[NSMutableArray alloc]init];
    }
    return _photoArray2;
}


- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [[NSMutableArray alloc]init];
    }
    return _photoArray;
}



- (void)getPhotoData
{
//    [Notification showWaitView:@"请稍等" animation:YES];
    RequstEngine *engine = [[RequstEngine alloc]init];
    if (self.photoArray1) {
        [self.photoArray1 removeAllObjects];
    }
    if (self.photoArray2) {
        [self.photoArray2 removeAllObjects];
    }
    if (self.photoArray) {
        [self.photoArray removeAllObjects];
    }
    __block PhotoViewController *thumbVC = self;
    NSString *weddingID = [[NSUserDefaults standardUserDefaults]objectForKey:KWeddingID];
    NSDictionary *param = @{@"op": @"wedding.getPictureList",@"wedding.id":weddingID};
    [engine getDataWithParam:param url:@"app/wedding/getPictureList" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSArray class]]) {
            for (int i = 0; i<[responseData count]; i++) {
                ParsePhotoParams *photoParse = [[ParsePhotoParams alloc]init];
                [photoParse parse:responseData[i]];
                [thumbVC.photoArray addObject:photoParse];
                if (i%2 == 0) {
                    [thumbVC.photoArray1  addObject:photoParse];
                }else
                    [thumbVC.photoArray2 addObject:photoParse];
            }
//            [Notification hiddenWaitView:NO];
            [thumbVC.photoTableview1 reloadData];
            [thumbVC.photoTableView2 reloadData];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
//        [Notification hiddenWaitView:NO];

    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isLoad) {
        [self.view addSubview:self.photoTableview1];
        [self.view addSubview:self.photoTableView2];
    }
    isLoad = YES;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self getPhotoData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationTitle:@"婚纱照"];
    [self setRightNavigationItemTitle:@"刷新" selector:@selector(getPhotoData)];
    [self setNavigationItemNormalImage:@"refresh_icon_normal.png" HightImage:@"refresh_icon_click.png" selector:@selector(getPhotoData) isRight:YES];
    
    CGFloat height = CGRectGetHeight(self.view.frame) - 88;
    self.photoTableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 160, height)];
    self.photoTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(160, 0, 160, height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark tableview datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == KPhotoTag1 ) {
        return self.photoArray1.count;
    }else if (tableView.tag == KPhotoTag2)
        return self.photoArray2.count;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == KPhotoTag1) {
        static NSString *cellIdentifier1 = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ParsePhotoParams *params = self.photoArray1[indexPath.row];
        UIImage *img = [UIImage imageNamed:@"photo_bg"];
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView setImageWithURL:[NSURL URLWithString:params.thumbnailurl] placeholderImage:img];
        cell.backgroundView = imgView;
       
        return cell;
        
    }else if (tableView.tag == KPhotoTag2)  {
        static NSString *cellIdentifier2 = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ParsePhotoParams *params = self.photoArray2[indexPath.row];
        UIImage *img = [UIImage imageNamed:@"photo_bg"];
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView setImageWithURL:[NSURL URLWithString:params.thumbnailurl] placeholderImage:img];
        cell.backgroundView = imgView;
        return cell;
        
    }
    return nil;
    
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == KPhotoTag1) {
        ParsePhotoParams *params = self.photoArray1[indexPath.row];
        float ratio = (float)params.thumbnailWidth/KWidth;
        return params.thumbnailHeight/ratio;
    }else if (tableView.tag == KPhotoTag2)  {
        ParsePhotoParams *params = self.photoArray2[indexPath.row];
        float ratio = (float)params.thumbnailWidth/KWidth;
        return params.thumbnailHeight/ratio;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int currenIndex = tableView.tag == KPhotoTag1?indexPath.row*2:indexPath.row*2+1;
    
    PhotoDetailViewController *detailVC = [[PhotoDetailViewController alloc]initWithPhotos:self.photoArray currentPhotoIndex:currenIndex];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark scrollerview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == KPhotoTag1) {
        [self.photoTableView2 setContentOffset:self.photoTableview1.contentOffset];
        
    }else if (scrollView.tag == KPhotoTag2)   {
        [self.photoTableview1 setContentOffset:self.photoTableView2.contentOffset];

    }
}

@end
