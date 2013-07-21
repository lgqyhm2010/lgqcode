//
//  UIHelpViewCell.h
//  CaiYun
//
//  Created by likid1412 on 31/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTableViewCollapseRowHeight 55

// tag
#define kIndicateTag    1000
#define kSubViewTag     1001

@interface UIHelpViewCell : UITableViewCell

@property (nonatomic, retain) UIView* subHelpView;


@end
