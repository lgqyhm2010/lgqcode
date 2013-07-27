//
//  PhotoDetailViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-26.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "ParsePhotoParams.h"
#import "UIImageView+WebCache.h"

#define KHeight  CGRectGetHeight(self.view.frame)-44

@interface PhotoDetailViewController ()<UIScrollViewDelegate>
{
    int currenCout;
}
@property (nonatomic,retain) NSArray *photos;
@property (nonatomic,retain)UIScrollView *photoDetailScrollView;


@end

@implementation PhotoDetailViewController

- (UIScrollView *)photoDetailScrollView
{
    if (!_photoDetailScrollView) {
        _photoDetailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, KHeight)];
        _photoDetailScrollView.pagingEnabled = YES;
        _photoDetailScrollView.delegate = self;
    }
    
    return _photoDetailScrollView;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhotos:(NSArray *)photos currentPhotoIndex:(int)index
{
    if (self = [super init]) {
        self.photos = photos;
        currenCout = index;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    int photoCount = self.photos.count;
    self.photoDetailScrollView.contentSize = CGSizeMake(320*photoCount, KHeight);
    [self.photoDetailScrollView setContentOffset:CGPointMake(320*currenCout, 0)];
    
    for (int index = 0; index <photoCount; index++) {
        ParsePhotoParams *params = self.photos[index];
        float ratioWidth = (float)params.width/320;
        CGRect frame = CGRectMake(0, 0, 320, params.height/ratioWidth);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
        UIImage *img = [UIImage imageNamed:@"feedback_content"];
        imgView.center = CGPointMake(self.view.center.x + 320*index, CGRectGetHeight(self.view.frame)/2-10);
        NSURL *url = [NSURL URLWithString:params.url];
        [imgView setImageWithURL:url placeholderImage:img];
        [self.photoDetailScrollView addSubview:imgView];
        
    }
    [self.view addSubview:self.photoDetailScrollView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *title = [NSString stringWithFormat:@"%d/%d",currenCout+1,self.photos.count ];
    [self setNavigationTitle:title];
    [self setBackNavigationItemTitle:@"返回"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    int index = offset.x/320;
    NSString *title = [NSString stringWithFormat:@"%d/%d",index+1,self.photos.count ];
    [self setNavigationTitle:title];

}

@end
