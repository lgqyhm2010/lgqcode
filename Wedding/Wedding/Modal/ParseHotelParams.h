//
//  ParseHotelParams.h
//  Wedding
//
//  Created by lgqyhm on 13-8-7.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseHotelParams : NSObject

@property (nonatomic,strong) NSString *hotelID;
@property (nonatomic,strong) NSString *pictureUrl;
@property (nonatomic,strong) NSString *hit;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *info;

- (id)initWithParseData:(NSDictionary *)data;

@end
