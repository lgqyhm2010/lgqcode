//
//  ParseEnterpriseParams.h
//  Wedding
//
//  Created by lgqyhm on 13-8-4.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseEnterpriseParams : NSObject

@property (nonatomic,strong) NSString *picture;             //图片
@property (nonatomic,strong) NSString *enterpriseID;        //ID
@property (nonatomic,strong) NSString *createTime;          //创建时间
@property (nonatomic,strong) NSString *webUrl;              //web主页url
@property (nonatomic,strong) NSString *phone;               
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *regist;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *info;

@end
