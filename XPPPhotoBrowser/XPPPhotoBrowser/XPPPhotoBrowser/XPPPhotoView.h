//
//  XPPPhotoView.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPPPhoto.h"

@protocol XPPPhotoViewDelegate;

@interface XPPPhotoView : UIView

@property (nonatomic, assign) CGSize photoSize;

@property (nonatomic, assign) CGFloat lineSpacing;

@property (nonatomic, assign) CGFloat interSpacing;

@property (nonatomic, assign) NSInteger maxPhotosForLine;

@property (nonatomic, strong) NSArray<XPPPhoto *> *photos;

@property (nonatomic, weak) id<XPPPhotoViewDelegate> delegate;

- (void)reloadPhotos;


@end

@protocol XPPPhotoViewDelegate <NSObject>

@required
- (NSArray<XPPPhoto *> *)photosNeedShow;

@optional
- (void)photoView:(XPPPhotoView *)photoView didClickPhoto:(XPPPhoto *)photo;

@end
