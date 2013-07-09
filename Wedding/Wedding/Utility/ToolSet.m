//
//  ToolSet.m
//  Wedding
//
//  Created by lgqyhm on 13-7-9.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//

#import "ToolSet.h"

@implementation ToolSet

+(UIFont *)customBoldFontWithSize:(CGFloat) fontsize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize];
    //return [UIFont fontWithName:@"MarkerFelt-Wide" size:fontsize];
}

+(UIFont *)customNormalFontWithSize:(CGFloat) fontsize
{
    return [UIFont fontWithName:KFontDefault size:fontsize];
    //return [UIFont fontWithName:@"MarkerFelt-Thin" size:fontsize];
}

@end
