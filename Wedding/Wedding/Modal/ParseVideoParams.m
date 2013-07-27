//
//  ParseVideoParams.m
//  Wedding
//
//  Created by lgqyhm on 13-7-27.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseVideoParams.h"

@implementation ParseVideoParams

- (void)parseVideoParmas:(NSDictionary *)data
{
    if ([data jsonObjectForKey:@"id"]) {
        self.videoID = [data jsonObjectForKey:@"id"];
    }
    if ([data jsonObjectForKey:@"createTime"]) {
        self.creatTime = [data jsonObjectForKey:@"createTime"];
    }
    if ([data jsonObjectForKey:@"title"]) {
        self.title = [data jsonObjectForKey:@"title"];
    }
    if ([data jsonObjectForKey:@"thumbnailUrl"]) {
        self.thumbnailUrl = [data jsonObjectForKey:@"thumbnailUrl"];
    }
    if ([data jsonObjectForKey:@"weddingId"]) {
        self.weddingID = [data jsonObjectForKey:@"weddingId"];
    }
    if ([data jsonObjectForKey:@"url"]) {
        self.url = [data jsonObjectForKey:@"url"];
    }
    if ([data jsonObjectForKey:@"size"]) {
        self.size = [[data jsonObjectForKey:@"size"]intValue];
    }
    if ([data jsonObjectForKey:@"info"]) {
        self.info = [data jsonObjectForKey:@"info"];
    }
}

@end
