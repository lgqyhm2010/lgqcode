//
//  GuidePhotoViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-21.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "GuidePhotoViewController.h"

@protocol guideDelegate <NSObject>

- (void)hiddenBar:(BOOL)hidden;

@end

@interface GuideScrollerView : UIScrollView
{
    BOOL hidden;
}
@property (nonatomic,assign)id<guideDelegate>guideDelegate;

@end

@implementation GuideScrollerView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    hidden = !hidden;
        if ([self.guideDelegate conformsToProtocol:@protocol(guideDelegate)]) {
            [self.guideDelegate hiddenBar:hidden];
    }
}


@end

@interface GuidePhotoViewController ()<UIScrollViewDelegate,guideDelegate>
{
    EntryType entryType;
}

@property (nonatomic,retain) GuideScrollerView *guidePhoto;

@end

@implementation GuidePhotoViewController

#pragma mark getter

- (GuideScrollerView *)guidePhoto
{
    if (!_guidePhoto) {
        CGFloat height = CGRectGetHeight(self.view.frame);
        _guidePhoto = [[GuideScrollerView alloc]initWithFrame:CGRectMake(0, 0, 320*3, height)];
        for (int index = 1; index<4; index++) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320*index, height)];
            NSString *imagPath = [NSString stringWithFormat:@"guide_photo%d",index];
            imgView.image = [UIImage imageNamed:imagPath];
            [_guidePhoto addSubview:imgView];
            [imgView release];
        }
        _guidePhoto.delegate = self;
        _guidePhoto.guideDelegate = self;
    }
    return _guidePhoto;
}

#pragma mark view lifestyle

- (id)initWithEntryType:(EntryType)type
{
    if (self==[super init]) {
        entryType = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
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
    [self setBackNavigationItemTitle:@"返回"];
    [self.view addSubview:self.guidePhoto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.guidePhoto = nil;
    [super dealloc];
}

- (void)hiddenBar:(BOOL)hidden
{
    CGFloat height = CGRectGetHeight(self.view.frame);
    if (hidden) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view setFrame:CGRectMake(0, 0, 320, height)];
    }else
    {
        [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.view setFrame:CGRectMake(0, -100, 320, height)];
    }
}

@end
