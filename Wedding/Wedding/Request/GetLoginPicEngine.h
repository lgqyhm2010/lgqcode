//
//  GetLoginPicEngine.h
//  CaiYun
//
//  Created by lusonglin on 13-4-7.
//
//  启动图


#import "MKNetworkKit.h"

@interface GetLoginPicEngine : MKNetworkEngine

// 失败回调
typedef void (^ErrorBlock)(int errorCode, NSString *errorMessage);

// 查询成功回调
typedef void (^QuerySuccessBlock)(NSDictionary *resultDictionary);

// 下载成功回调
typedef void (^DownloadSuccessBlock)(NSData *imageData);


// @fn 获取启动图
// @param successBlock 查询成功的回调
// @param errorBlock 查询失败的回调
- (void)getLoginPicOnCompletion:(QuerySuccessBlock)successBlock
                        onError:(ErrorBlock)errorBlock;


// @fn 下载启动图
// @param successBlock 下载成功的回调
// @param errorBlock 下载失败的回调
- (void)downloadWithUrlString:(NSString *)urlString
                 onCompletion:(DownloadSuccessBlock)successBlock
                      onError:(ErrorBlock)errorBlock;



@end