//
//  ParseWishingParsms.m
//  Wedding
//
//  Created by lgqyhm on 13-7-27.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseWishingParsms.h"

@implementation ParseWishingParsms

- (void)parseWishingData:(NSDictionary *)data
{
    if ([data jsonObjectForKey:@"id"]) {
        self.ID = [data jsonObjectForKey:@"id"];
    }
    if ([data jsonObjectForKey:@"createTime"]) {
        self.createTime = [data jsonObjectForKey:@"createTime"];
    }
    if ([data jsonObjectForKey:@"sex"]) {
        self.sex = [data jsonObjectForKey:@"sex"];
    }
    if ([data jsonObjectForKey:@"pictureUrl"]) {
        self.pictureUrl = [data jsonObjectForKey:@"pictureUrl"];
    }
    if ([data jsonObjectForKey:@"nickName"]) {
        self.nickName = [data jsonObjectForKey:@"nickName"];
    }
    if ([data jsonObjectForKey:@"name"]) {
        self.name =[data jsonObjectForKey:@"name"];
    }
    if ([data jsonObjectForKey:@"simId"]) {
        self.simId = [data jsonObjectForKey:@"simId"];
    }
    if ([data jsonObjectForKey:@"type"]) {
        self.type = [data jsonObjectForKey:@"type"];
    }
    if ([data jsonObjectForKey:@"lastLoginTime"]) {
        self.lastLoginTime = [data jsonObjectForKey:@"lastLoginTime"];
    }
    if ([data jsonObjectForKey:@"registTime"]) {
        self.registTime = [data jsonObjectForKey:@"registTime"];
    }
    if ([data jsonObjectForKey:@"messageType"]) {
        self.messageType = [data jsonObjectForKey:@"messageType"];
    }
    if ([data jsonObjectForKey:@"content"]) {
        self.content = [data jsonObjectForKey:@"content"];
    }
    

}

@end
