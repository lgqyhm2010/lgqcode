//
//  GetLoginPicEngine.m
//  CaiYun
//
//  Created by lusonglin on 13-4-7.
//
//  启动图

#import "GetLoginPicEngine.h"



@interface GetLoginPicEngine ()
// 保存请求
@property (nonatomic, retain) NSMutableArray *operations;
- (void)cancelOperations;
- (NSDictionary *)cgiParametersForGetLoginPic;

@end


@implementation GetLoginPicEngine

#pragma mark - Life cycle
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

- (void)dealloc
{
    [self cancelOperations];
    [super dealloc];
}

#pragma mark - Public


// @fn 获取启动图
// @param successBlock 查询成功的回调
// @param errorBlock 查询失败的回调
- (void)getLoginPicOnCompletion:(QuerySuccessBlock)successBlock
                        onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithURLString:KRomanticURL params:[self cgiParametersForGetLoginPic] httpMethod:@"POST"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeCustom];
    [op setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
        return [postDataDict JSONString];
    } forType:@"application/x-www-form-urlencoded"];
    
    // 保存起以支持取消操作
    [self.operations addObject:op];
    NSLog(@"op: %@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [self.operations removeObject:op];
         
         NSString *responseString = [[NSString alloc] initWithData:[completedOperation responseData] encoding:NSUTF8StringEncoding];
         DLog(@"responseString:%@",responseString);
         NSDictionary *responseDictionary = [responseString objectFromJSONString];
         [responseString release];

         NSMutableArray* resultArray = [NSMutableArray array];
         if (isJsonDictionaryHasKeyForArray(responseDictionary, @"result"))
         {
             NSArray* tempArray = [responseDictionary jsonObjectForKey:@"result"];
             [resultArray addObjectsFromArray:tempArray];
         }else if (isJsonDictionaryHasKeyForDictionary(responseDictionary, @"result"))
         {
             NSDictionary* tempDic = [responseDictionary jsonObjectForKey:@"result"];
             [resultArray addObject:tempDic];
         }
         
         if ([resultArray count]>0)
         {
             for (NSDictionary *resultDictionary in resultArray)
             {
                 NSString* status = [resultDictionary jsonObjectForKey:@"status"];
                 if ([status isEqualToString:@"1"]) {
                     
                     // 成功
                     successBlock(resultDictionary);
                     break;
                 }
             }
         }
         else
         {
             // 失败
             NSDictionary *errorDic = (NSDictionary *)[responseDictionary jsonObjectForKey:@"error"];
             int errorCode =  [[errorDic jsonObjectForKey:@"code"] intValue];
             NSString *errorMessage =  [errorDic jsonObjectForKey:@"message"];
             
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



// @fn 下载启动图
// @param successBlock 下载成功的回调
// @param errorBlock 下载失败的回调
- (void)downloadWithUrlString:(NSString *)urlString
                 onCompletion:(DownloadSuccessBlock)successBlock
                      onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithURLString:urlString params:nil httpMethod:@"GET"];
    
    [self.operations setValue:op forKey:urlString];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [self.operations removeObject:op];
         
         NSData *_imageData = [completedOperation responseData];
         
         successBlock(_imageData);
         
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
     {
         // 失败回调
         [self.operations removeObject:op];
         // 系统级的错误
//         errorBlock(NSNetCodeNetError, @"网络环境不稳定");
     }];
    
    [self enqueueOperation:op];
}


#pragma mark - Private

- (void)cancelOperations
{
    for (MKNetworkOperation *op in self.operations)
    {
        if (![op isFinished])
            [op cancel];
    }
    
    self.operations = nil;
}

- (NSDictionary *)cgiParametersForGetLoginPic
{
////    NSString *deviceToken = [[ApnsManager sharedManager] apnsDeviceToken];
//    if (!deviceToken)
//        deviceToken = @"";
//
////    {"jsonrpc":"2.0","method":"pic/login/get","params":{"pixel":"20x20","client_id":"1","from":"mcontact_www","device_id":"","version":"2.2"}"id":"1"}
//
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"2.0", @"jsonrpc",
//                         @"pic/login/get", @"method",
//                         [UIDeviceHardware uuid], @"id",
//                         [NSDictionary dictionaryWithObjectsAndKeys:
//                          deviceToken, @"aoi_token",  // 推送device token
//                          [UIDeviceHardware getDeviceUUID], @"device_id",  // ios取uuid
//                          [UIDeviceHardware getMacAddress], @"mac",
////                          KStatisticChannel, @"from",
//                          [UIDeviceHardware getDeviceUUID], @"imei",
//                          @"iPhone", @"brand",
//                          [[UIDevice currentDevice] model], @"model",
//                          KBundleVersion, @"version",
//                          [[UIDevice currentDevice] systemVersion], @"os_version",
//                          [ToolSet getDevicePixel], @"pixel",
//                          KClient_id, @"client_id",
//                          nil], @"params",
//                         nil];
//    return dic;
}


@end
