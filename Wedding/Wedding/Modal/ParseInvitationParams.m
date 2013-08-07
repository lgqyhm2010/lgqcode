//
//  ParseInvitationParams.m
//  Wedding
//
//  Created by lgqyhm on 13-8-7.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseInvitationParams.h"

@implementation ParseInvitationParams

- (id)initWithParseData:(NSDictionary *)data
{
    if (self = [super init]) {
        if ([data jsonObjectForKey:@"id"]) {
            self.invitationID = [data jsonObjectForKey:@"id"];
        }
        if ([data jsonObjectForKey:@"url"]) {
            self.url = [data jsonObjectForKey:@"url"];
        }
        if ([data jsonObjectForKey:@"info"]) {
            self.info = [data jsonObjectForKey:@"info"];
        }
        if ([data jsonObjectForKey:@"createTime"]) {
            self.createTime = [data jsonObjectForKey:@"createTime"];
        }
        if ([data jsonObjectForKey:@"weddingId"]) {
            self.weddingId = [data jsonObjectForKey:@"weddingId"];
        }
    }
    return self;
}

@end
