//
//  AppDelegate.h
//  Wedding
//
//  Created by lgqyhm on 13-7-8.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuperViewController;
@class MCNotification;

@interface WeddingDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SuperViewController *viewController;
@property (strong, nonatomic) MCNotification *notification;

@end
