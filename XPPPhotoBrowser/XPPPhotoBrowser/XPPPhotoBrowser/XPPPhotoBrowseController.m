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


@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) XPPPhotoPreviewView *previewView;

@property (nonatomic, strong) UIImageView *snapshotView;

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) NSArray<XPPPhoto *> *photos;
@end

@implementation XPPPhotoBrowseController


- (instancetype)init {
    if (self = [super init]) {
        
        _previewView = [[XPPPhotoPreviewView alloc] initWithFrame:CGRectZero];
        _previewView.delegate = self;
    }
    return self;
}

- (void)previewPhotos:(NSArray<XPPPhoto *> *)photos fromFrame:(CGRect)frame currentPage:(NSInteger)page {
    self.photos = photos;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    frame = [self.delegate originalFrameAtIndexPath:indexPath];
    _originalFrame = frame;
    XPPPhoto *currentPhoto = photos[page];
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    _backgroundView.frame = keyWindow.bounds;
    [keyWindow addSubview:_backgroundView];
    
    _snapshotView = [[UIImageView alloc] initWithImage:currentPhoto.image];
    _snapshotView.contentMode = UIViewContentModeScaleAspectFill;
    _snapshotView.clipsToBounds = YES;
    _snapshotView.frame = frame;
    [keyWindow addSubview:_snapshotView];
    
    _previewView.photosArr = photos;
    _previewView.frame = keyWindow.bounds;
    _previewView.hidden = YES;
    [keyWindow addSubview:_previewView];
    [_previewView previewCurrentPageAtIndex:page];
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:1.0f options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionLayoutSubviews) animations:^{
        
        CGFloat imageWidth = keyWindow.bounds.size.width;
        CGFloat imageHeight = imageWidth * currentPhoto.imageRatio;
        CGFloat imageY = (keyWindow.bounds.size.height - imageHeight) * 0.5;
        _snapshotView.frame = CGRectMake(0, imageY, imageWidth, imageHeight);
        _backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _snapshotView.hidden = YES;
        _previewView.hidden = NO;
        [keyWindow bringSubviewToFront:_previewView];
    }];
}

- (void)clickPhotofromFrame:(CGRect)frame atIndexPath:(NSIndexPath *)indexPath {
    
    _snapshotView.image = self.photos[indexPath.item].image;
    CGRect toFrame = [self.delegate originalFrameAtIndexPath:indexPath];
    [self dismissPreviewViewFrame:frame toFrame:toFrame];
}

- (void)dismissPreviewViewFrame:(CGRect)frame toFrame:(CGRect)toFrame {
    _snapshotView.hidden = NO;
    _previewView.hidden = YES;
    [UIView animateWithDuration:0.35f
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:1.0f
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews)
                     animations:^{
                              _snapshotView.frame = toFrame;
                              _backgroundView.alpha = 0;
                          } completion:^(BOOL finished) {
                              _backgroundView.hidden = YES;
                              [_previewView removeFromSuperview];
                              [_snapshotView removeFromSuperview];
                          }];

}


@end
