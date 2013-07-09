//
//  JSONRPCClient.m
//  CaiYun
//
//  Created by penghanbin on 13-4-1.
//
//

#import "JSONRPCClient.h"
#import "JSONKit.h"

@implementation JSONRPCClient


 NSString* clearScheme(NSString *url) {
     NSString *tmp = url;
     NSRange range = [tmp rangeOfString:@"http://"];
     tmp = [tmp substringFromIndex:NSMaxRange(range)];
     return tmp;
}

- (id) initWithServiceEndpoint:(NSString*) endpoint {
    if (self = [super init]) {
        self.serviceEndpoint = endpoint;
    }
    return self;
}

- (void) postRequest:(RPCRequest*)request async:(BOOL)async
{
	[self postRequests:[NSArray arrayWithObject:request] async:async];
}

- (void) postRequests:(NSArray*)requests
{
	[self postRequests:requests async:YES];
}

- (void) postRequests:(NSArray *)requests async:(BOOL)async
{    
    NSMutableArray *serializedRequests = [[NSMutableArray alloc] initWithCapacity:requests.count];
    NSString *payload = @"";
    NSError *jsonError;
    
    if (requests.count == 1) {
        RPCRequest *request = [requests lastObject];
        payload = [[request serialize] JSONStringWithOptions:JKSerializeOptionNone error:&jsonError];
    } else {
        for(RPCRequest *request in requests)
            [serializedRequests addObject:[request serialize]];
        payload = [serializedRequests JSONStringWithOptions:JKSerializeOptionNone error:&jsonError];
        [serializedRequests release];
    }
    
    if(jsonError != nil)
		[self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCParseError]];
    else
    {
        
        NSMutableDictionary *header = [NSMutableDictionary dictionary];
        [header setObject:@"application/json" forKey:@"Content-Type"];
        [header setObject:@"objc-JSONRpc/1.0" forKey:@"User-Agent"];
        
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] init];
        
        MKNetworkOperation *operation = [engine operationWithURLString:self.serviceEndpoint params:nil httpMethod:@"POST"];
        
        DLog(@"\n\npost:\n%@\n\n" ,payload);
        
        [operation setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
            return payload;
        } forType:@"application/x-www-form-urlencoded"];
        
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [self handleData:[completedOperation responseData] withRequests:requests];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCNetworkError]];
        }];
        [engine enqueueOperation:operation forceReload:YES];
        [engine release];

    }
    //原生代码
    if (0) {
        NSMutableArray *serializedRequests = [[NSMutableArray alloc] initWithCapacity:requests.count];
        
        for(RPCRequest *request in requests)
            [serializedRequests addObject:[request serialize]];
        
        NSError *jsonError;
        NSData *payload = [serializedRequests JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
        [serializedRequests release];
        
        if(jsonError != nil)
            [self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCParseError]];
        else
        {
            NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serviceEndpoint]];
            [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [serviceRequest setValue:@"objc-JSONRpc/1.0" forHTTPHeaderField:@"User-Agent"];
            
            [serviceRequest setValue:[NSString stringWithFormat:@"%i", payload.length] forHTTPHeaderField:@"Content-Length"];
            [serviceRequest setHTTPMethod:@"POST"];
            [serviceRequest setHTTPBody:payload];
            
            if(async)
            {
#ifndef __clang_analyzer__
                NSURLConnection *serviceEndpointConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
#endif
                
                NSMutableData *rData = [[NSMutableData alloc] init];
                [self.requestData setObject:rData forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
                [self.requests setObject:requests forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
                [rData release];
                [serviceRequest release];
            }
            else
            {
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&response error:&error];
                
                if(data != nil)
                    [self handleData:data withRequests:requests];
                else
                    [self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCNetworkError]];
            }
        }
    }
    

}

- (void) sendSynchronousRequest:(RPCRequest*)request completion:(HandleRPCResponse)handleRPCResponse
{
	RPCResponse *response = [[RPCResponse alloc] init];
    
    __block NSError *jsonError = nil;
    NSLog(@"serialize:%@" ,[request serialize]);
    NSString *payload = [[request serialize] JSONStringWithOptions:JKSerializeOptionNone error:&jsonError];
	if(jsonError == nil)
	{
        
        NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
        [header setObject:@"application/json" forKey:@"Content-Type"];
        [header setObject:@"objc-JSONRpc/1.0" forKey:@"User-Agent"];
        
        NSLog(@"\n\n%@\n\n" ,payload);
        
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:clearScheme(self.serviceEndpoint) customHeaderFields:header];
        MKNetworkOperation *operation = [engine operationWithPath:nil params:nil httpMethod:@"POST"];
        [operation setPostDataEncoding:MKNKPostDataEncodingTypeCustom];
        [operation setCustomPostDataEncodingHandler:^NSString *(NSDictionary *postDataDict) {
            return payload;
        } forType:@"application/x-www-form-urlencoded"];
        
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSData *data = [completedOperation responseData];
            id result = nil;
            if(data != nil)
            {
                jsonError = nil;
                result = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];
                
                if(data.length == 0)
                    response.error = [RPCError errorWithCode:RPCServerError];
                else if(jsonError)
                    response.error = [RPCError errorWithCode:RPCParseError];
                else if([result isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *error = [result objectForKey:@"error"];
                    response.id = [result objectForKey:@"id"];
                    response.version = [result objectForKey:@"jsonrpc"];
                    
                    if(error && [error isKindOfClass:[NSDictionary class]])
                        response.error = [RPCError errorWithDictionary:error];
                    else
                        response.result = [result objectForKey:@"result"];
                }
                else
                    response.error = [RPCError errorWithCode:RPCParseError];
            }
            else {
                response.error = [RPCError errorWithCode:RPCParseError];
            }
            handleRPCResponse(response ,result);

        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {

        }];
        [engine enqueueOperation:operation];
        
	} else {
        response.error = [RPCError errorWithCode:RPCParseError];
        handleRPCResponse(response ,nil);
    }
    

}

#pragma mark - Handling of data

- (void) handleData:(NSData*)data withRequests:(NSArray*)requests
{
	NSError *jsonError = nil;
    id results = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];
    
    for(RPCRequest *request in requests)
    {
        if(request.callback == nil)
            continue;
        
        if(data.length == 0)
            request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCServerError]] ,results);
        else if(jsonError)
            request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCParseError]] ,results);
        else if([results isKindOfClass:[NSDictionary class]])
            [self handleResult:results forRequest:request];
        else if([results isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *result in results)
            {
                NSString *requestId = [result objectForKey:@"id"];
                
                if( [requestId isKindOfClass:[NSString class]] && [requestId isEqualToString:request.id])
                {
                    [self handleResult:result forRequest:request];
                    break;
                }
            }
        }
    }
    
}

- (void) handleFailedRequests:(NSArray*)requests withRPCError:(RPCError*)error
{
    for(RPCRequest *request in requests)
    {
        if(request.callback == nil)
            continue;
        
        request.callback([RPCResponse responseWithError:error] ,nil);
    }
    
}

- (void) handleResult:(NSDictionary*) result forRequest:(RPCRequest*)request
{
    if(!request.callback)
        return;
    
    NSString *requestId = [result objectForKey:@"id"];
    
    NSDictionary *error = [result objectForKey:@"error"];
    NSString *version = [result objectForKey:@"version"];
    
    RPCResponse *response = [[RPCResponse alloc] init];
    response.id = requestId;
    response.version = version;
    
    if(error && [error isKindOfClass:[NSDictionary class]])
        response.error = [RPCError errorWithDictionary:error];
    else
        response.result = [result objectForKey:@"result"];
    
    request.callback(response ,result);
    
    [response release];
}



@end
