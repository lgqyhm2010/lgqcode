//
//  WeddingDelegate.m
//  Wedding
//
//  Created by lgqyhm on 13-7-8.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "WeddingDelegate.h"
#import "MCNotification.h"
#import "WedTabBarViewController.h"
#import "LoginViewController.h"
#import "RequstEngine.h"
#import "UIDeviceHardware.h"
#import "ParseLoginParams.h"
#import "RegisterViewController.h"

@interface WeddingDelegate ()

@property (nonatomic,retain)LoginViewController *loginVC;

@end

@implementation WeddingDelegate

#pragma mark getter

- (MCNotification *)notification
{
    if (!_notification) {
        _notification = [[MCNotification alloc]init];
    
    }
    return _notification;
}

- (WedTabBarViewController *)tabBarViewController
{
    if (!_tabBarViewController) {
        _tabBarViewController = [[WedTabBarViewController alloc]init];
    }
    return _tabBarViewController;
}

- (LoginViewController *)loginVC
{
    if (!_loginVC) {
        _loginVC = [[LoginViewController alloc]init];
    }
    return _loginVC;
}


//文件路径

- (NSString *)documentPath
{
    static NSString *_path;
    
    if (!_path)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _path = [[paths objectAtIndex:0] copy];
    }
    
    return _path;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    self.window.rootViewController =self.tabBarViewController;// [[UINavigationController alloc]initWithRootViewController:self.tabBarViewController];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults]boolForKey:KIsLogin];
    __block WeddingDelegate *weddingDelegate = self;
    if (isLogin) {
        self.window.rootViewController = self.tabBarViewController;
    }else   {
    NSDictionary *param = @{@"op": @"user.login",@"user.simId":[UIDeviceHardware getDeviceUUID]};
    RequstEngine *engine = [[RequstEngine alloc]init];
    [engine getDataWithParam:param url:@"app/user/login" onCompletion:^(id responseData) {
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:responseData forKey:kLoginData];
            [archiver finishEncoding];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:KEnduringLoginData];
            ParseLoginParams *loginParams = [[ParseLoginParams alloc]init];
            [loginParams parseLogin:responseData];
            [[NSUserDefaults standardUserDefaults]setObject:loginParams.userID forKey:KUerID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            weddingDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:weddingDelegate.loginVC];
        }
    } onError:^(int errorCode, NSString *errorMessage) {
        if (!errorMessage) {
            RegisterViewController *registerVC = [[RegisterViewController alloc]init];
            weddingDelegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:registerVC];

        }
    }];
    }
    [self.window makeKeyAndVisible];
    [[NSNotificationCenter defaultCenter]addObserver:Guider object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        weddingDelegate.tabBarViewController = nil;
        [weddingDelegate.window setRootViewController:weddingDelegate.tabBarViewController];
    } inClass:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:KCancelWedding object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weddingDelegate.window setRootViewController:[[UINavigationController alloc]initWithRootViewController:weddingDelegate.loginVC]];
    } inClass:self];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
