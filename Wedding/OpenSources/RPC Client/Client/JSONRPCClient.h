//
//  JSONRPCClient.h
//  CaiYun
//
//  Created by penghanbin on 13-4-1.
//
//

#import <Foundation/Foundation.h>
#import "RPCRequest.h"
#import "RPCError.h"
#import "RPCResponse.h"
#import "MKNetworkKit.h"


typedef void(^HandleRPCResponse)(RPCResponse *response ,NSDictionary *json);

@interface JSONRPCClient : NSObject

#pragma mark - Properties -

/**
 * What service endpoint we talk to. Just a simple string containing an URL.
 * It will later be converted to an NSURL Object, so anything that NSURL Supports
 * is valid-
 */
@property (nonatomic, retain) NSString *serviceEndpoint;

/**
 * All the reqeusts that is being executed is added to this statck
 */
@property (nonatomic, retain) NSMutableDictionary *requests;

/**
 * All returned data from the server is saved into this dictionary for later processing
 */
@property (nonatomic, retain) NSMutableDictionary *requestData;


#pragma mark - Methods

/**
 * Inits RPC Client with a specific end point.
 *
 * @param NSString endpoint Should be some kind of standard URL
 * @return RPCClient
 */
- (id) initWithServiceEndpoint:(NSString*) endpoint;

/**
 * Post requests syncronous
 *
 * Posts requests to the server via HTTP post. Always uses multicall to simplify handling
 * of responses.
 *
 * If the server your talking with do not understand multicall then you have a problem.
 */
- (void) postRequests:(NSArray*)requests;

/**
 * Post Requests Async
 *
 * Posts requests to the server via HTTP post. Always uses multicall to simplify handling
 * of responses.
 *
 * If the server your talking with do not understand multicall then you have a problem.
 *
 */
- (void) postRequests:(NSArray *)requests async:(BOOL)async;

/**
 * Posts a single single request
 *
 */
- (void) postRequest:(RPCRequest*)request async:(BOOL)async;

/**
 * Sends a synchronous request that returns the response object
 * instead of using callbacks
 */
- (void) sendSynchronousRequest:(RPCRequest*)request completion:(HandleRPCResponse)handleRPCResponse;


@end
