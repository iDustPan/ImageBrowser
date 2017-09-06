//
//  XPPPhoto.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XPPPhoto : NSObject

@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *full;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign, readonly) CGSize imgSize;

/** Height / width */
@property (nonatomic, assign) CGFloat imageRatio;

@end
