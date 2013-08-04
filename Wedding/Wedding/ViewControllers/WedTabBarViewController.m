//
//  WedTabBarViewController.m
//  Wedding
//
//  Created by lgqyhm on 13-7-11.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WedTabBarViewController.h"
#import "WeddingViewController.h"
#import "SocialViewController.h"
#import "PhotoViewController.h"
#import "VideoViewController.h"
#import "SettingViewController.h"

enum
{
    WeddingIndex=0,
    SocialIndex,
    PhotoIndex,
    VideoIndex,
    SettingIndex
};
typedef NSInteger WedTabIndex;

@interface WedTabBarViewController ()

@end

@implementation WedTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        backImg.image = [UIImage imageNamed:@"tab_bg"];
        [self.tabBar addSubview:backImg];
        FreeMemory(backImg);
        
        NSMutableArray *controllers = [NSMutableArray array];
        
        WeddingViewController *wedding = [[WeddingViewController alloc]init];
//        wedding.tabBarItem.title = @"首页";
        UINavigationController *weddingNav = [[UINavigationController alloc]initWithRootViewController:wedding];
        UITabBarItem *weddingItem = [[UITabBarItem alloc]init];
        [weddingItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_home_icon_inactive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_home_icon_active"]];
        weddingNav.tabBarItem = weddingItem;
        FreeMemory(weddingItem);
        [controllers addObject:weddingNav];
        FreeMemory(wedding);
        FreeMemory(weddingNav);
        
        SocialViewController *social = [[SocialViewController alloc]init];
//        social.tabBarItem.title = @"亲友圈";
        UINavigationController *socialNav = [[UINavigationController alloc]initWithRootViewController:social];
        UITabBarItem *socialItem = [[UITabBarItem alloc]init];
        [socialItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_msg_icon_inactive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_msg_icon_active"]];
        socialNav.tabBarItem = socialItem;
        FreeMemory(socialItem);
        [controllers addObject:socialNav];
        FreeMemory(social);
        FreeMemory(socialNav);
        
        PhotoViewController *photo = [[PhotoViewController alloc]init];
//        photo.tabBarItem.title = @"婚纱照";
        UINavigationController *photoNav = [[UINavigationController alloc]initWithRootViewController:photo];
        UITabBarItem *photoItem = [[UITabBarItem alloc]init];
        [photoItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_photo_icon_inactive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_photo_icon_active"]];
        photoNav.tabBarItem = photoItem;
        FreeMemory(photoItem);
        [controllers addObject:photoNav];
        FreeMemory(photo);
        FreeMemory(photoNav);
        
        VideoViewController *video = [[VideoViewController alloc]init];
//        video.tabBarItem.title = @"视频集";
        UINavigationController *videoNav = [[UINavigationController alloc]initWithRootViewController:video];
        UITabBarItem *videoItem = [[UITabBarItem alloc]init];
        [videoItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_video_icon_inactive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_video_icon_active"]];
        videoNav.tabBarItem = videoItem;
        FreeMemory(videoItem);
        [controllers addObject:videoNav];
        FreeMemory(video);
        FreeMemory(videoNav);
        
        SettingViewController *setting = [[SettingViewController alloc]init];
//        setting.tabBarItem.title = @"设置";
        UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:setting];
        UITabBarItem *settingItem = [[UITabBarItem alloc]init];
        [settingItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_setting_icon_inactive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_setting_icon_active"]];
        settingNav.tabBarItem = settingItem;
        FreeMemory(settingItem);
        [controllers addObject:settingNav];
        FreeMemory(setting);
        FreeMemory(settingNav);
        
        [self setViewControllers:controllers];
        [self setSelectedIndex:WeddingIndex];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
