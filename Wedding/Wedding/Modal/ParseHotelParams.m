//
//  ParseHotelParams.m
//  Wedding
//
//  Created by lgqyhm on 13-8-7.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParseHotelParams.h"

@implementation ParseHotelParams

- (id)initWithParseData:(NSDictionary *)data
{
    if (self = [super init]) {
        if ([data jsonObjectForKey:@"id"]) {
            self.hotelID = [data jsonObjectForKey:@"id"];
        }
        if ([data jsonObjectForKey:@"pictureUrl"]) {
            self.pictureUrl = [data jsonObjectForKey:@"pictureUrl"];
        }
        if ([data jsonObjectForKey:@"hit"]) {
            self.hit = [data jsonObjectForKey:@"hit"];
        }
        if ([data jsonObjectForKey:@"email"]) {
            self.email = [data jsonObjectForKey:@"email"];
        }
        if ([data jsonObjectForKey:@"address"]) {
            self.address = [data jsonObjectForKey:@"address"];
        }
        if ([data jsonObjectForKey:@"tel"]) {
            self.tel = [data jsonObjectForKey:@"tel"];
        }
        if ([data jsonObjectForKey:@"name"]) {
            self.name = [data jsonObjectForKey:@"name"];
        }
        if ([data jsonObjectForKey:@"discount"]) {
            self.discount = [data jsonObjectForKey:@"discount"];
        }
        if ([data jsonObjectForKey:@"info"]) {
            self.info = [data jsonObjectForKey:@"info"];
        }
        if ([data jsonObjectForKey:@"webUrl"]) {
            self.webUrl = [data jsonObjectForKey:@"webUrl"];
        }
    }
    return self;
}

@end
