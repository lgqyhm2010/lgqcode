//
//  ParseWishingParsms.h
//  Wedding
//
//  Created by lgqyhm on 13-7-27.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseWishingParsms : NSObject

@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *pictures;
@property (nonatomic,strong) NSString *simId;
@property (nonatomic,strong) NSString *messageType;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *pictureUrl;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *weddingId;
@property (nonatomic,strong) NSString *registTime;
@property (nonatomic,strong) NSString *lastLoginTime;

- (void)parseWishingData:(NSDictionary *)data;

@end
