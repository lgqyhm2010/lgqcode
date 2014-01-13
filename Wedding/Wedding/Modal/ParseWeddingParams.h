//
//  ParseWeddingParams.h
//  Wedding
//
//  Created by lgqyhm on 13-8-4.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseWeddingParams : NSObject

@property (nonatomic,strong) NSString *weddingDate;     //婚礼时间
@property (nonatomic,strong) NSString *createTime;      //婚礼创建时间
@property (nonatomic,strong) NSString *skinType;        //默认皮肤
@property (nonatomic,strong) NSString *state;           //状态
@property (nonatomic,strong) NSString *enterpriseId;    //婚庆企业ID
@property (nonatomic,strong) NSString *number;          //婚礼编号
@property (nonatomic,strong) NSString *hotelId;         //婚礼现场ID
@property (nonatomic,strong) NSString *info;            //信息说明
@property (nonatomic,strong) NSString *weddingID;       //婚礼ID
@property (nonatomic,strong) NSString *bridegroomInfo;  //新郎信息
@property (nonatomic,strong) NSString *bridegroomUrl;   //新郎照片
@property (nonatomic,strong) NSString *title;           //主题
@property (nonatomic,strong) NSString *brideInfo;       //新娘信息
@property (nonatomic,strong) NSString *brideUrl;        //新娘照片

@property (nonatomic,strong) NSString *address;

- (id)initWithParase:(NSDictionary *)data;

@end
