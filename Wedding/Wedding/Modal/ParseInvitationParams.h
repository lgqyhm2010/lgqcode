//
//  ParseInvitationParams.h
//  Wedding
//
//  Created by lgqyhm on 13-8-7.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseInvitationParams : NSObject

@property (nonatomic,strong) NSString *invitationID;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *weddingId;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *info;

- (id)initWithParseData:(NSDictionary *)data;

@end
