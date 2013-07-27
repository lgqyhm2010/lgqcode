//
//  ParseLoginParams.h
//  Wedding
//
//  Created by lgqyhm on 13-7-27.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseLoginParams : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *pictureUrl;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *simId;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *lastLoginTime;
@property (nonatomic,strong) NSString *registTime;

- (void)parseLogin:(NSDictionary *)data;

@end
