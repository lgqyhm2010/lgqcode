//
//  RPCRequestEngine.h
//  CaiYun
//
//  Created by lusonglin on 13-6-21.
//
//  RPC请求通用类 

#import <Foundation/Foundation.h>

@interface RPCRequestEngine : NSObject


- (id) initWithServiceURL:(NSString*) URL;


// 请求失败
typedef void (^RPCSingleCallErrorBlock)(int errorCode, NSString *errorMessage);

// 请求数据成功
typedef void (^RPCSingleCallSuccessBlock)(id resultObject);


//  @fn 单个请求
//  @param method  接口方法名
//  @param otherParams  除固定的基本参数（client_id、from、version、device_id）外的其他参数 
//  @param successBlock(id resultObject)  调用成功才存在
//  @param errorBlock(int errorCode, NSString *errorMessage)  失败回调
- (void)singleCallWithMethod:(NSString* )method
                 OtherParams:(NSDictionary* )otherParams
                onCompletion:(RPCSingleCallSuccessBlock)successBlock
                     onError:(RPCSingleCallErrorBlock)errorBlock;


// 失败回调
typedef void (^RPCBatchCallErrorBlock)(int index, int errorCode, NSString *errorMessage);

// 成功回调
typedef void (^RPCBatchCallSuccessBlock)(int index, id resultObject);

// 成批完成后回调
typedef void (^RPCBatchCallFinishedBlock)(void);

//  @fn 批量请求
//  @param allParams  包含每次请求参数的数组
//  @param successBlock 查询成功的回调
//  @param errorBlock   失败回调
//  @param finishedBlock  所有请求结束的回调
- (void)batchCallWithParams:(NSArray* )allParams
               OnCompletion:(RPCBatchCallSuccessBlock)successBlock
                    onError:(RPCBatchCallErrorBlock)errorBlock
                 onFinished:(RPCBatchCallFinishedBlock)finishedBlock;


@end
