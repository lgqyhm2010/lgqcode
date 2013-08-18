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
#define Ktag 1000

#define KHeight  CGRectGetHeight(self.view.frame)-44

@interface PhotoDetailViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>
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

- (void)moreAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    [sheet showInView:self.view];
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
        UIImage *img = [UIImage imageNamed:@"photo_bg"];
        imgView.tag = Ktag + index;
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
    [self setDefaultBackClick:nil];
    [self setNavigationItemNormalImage:@"More_Button_normal.png" HightImage:@"More_Button_click.png" selector:@selector(moreAction) isRight:YES];
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

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self showPromptView:@"保存图片成功"];
}

#pragma mark actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        int index = self.photoDetailScrollView.contentOffset.x/320;
        UIImageView *imgView = (UIImageView *)[self.photoDetailScrollView viewWithTag:Ktag + index];
        UIImage *img = imgView.image;
        UIImageWriteToSavedPhotosAlbum(img, self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

@end
