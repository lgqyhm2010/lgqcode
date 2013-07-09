//
//  MCNotification.h
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCNotification : NSObject

-(void)showWaitViewInView:(UIView*)view//添加在要展示的view
                animation:(BOOL)animated//显示时是否添加动画
                 withText:(NSString*)text//要展示的文本
             withDuration:(CGFloat)duration//弹出动画时间
           hideWhenFinish:(BOOL)hideWhenFinish//展示后是否自动移除
            showIndicator:(BOOL)indicator;//是否显示菊花

-(void)showWaitViewInView:(UIView*)view
                animation:(BOOL)animated
                 withText:(NSString*)text
             withDuration:(CGFloat)duration
           hideWhenFinish:(BOOL)hideWhenFinish
            showIndicator:(BOOL)indicator
               completion:(void(^)(void))completion;

- (void)hiddenWaitView:(BOOL)animated ;
- (void)hiddenWaitView:(BOOL)animated completion:(void(^)(void))completion ;

- (void)showWaitViewInViewWithoutIndicator:(UIView*)view text:(NSString*)text animation:(BOOL)animation hideWithAnimated:(BOOL)hideWithAnimated ;
- (void)showWaitView:(NSString*)text animation:(BOOL)animation ;//在AppDelegate的window里面展示等待提示，整个界面的事件会被禁用，展示菊花
- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation ;//指定的view里面里面展示等待提示，整个界面的事件会被禁用，展示菊花
- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation showIndicator:(BOOL)indicator ;//指定的view里面里面展示等待提示，整个界面的事件会被禁用，可以指定是否显示菊花
- (void)showWaitView:(NSString*)text animation:(BOOL)animation hideWhenAnimated:(BOOL)hideWithAnimated ;//在AppDelegate的window里面展示等待提示，整个界面的事件会被禁用，展示菊花

//以下方法MCNotification的显示均没有添加在主线程显示。如若用线程启动一下代码，请自行添加代码，使其在主线程里运行
- (void)showWaitViewInViewWithoutIndicator:(UIView*)view text:(NSString*)text animation:(BOOL)animation hideWithAnimated:(BOOL)hideWithAnimated completion:(void(^)(void))completion;
- (void)showWaitView:(NSString*)text animation:(BOOL)animation hideWhenAnimated:(BOOL)hideWithAnimated completion:(void(^)(void))completion;
- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation showIndicator:(BOOL)indicator completion:(void(^)(void))completion;
- (void)showWaitViewInView:(UIView*)view text:(NSString*)text animation:(BOOL)animation completion:(void(^)(void))completion;
- (void)showWaitView:(NSString*)text animation:(BOOL)animation completion:(void(^)(void))completion;

//alerView 提示
-(void)showMsg:(id)delegate title:(NSString*)title message:(NSString*)msg tag:(NSInteger)tag;
-(void)showMsgConfirm:(id)delegate title:(NSString*)title message:(NSString*)msg tag:(NSInteger)tag;
-(void)showMsgWithBtnStr:(id)delegate title:(NSString*)title message:(NSString*)msg leftBtn:leftStr rightBtn:rightStr tag:(NSInteger)tag;

@end
