//
//  HttpRequest.m
//  iContact
//
//  Created by kewenya on 12-4-17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpRequest.h"
#import "Reachability.h"
#import "GzipUtility.h"

#define HTTPHeadSize 1024 //头部（发送＋接收）
#define HTTPTryMaxNum 1

@implementation HttpRequest
@synthesize delegate;
@synthesize alertViewStr,alertViewCancelStr,alertViewOtherStr;

#pragma mark

- (void)setTryMax:(int)count {
	maxCount = count;
}

- (BOOL)isEnableConnection{
	NSLog(@"isEnableConnection 0 ");
	if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable) ||
		([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable)) {
		return YES;
	}
	NSLog(@"isEnableConnection 1 ");
	return NO;
}

- (void)cancel {
    if (conn) {
        [conn cancel];
        [conn release] ,conn = nil;
    }
}

- (void)startConnection{
	
	//	if (![self isEnableConnection]) {
	//		//设备无连接
	//		[self performSelector:@selector(httpDisconnect) withObject:nil afterDelay:0.2];
	//		return;
	//	}
	//NSLog(@"startConnection");
	if (conn){
		[conn cancel];
		[conn release];
	}
	conn = [[NSURLConnection alloc] initWithRequest:self delegate:self];
	[conn start];
	
	
    if (!receivedDataArray) {
        receivedDataArray = [[NSMutableArray alloc] init];
    }
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)httpDisconnect {
	if (delegate && [delegate respondsToSelector:@selector(httpRequestFail:)]) {
		[delegate httpRequestFail:NSHttpErrorDisconnect];
	}
}

- (void)start {
	NSTimeInterval interval = [self timeoutInterval];
	if (interval > 60)
		[self setTimeoutInterval:60];
	
	[self performSelectorOnMainThread:@selector(startConnection) withObject:nil waitUntilDone:YES];
	
	tryCount = 1;
	flowCount = 0;
	
	if (maxCount == 0)
		maxCount = HTTPTryMaxNum;
}

- (void)reStart {
	[self performSelectorOnMainThread:@selector(startConnection) withObject:nil waitUntilDone:YES];
	
	tryCount ++;
}

//流量计数
- (int) getflowCount{
	return flowCount;
}

- (void)setTryAgainAlertView:(NSString*)str cancelButtonTitle:(NSString*)str1 otherButtonTitles:(NSString*)str2 {
	self.alertViewStr = str; 
	self.alertViewCancelStr = str1;
	self.alertViewOtherStr = str2;
	
	isShowAlertView = YES;
}

- (void)cancellWithSelector:(SEL)selector target:(id)target {
	cancellSelector = selector;
	cancellTarget = target;
}

- (void)compressAndReceiveUncompressed {
    NSData *data = [self HTTPBody];
    NSData *gzipData = [GzipUtility gzipData:data];
    [self setHTTPBody:gzipData];
    [self addValue:@"GZIP" forHTTPHeaderField:@"COMPRESS"];
    
    isCompressAndReceiveUncompressed = YES;
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response{
    [receivedDataArray removeAllObjects];
    receivedDataLength = 0;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
	DLog(@"error %d: %@",[error code],[error localizedDescription]);
	
	int errorCode = [error code];
	NSHttpError httpError;
	if (errorCode == -1004) {
		httpError = NSHttpErrorDisconnect;
	} else {
		httpError = NSHttpErrorTimeout;
	}
	
	if (isTryLast) {
		//重试结束
		isTryLast = NO;
		
		if (delegate && [delegate respondsToSelector:@selector(httpRequestFail:)]) {
			[delegate httpRequestFail:httpError];
		}
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	else if (tryCount >= maxCount) {
		//自动重试结束 判断是否需要手动重连
		if (isShowAlertView) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络异常" message:alertViewStr delegate:self cancelButtonTitle:alertViewCancelStr otherButtonTitles:alertViewOtherStr,nil];
			alertView.tag = 0;
			[alertView show];
			[alertView release];
		} else {
			if (delegate && [delegate respondsToSelector:@selector(httpRequestFail:)]) {
				[delegate httpRequestFail:httpError];
			}
		}
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
	} else {
		[self performSelector:@selector(reStart) withObject:nil afterDelay:15];
	}
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
	//流量计数
    if ([receivedDataArray count] == 0) {
        flowCount = HTTPHeadSize + [[self HTTPBody] length];
    }
    flowCount += [data length];
    
    receivedDataLength += [data length];
    [receivedDataArray addObject:data];
}

- (NSData*) allReceiveData {
    int count = receivedDataArray?[receivedDataArray count]:0;
    char *buffer =  (char*)malloc(receivedDataLength+64);
    char *ptr = buffer;
    for (int i = 0; i < count; i ++) {
        NSData *data = (NSData*)[receivedDataArray objectAtIndex:i];
        int len = data.length;
        memcpy(ptr, data.bytes, len);
        ptr += len;
    }
    NSData *desData = [NSData dataWithBytes:buffer length:receivedDataLength];
    free(buffer);
    return desData;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSData *receivedData = [self allReceiveData];
    [receivedDataArray removeAllObjects];
    
    if (isCompressAndReceiveUncompressed) {
        receivedData = [GzipUtility ungzipData:receivedData];
    }
    
	if (delegate) {
		if ([delegate respondsToSelector:@selector(httpRequestFinish:)]) {
			[delegate httpRequestFinish:receivedData];
		}
		
		if ([delegate respondsToSelector:@selector(httpRequestWithFlowCost:)]) {
			[delegate httpRequestWithFlowCost:flowCount];
			
		}
	}
	[conn cancel];
    [pool release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if(cancellTarget && cancellSelector && [cancellTarget respondsToSelector:cancellSelector])
        {
			[cancellTarget performSelector:cancellSelector];
        }
	} else if (buttonIndex == 1) {
		isTryLast = YES;
		[self reStart];
	}
}

#pragma mark dealloc
- (void)dealloc {
	
	if (receivedDataArray)
		[receivedDataArray release];
	
	if (conn){
		[conn cancel];
		[conn release];
	}
	
	if (alertViewStr) {
		[alertViewStr release];
	}
	if (alertViewCancelStr) {
		[alertViewCancelStr release];
	}
	if (alertViewOtherStr) {
		[alertViewOtherStr release];
	}
	
	[super dealloc];
}

@end
