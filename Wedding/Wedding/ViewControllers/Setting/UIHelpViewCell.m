//
//  UIHelpViewCell.m
//  CaiYun
//
//  Created by likid1412 on 31/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIHelpViewCell.h"
//#import <QuartzCore/QuartzCore.h>

@implementation UIHelpViewCell

@synthesize subHelpView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{	
    [super setSelected:selected animated:animated];
    
    UIImageView *indicate = (UIImageView *)[self.contentView viewWithTag:kIndicateTag];	
    
    // 选中时，修改标示图标为opened，并展开帮助内容；否则修改标示图标为closed，并折叠帮助内容。
	if (selected) 
    {
        self.subHelpView.tag = kSubViewTag;
//        [self.contentView addSubview:self.subHelpView];
        [self.contentView performSelector:@selector(addSubview:) withObject:self.subHelpView afterDelay:0.15];
        
        indicate.image = [UIImage imageNamed:@"opened"];
	}
    else 
    {
        [[self.contentView viewWithTag:kSubViewTag] performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.15];
        indicate.image = [UIImage imageNamed:@"closed"];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    NSLog(@"point: %f, %f", point.x, point.y);
    
    // 如果触碰到title，则折叠cell；否则如果触碰到subHelpView的范围，则不折叠
    if (point.y <= kTableViewCollapseRowHeight)
    {
//        NSLog(@"title touch");
        [super touchesBegan:touches withEvent:event];
    }
//    else
//    {
//        NSLog(@"subHelpView touch");
//    }
    
}

@end
