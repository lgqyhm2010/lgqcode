//
//  ParsePhotoParams.m
//  ImagePickerView
//
//  Created by lgqyhm on 13-7-24.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ParsePhotoParams.h"
#import "NSDictionary(Json).h"

@implementation ParsePhotoParams

- (void)parse:(NSDictionary *)data
{
    if ([data jsonObjectForKey:@"createTime"]) {
        self.creatTime = [data jsonObjectForKey:@"createTime"];
    }
    if ([data jsonObjectForKey:@"height"]) {
        self.height = [[data jsonObjectForKey:@"height"]intValue];
    }
    if ([data jsonObjectForKey:@"hit"]) {
        self.hit = [[data jsonObjectForKey:@"hit"]intValue];
    }
    if ([data jsonObjectForKey:@"id"]) {
        self.photoID = [data jsonObjectForKey:@"id"];
    }
    if ([data jsonObjectForKey:@"info"]) {
        self.info = [[data jsonObjectForKey:@"info"]intValue];
    }
    if ([data jsonObjectForKey:@"laud"]) {
        self.laud = [data jsonObjectForKey:@"laud"];
    }
    if ([data jsonObjectForKey:@"size"]) {
        self.size = [data jsonObjectForKey:@"size"];
    }
    if ([data jsonObjectForKey:@"thumbnailHeight"]) {
        self.thumbnailHeight = [[data jsonObjectForKey:@"thumbnailHeight"]intValue];
    }
    if ([data jsonObjectForKey:@"thumbnailUrl"]) {
        self.thumbnailurl = [data jsonObjectForKey:@"thumbnailUrl"];
    }
    if ([data jsonObjectForKey:@"thumbnailWidth"]) {
        self.thumbnailWidth = [[data jsonObjectForKey:@"thumbnailWidth"]intValue];
    }
    if ([data jsonObjectForKey:@"title"]) {
        self.title = [[data jsonObjectForKey:@"title"]intValue];
    }
    if ([data jsonObjectForKey:@"type"]) {
        self.type = [[data jsonObjectForKey:@"type"]intValue];
    }
    if ([data jsonObjectForKey:@"url"]) {
        self.url = [data jsonObjectForKey:@"url"];
    }
    if ([data jsonObjectForKey:@"weddingId"]) {
        self.weddingID = [data jsonObjectForKey:@"weddingId"];
    }
    if ([data jsonObjectForKey:@"width"]) {
        self.width = [[data jsonObjectForKey:@"width"]intValue];
    }
}

@end
