//
//  UIColor+RandomColor.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
}

@end
