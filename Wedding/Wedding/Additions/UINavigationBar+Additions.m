//
//  UINavigationBar+Additions.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "UINavigationBar+Additions.h"

#define KNavBarRemoveTag 10000000

@implementation UINavigationBar (Additions)

-(void)setBackgroundImage:(UIImage*)image
{
    [self setNeedsDisplay];
    
    self.backgroundColor=[UIColor clearColor];
	UIImageView *tView=(UIImageView*)[self viewWithTag:KNavBarRemoveTag];
	if(tView!=nil)
	{
		[self sendSubviewToBack:tView];
        [tView setImage:image];
		//[tView removeFromSuperview];
	}else {
		if(image == nil)
		{
			[tView removeFromSuperview];
		}
		else
		{
			UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
			backgroundView.tag=KNavBarRemoveTag;
			backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
			backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self addSubview:backgroundView];
			[self sendSubviewToBack:backgroundView];
			[backgroundView release];
		}
	}
}

//for other views
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
	UIView *tView=[self viewWithTag:KNavBarRemoveTag];
    [self sendSubviewToBack:tView];
}


@end
