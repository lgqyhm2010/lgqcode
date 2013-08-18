//
//  UIButton(Addition).h
//  CaiYun
//
//  Created by lusonglin on 13-2-18.
//
//

#import <UIKit/UIKit.h>

@interface UIButton(Addition)

+(UIButton *)newButton:(NSString*)text
                  rect:(CGRect)rect
                target:(id)target
                action:(SEL)action
                bgName:(NSString*)bgName
             bgSelName:(NSString*)bgNameSel;

+(UIButton *)customButtonWithTag:(NSInteger)aTag
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)aFrame
                           image:(UIImage *)image
                    imagePressed:(UIImage *)imagePressed;

+(UIButton *)customButtonWithTitle:(NSString *)aText
							   tag:(NSInteger)aTag
							target:(id)target
						  selector:(SEL)selector
							 frame:(CGRect)aFrame
							 image:(UIImage *)image
					  imagePressed:(UIImage *)imagePressed;

+(UIButton *)customButtonWithTitle:(NSString *)aText
							   tag:(NSInteger)aTag
							target:(id)target
						  selector:(SEL)selector
							 frame:(CGRect)aFrame
							 image:(UIImage *)image
					  imagePressed:(UIImage *)imagePressed
							  font:(UIFont *)aFont
                         fontColor:(UIColor *)fontColor;

+(UIButton *)linkButtonWithTitle:(NSString *)aText
                             tag:(NSInteger)aTag
                          target:(id)target
                        selector:(SEL)selector
                           frame:(CGRect)aFrame
                            font:(UIFont *)aFont
                       fontColor:(UIColor *)fontColor;

@end
