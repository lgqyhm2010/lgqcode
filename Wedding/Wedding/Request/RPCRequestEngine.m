//
//  RPCRequestEngine.m
//  CaiYun
//
//  Created by lusonglin on 13-6-21.
//
//  RPC请求通用类

#import "RPCRequestEngine.h"
#import "NSDictionary(Json).h"
#import "JSONRPCClient.h"
#import "UIDeviceHardware.h"

@interface RPCRequestEngine ()

@property (nonatomic,retain) NSString *serviceURL;

@end


@implementation RPCRequestEngine


- (id) initWithServiceURL:(NSString*) URL {
    if (self = [super init]) {
        self.serviceURL = URL;
    }
    return self;
}

- (id) init {
    if (self = [super init]) {
        self.serviceURL = KRomanticURL;
    }
    return self;
}


//固定的基本参数
//- (NSDictionary *)baseParams{
//    
////       NSDictionary *baseParams = @{
////        @"client_id": @"1",
////        @"session":[[Owner share] session],
////        @"from": KStatisticChannel,
////        @"version": KBundleVersion,
////        @"device_id": [UIDeviceHardware getDeviceUUID]
////        };
////    return baseParams;
//}

//  @fn 单个请求
//  @param method  接口方法名
//  @param otherParams  除固定的基本参数（client_id、from、version、device_id）外的其他参数
//  @param successBlock(id resultObject)  调用成功才存在
//  @param errorBlock(int errorCode, NSString *errorMessage)  失败回调
- (void)singleCallWithMethod:(NSString* )method
                 OtherParams:(NSDictionary* )params
                onCompletion:(RPCSingleCallSuccessBlock)successBlock
                     onError:(RPCSingleCallErrorBlock)errorBlock
{
    NSAssert(method, @"not nil");
    
//    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[self baseParams] ];
//    if (otherParams) {
//        [allParams addEntriesFromDictionary:otherParams];
//    }
    
    RPCRequest *request = [RPCRequest requestWithMethod:method
                                                 params:params
                                               callback:^(RPCResponse *response,NSDictionary *responseJson)
                           {
                               DLog(@"response \n%@",responseJson);
                               if (response.error)
                               {
                                   DLog(@"%@", response);
//                                   if (ERROR_CODE_NET_ERROR(response.error.code))
//                                       errorBlock(NSNetCodeNetError, KNetErrorDefault);
//                                   else
                                       errorBlock(response.error.code, response.error.message);
                               }
                               else
                               {
                                   id resultObject = [responseJson jsonObjectForKey:@"result"];
                                   if (resultObject)
                                   {
                                       // 成功
                                       successBlock(resultObject);
                                   }
                               }
                           }];
    

    JSONRPCClient *rpc = [[JSONRPCClient alloc] initWithServiceEndpoint: self.serviceURL];
    [rpc postRequest:request async:YES];
    [rpc release];
    
    DLog(@"\n\ninterface:%@\n\n", self.serviceURL);
}


//  @fn 批量请求
//  @param allParams  包含每次请求参数的数组
//  @param successBlock 查询成功的回调
//  @param errorBlock   失败回调
//  @param finishedBlock  所有请求结束的回调
- (void)batchCallWithParams:(NSArray* )allParams
               OnCompletion:(RPCBatchCallSuccessBlock)successBlock
                    onError:(RPCBatchCallErrorBlock)errorBlock
                 onFinished:(RPCBatchCallFinishedBlock)finishedBlock
{
    NSAssert(allParams, @"not nil");
    
    NSMutableArray *allRequests = [[NSMutableArray alloc] init];
    

    __block int index = 0;
    for (NSDictionary *paramDic in allParams)
    {
        NSString* method = paramDic[@"method"];
        NSDictionary* params = paramDic[@"params"];
        RPCRequest *request = [RPCRequest requestWithMethod:method params:params callback:^(RPCResponse *response,NSDictionary *responseJson) {
            DLog(@"Multicall %d, [%@] Response is: %@", index, response.id, response);

            if (response.error)
            {
//                if (ERROR_CODE_NET_ERROR(response.error.code))
//                    errorBlock(index,NSNetCodeNetError, KNetErrorDefault);
//                else
                    errorBlock(index,response.error.code, response.error.message);
            }
            else
            {
                id resultObject = [responseJson jsonObjectForKey:@"result"];
                if (resultObject)
                {
                    // 成功
                    successBlock(index,resultObject);
                }
            }

            index++;
            
            if (index == [allParams count]) {
                finishedBlock();
            }
        }];
        
        [allRequests addObject:request];
    }
    
    if(allRequests.count > 0 )
    {
        JSONRPCClient *rpc = [[JSONRPCClient alloc] initWithServiceEndpoint:self.serviceURL];
        [rpc postRequests:allRequests];
        [rpc release];
    }
    
    [allRequests release];
}

- (void)dealloc {
    
    self.serviceURL = nil;
    [super dealloc];
}


@end