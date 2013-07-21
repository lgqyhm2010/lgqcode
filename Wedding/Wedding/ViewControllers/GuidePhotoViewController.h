
//
//  GuidePhotoViewController.h
//  Wedding
//
//  Created by lgqyhm on 13-7-21.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "SuperViewController.h"

typedef NS_ENUM(NSInteger, EntryType)
{
    EntryGuideType,
    EntryIntroduceType
};

@interface GuidePhotoViewController : SuperViewController

- (id)initWithEntryType:(EntryType)type;

@end
