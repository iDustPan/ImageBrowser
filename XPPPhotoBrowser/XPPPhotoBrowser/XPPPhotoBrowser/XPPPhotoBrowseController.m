//
//  XPPPhotoBrowseController.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPPhotoBrowseController.h"
#import "XPPPhotoPreviewView.h"
#import <SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import "XPPPhoto.h"

@interface XPPPhotoBrowseController ()<XPPPhotoPreviewViewDelegate>

@property (nonatomic, strong) XPPPhotoPreviewView *previewView;

@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation XPPPhotoBrowseController


- (instancetype)init {
    if (self = [super init]) {
        
        _previewView = [[XPPPhotoPreviewView alloc] initWithFrame:CGRectZero];
        _previewView.delegate = self;
    }
    return self;
}

- (void)previewPhotos:(NSArray<XPPPhoto *> *)photos fromView:(UIView *)view fromFrame:(CGRect)frame currentPage:(NSInteger)page {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    _originalFrame = frame;
    view.frame = frame;
    _previewView.frame = frame;
    _previewView.photosArr = photos;
    [keyWindow addSubview:_previewView];
    
    [keyWindow addSubview:view];
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionLayoutSubviews) animations:^{
        
        XPPPhoto *currentPhoto = photos[page];
        
        CGFloat imageWidth = keyWindow.bounds.size.width;
        CGFloat imageHeight = imageWidth * currentPhoto.imageRatio;
        CGFloat imageY = (keyWindow.bounds.size.height - imageHeight) * 0.5;
        view.frame = CGRectMake(0, imageY, imageWidth, imageHeight);
        _previewView.frame = keyWindow.bounds;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        
        [_previewView previewCurrentPageAtIndex:page];
    }];
}

- (void)clickImageForDismiss {
    [self dismissPreviewView];
}

- (void)dismissPreviewView {
    if (_previewView && _previewView.window) {
        [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews) animations:^{
            _previewView.frame = _originalFrame;
        } completion:^(BOOL finished) {
            [_previewView removeFromSuperview];
        }];
    }
}


@end
