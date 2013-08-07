//
//  ParseEnterpriseParams.m
//  Wedding
//
//  Created by lgqyhm on 13-8-4.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseEnterpriseParams.h"

@implementation ParseEnterpriseParams

- (id)initWithParse:(NSDictionary *)data
{
    if (self = [super init]) {
        if ([data jsonObjectForKey:@"picture"]) {
            self.picture = [data jsonObjectForKey:@"picture"];
        }
        if ([data jsonObjectForKey:@"id"]) {
            self.enterpriseID = [data jsonObjectForKey:@"id"];
        }
        if ([data jsonObjectForKey:@"createTime"]) {
            self.createTime = [data jsonObjectForKey:@"createTime"];
        }
        if ([data jsonObjectForKey:@"webUrl"]) {
            self.webUrl = [data jsonObjectForKey:@"webUrl"];
        }
        if ([data jsonObjectForKey:@"phone"]) {
            self.phone = [data jsonObjectForKey:@"phone"];
        }
        if ([data jsonObjectForKey:@"email"]) {
            self.email = [data jsonObjectForKey:@"email"];
        }
        if ([data jsonObjectForKey:@"address"]) {
            self.address = [data jsonObjectForKey:@"address"];
        }
        if ([data jsonObjectForKey:@"name"]) {
            self.name = [data jsonObjectForKey:@"name"];
        }
        if ([data jsonObjectForKey:@"regist"]) {
            self.regist = [data jsonObjectForKey:@"regist"];
        }
        if ([data jsonObjectForKey:@"discount"]) {
            self.discount = [data jsonObjectForKey:@"discount"];
        }
        if ([data jsonObjectForKey:@"info"]) {
            self.info = [data jsonObjectForKey:@"info"];
        }
    }
    return self;
}

@end
