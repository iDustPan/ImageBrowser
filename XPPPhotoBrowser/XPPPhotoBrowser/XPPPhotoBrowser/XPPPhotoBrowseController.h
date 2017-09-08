//
//  XPPPhotoBrowseController.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPPPhoto;

@protocol XPPPhotoBrowseControllerDelegate <NSObject>

@required;
- (CGRect)originalFrameAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface XPPPhotoBrowseController : NSObject

@property (nonatomic, weak) id<XPPPhotoBrowseControllerDelegate> delegate;

- (void)previewPhotos:(NSArray<XPPPhoto *>*)photos fromFrame:(CGRect)frame currentPage:(NSInteger)page;

@end
