//
//  RequstEngine.h
//  Wedding
//
//  Created by lgqyhm on 13-7-22.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface RequstEngine : MKNetworkEngine

typedef void (^ErrorBlock)(int errorCode, NSString *errorMessage);

typedef void (^SuccessBlock)(id responseData);


- (void)getDataWithParam:(NSDictionary * )params
                               url:(NSString *)url
                      onCompletion:(SuccessBlock)successBlock
                           onError:(ErrorBlock)errorBlock;

- (void)getSelectionPicWithParam:(NSDictionary * )params
                     url:(NSString *)url
            onCompletion:(SuccessBlock)successBlock
                 onError:(ErrorBlock)errorBlock;

- (void)postDataWithParam:(NSDictionary *)params imgData:(NSData *)imgData url:(NSString *)url onCompletion:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

- (void)PostSendDataWithParam:(NSDictionary * )params
                          url:(NSString *)url
                 onCompletion:(SuccessBlock)successBlock
                      onError:(ErrorBlock)errorBlock;

@end
