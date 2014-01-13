//
//  ParseWeddingParams.m
//  Wedding
//
//  Created by lgqyhm on 13-8-4.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseWeddingParams.h"

@implementation ParseWeddingParams

- (id)initWithParase:(NSDictionary *)data
{
    if (self = [super init]) {
        if ([data jsonObjectForKey:@"weddingDate"]) {
            self.weddingDate = [data jsonObjectForKey:@"weddingDate"];
        }
        if ([data jsonObjectForKey:@"createTime"]) {
            self.createTime = [data jsonObjectForKey:@"createTime"];
        }
        if ([data jsonObjectForKey:@"skinType"]) {
            self.skinType = [data jsonObjectForKey:@"skinType"];
        }
        if ([data jsonObjectForKey:@"state"]) {
            self.state = [data jsonObjectForKey:@"state"];
        }
        if ([data jsonObjectForKey:@"enterpriseId"]) {
            self.enterpriseId = [data jsonObjectForKey:@"enterpriseId"];
        }
        if ([data jsonObjectForKey:@"number"]) {
            self.number = [data jsonObjectForKey:@"number"];
        }
        if ([data jsonObjectForKey:@"hotelId"]) {
            self.hotelId = [data jsonObjectForKey:@"hotelId"];
        }
        if ([data jsonObjectForKey:@"info"]) {
            self.info = [data jsonObjectForKey:@"info"];
        }
        if ([data jsonObjectForKey:@"id"]) {
            self.weddingID = [data jsonObjectForKey:@"id"];
        }
        if ([data jsonObjectForKey:@"bridegroomInfo"]) {
            self.bridegroomInfo = [data jsonObjectForKey:@"bridegroomInfo"];
        }
        if ([data jsonObjectForKey:@"bridegroomUrl"]) {
            self.bridegroomUrl = [data jsonObjectForKey:@"bridegroomUrl"];
        }
        if ([data jsonObjectForKey:@"title"]) {
            self.title = [data jsonObjectForKey:@"title"];
        }
        if ([data jsonObjectForKey:@"brideInfo"]) {
            self.brideInfo = [data jsonObjectForKey:@"brideInfo"];
        }
        if ([data jsonObjectForKey:@"brideUrl"]) {
            self.brideUrl = [data jsonObjectForKey:@"brideUrl"];
        }
    }
    return self;
}

@end
