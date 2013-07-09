//
//  UIColor+Additions.h
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)
+ (UIColor *)colorWithHexString:(NSString *)hexColor;
+ (UIColor*)colorRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha ;
@end
