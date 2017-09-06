//
//  XPPPhotoBrowseController.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPPPhoto;

@interface XPPPhotoBrowseController : NSObject

- (void)previewPhotos:(NSArray<XPPPhoto *>*)photos fromView:(UIView *)view  fromFrame:(CGRect)frame currentPage:(NSInteger)page;

@end
