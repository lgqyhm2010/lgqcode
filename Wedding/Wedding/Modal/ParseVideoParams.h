//
//  ParseVideoParams.h
//  Wedding
//
//  Created by lgqyhm on 13-7-27.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseVideoParams : NSObject

@property (nonatomic,strong) NSString *videoID;
@property (nonatomic,strong) NSString *creatTime;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *thumbnailUrl;
@property (nonatomic,strong) NSString *weddingID;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *info;
@property (nonatomic) int size;

- (void)parseVideoParmas:(NSDictionary *)data;

@end
