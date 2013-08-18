//
//  UIButton(Addition).m
//  CaiYun
//
//  Created by lusonglin on 13-2-18.
//
//

#import "UIButton(Addition).h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation UIButton(Addition)



+(UIButton *)newButton:(NSString*)text
                  rect:(CGRect)rect
                target:(id)target
                action:(SEL)action
                bgName:(NSString*)bgName
             bgSelName:(NSString*)bgNameSel
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
	[button setTitle:text forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:bgNameSel] forState:UIControlStateHighlighted];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return button;
}

+(UIButton *)customButtonWithTag:(NSInteger)aTag
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)aFrame
                           image:(UIImage *)image
                    imagePressed:(UIImage *)imagePressed
{
    return [UIButton customButtonWithTitle:nil
                                       tag:aTag
                                    target:target
                                  selector:selector
                                     frame:aFrame
                                     image:image
                              imagePressed:imagePressed
                                      font:nil
                                 fontColor:nil];
}

+(UIButton *)customButtonWithTitle:(NSString *)aText
							   tag:(NSInteger)aTag
							target:(id)target
						  selector:(SEL)selector
							 frame:(CGRect)aFrame
							 image:(UIImage *)image
					  imagePressed:(UIImage *)imagePressed
{
    return [UIButton customButtonWithTitle:aText
                                       tag:aTag
                                    target:target
                                  selector:selector
                                     frame:aFrame
                                     image:image
                              imagePressed:imagePressed
                                      font:nil
                                 fontColor:nil];
}

+(UIButton *)customButtonWithTitle:(NSString *)aText
							   tag:(NSInteger)aTag
							target:(id)target
						  selector:(SEL)selector
							 frame:(CGRect)aFrame
							 image:(UIImage *)image
					  imagePressed:(UIImage *)imagePressed
							  font:(UIFont *)aFont
                         fontColor:(UIColor *)fontColor
{
	UIButton *button = [[UIButton alloc] initWithFrame:aFrame];
	button.tag = aTag;
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	if (image != nil) {
		[button setBackgroundImage:image forState:UIControlStateNormal];
	}
	
	if (imagePressed != nil) {
		[button setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
	}
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	
    if (!aFont) {
        aFont = [UIFont systemFontOfSize:14.0f];
    }
    
    if (!fontColor) {
        fontColor = [UIColor whiteColor];
    }
    
    if (aText) {
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aFrame.size.width, aFrame.size.height)];
        btnLabel.text = aText;
        btnLabel.font = aFont;
        btnLabel.textColor = fontColor;
        btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.textAlignment = UITextAlignmentCenter;
        [button addSubview:btnLabel];
    }
	return button;
}

+(UIButton *)linkButtonWithTitle:(NSString *)aText
                             tag:(NSInteger)aTag
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)aFrame
                            font:(UIFont *)aFont
                       fontColor:(UIColor *)fontColor
{
	UIButton *button = [[UIButton alloc] initWithFrame:aFrame];
	button.tag = aTag;
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	
	UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, aFrame.size.width, aFrame.size.height)];
	btnLabel.text = aText;
	btnLabel.font = aFont;
	btnLabel.textColor = fontColor;
	btnLabel.backgroundColor = [UIColor clearColor];
	btnLabel.textAlignment = UITextAlignmentRight;
	[button addSubview:btnLabel];
    
//    UIImageView *imav = [[UIImageView alloc]initWithFrame:CGRectMake(10,aFrame.size.height-1,aFrame.size.width-20,1)];
//    imav.backgroundColor = UIColorFromRGB(0x499FE4);//
//    [button addSubview:imav];
	return button;
}


@end
