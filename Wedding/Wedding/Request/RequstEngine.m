//
//  RequstEngine.m
//  Wedding
//
//  Created by lgqyhm on 13-7-22.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "RequstEngine.h"

@interface RequstEngine ()
// 保存请求
@property (nonatomic, retain) NSMutableArray *operations;

- (void)cancelOperations;

@end

@implementation RequstEngine
@synthesize operations = _operations;

- (void)setOperations:(NSMutableArray *)operations
{
    if (_operations != operations)
    {
        [_operations release];
        _operations = [operations retain];
    }
}

- (NSMutableArray *)operations
{
    if (_operations == nil)
    {
        _operations = [[NSMutableArray alloc] init];
    }
    
    return _operations;
}

- (void)cancelOperations
{
    for (MKNetworkOperation *op in self.operations)
    {
        if (![op isFinished])
            [op cancel];
    }
    
    self.operations = nil;
}
- (void)dealloc
{
    [self cancelOperations];
    [super dealloc];
}

- (void)getSelectionPicWithParam:(NSDictionary *)params url:(NSString *)url onCompletion:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSString *urlSting = [NSString stringWithFormat:@"%@%@",KRomanticURL,url];
    MKNetworkOperation *op = [self operationWithURLString:urlSting params:params httpMethod:@"GET"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeCustom];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return [postDataDict JSONString];
    } forType:@"application/x-www-form-urlencoded"];
    
    // 保存起以支持取消操作
    [self.operations addObject:op];
    
    DLog(@"%@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [self.operations removeObject:op];
         
         NSString *responseString = completedOperation.responseString;
         
         NSDictionary *responseDictionary = [responseString objectFromJSONString];
         
         if ([responseDictionary jsonObjectForKey:@"result"]){
             NSDictionary *dic = [responseDictionary jsonObjectForKey:@"result"];
             if ([dic jsonObjectForKey:@"pictures"]) {
                 id data = [dic jsonObjectForKey:@"pictures"];
                 //成功回调
                 successBlock(data);
             }
             
         }else{
             // 失败
             NSDictionary *errorDic = (NSDictionary *)[responseDictionary jsonObjectForKey:@"error"];
             int errorCode = [[errorDic jsonObjectForKey:@"code"] intValue] ;
             NSString *errorMessage =  [errorDic jsonObjectForKey:@"message"];
             
             //失败回调
             errorBlock(errorCode, errorMessage);
             
         }
         
         
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         // 失败回调
         [self.operations removeObject:op];
         
         // 系统级的错误
         //         errorBlock(NSNetCodeNetError, KNetErrorDefault);
     }];
    
    [self enqueueOperation:op];
    

}

- (void)getDataWithParam:(NSDictionary * )params
                                url:(NSString *)url
                      onCompletion:(SuccessBlock)successBlock
                           onError:(ErrorBlock)errorBlock{
    NSString *urlSting = [NSString stringWithFormat:@"%@%@",KRomanticURL,url];
    MKNetworkOperation *op = [self operationWithURLString:urlSting params:params httpMethod:@"GET"];
    [op setPostDataEncoding:MKNKPostDataEncodingTypeCustom];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return [postDataDict JSONString];
    } forType:@"application/x-www-form-urlencoded"];
    
    // 保存起以支持取消操作
    [self.operations addObject:op];
    
    DLog(@"%@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [self.operations removeObject:op];
         
         NSString *responseString = completedOperation.responseString;
         
         NSDictionary *responseDictionary = [responseString objectFromJSONString];
         
         if ([responseDictionary jsonObjectForKey:@"result"]){
             id  data = [responseDictionary jsonObjectForKey:@"result"];
             //成功回调
             successBlock(data);
         }else{
             // 失败
             NSDictionary *errorDic = (NSDictionary *)[responseDictionary jsonObjectForKey:@"error"];
             int errorCode = [[errorDic jsonObjectForKey:@"code"] intValue] ;
             NSString *errorMessage =  [errorDic jsonObjectForKey:@"message"];
             
             //失败回调
             errorBlock(errorCode, errorMessage);
             
         }
         
         
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         // 失败回调
         [self.operations removeObject:op];
         
         // 系统级的错误
//         errorBlock(NSNetCodeNetError, KNetErrorDefault);
     }];
    
    [self enqueueOperation:op];
    
}

@end
