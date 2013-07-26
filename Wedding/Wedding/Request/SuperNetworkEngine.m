//
//  SuperNetworkEngine.m
//  iContact_Asyn_Test
//
//  Created by Hower on 11-4-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuperNetworkEngine.h"


@implementation SuperNetworkEngine
-(void)postData:(id)curDelegate
{
	if (curDelegate!=nil && [curDelegate isKindOfClass:[NSObject class]]) {
		[(UIViewController*)curDelegate retain];
	}
}
-(void)postFinished:(id)curDelegate
{
	if (curDelegate!=nil && [curDelegate isKindOfClass:[NSObject class]]) {//[curDelegate isKindOfClass:[NSObject class]]
		//NSLog(@"%@",[curDelegate class]);
		[(NSObject*)curDelegate release];
	}
}

@end
