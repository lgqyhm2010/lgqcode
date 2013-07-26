//
//  HttpRequest.h
//  iContact
//
//  Created by kewenya on 12-4-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUInteger NSHttpError;
enum {
	NSHttpErrorDisconnect = 0,
	NSHttpErrorTimeout
};

@interface NSObject (HttpRequestDelegate)
- (void)httpRequestFail:(NSHttpError)httpError;
- (void)httpRequestFinish:(NSData *)receiveData;
- (void)httpRequestWithFlowCost:(int)bytes;
@end


@interface HttpRequest : NSMutableURLRequest {
	id delegate;
	
	NSURLConnection *conn;
    
    int receivedDataLength;
    NSMutableArray *receivedDataArray;
	
	//流量
	int flowCount;
	//重试次数
	int tryCount;
	int maxCount;
	
	BOOL isTryLast;
	BOOL isShowAlertView;
	NSString *alertViewStr;
	NSString *alertViewCancelStr;
	NSString *alertViewOtherStr;
	
	SEL cancellSelector;
	id cancellTarget;
    
    BOOL isCompressAndReceiveUncompressed;
}
@property (nonatomic,assign)id delegate;
@property (nonatomic,retain)NSString *alertViewStr;
@property (nonatomic,retain)NSString *alertViewCancelStr;
@property (nonatomic,retain)NSString *alertViewOtherStr;
- (void)start;

//设置重试最大次数
- (void)setTryMax:(int)count;

- (void)setTryAgainAlertView:(NSString*)str cancelButtonTitle:(NSString*)str1 otherButtonTitles:(NSString*)str2;

//流量计数
- (int) getflowCount;

- (void)cancellWithSelector:(SEL)selector target:(id)target;

- (void)cancel;

- (void)compressAndReceiveUncompressed;

@end
