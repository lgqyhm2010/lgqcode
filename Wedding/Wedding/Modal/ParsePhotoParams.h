//
//  ParsePhotoParams.h
//  ImagePickerView
//
//  Created by lgqyhm on 13-7-24.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsePhotoParams : NSObject

@property (nonatomic,retain) NSString *creatTime;
@property (nonatomic) int height;
@property (nonatomic) int hit;
@property (nonatomic,retain) NSString *photoID;
@property (nonatomic) int info;
@property (nonatomic,retain) NSString *laud;
@property (nonatomic,retain) NSString *size;
@property (nonatomic,retain) NSString *thumbnailurl;
@property (nonatomic) int thumbnailHeight;
@property (nonatomic) int thumbnailWidth;
@property (nonatomic) int title;
@property (nonatomic) int type;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *weddingID;
@property (nonatomic) int width;

- (void)parse:(NSDictionary *)data;

@end
