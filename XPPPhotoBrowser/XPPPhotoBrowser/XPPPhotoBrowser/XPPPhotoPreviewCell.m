//
//  XPPPhotoPreviewCell.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/20.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPPhotoPreviewCell.h"
#import "XPPPhoto.h"
#import <UIImageView+WebCache.h>

@interface XPPPhotoPreviewCell ()<UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, assign) CGPoint tapPoint;

@end

@implementation XPPPhotoPreviewCell


- (void)setPhoto:(XPPPhoto *)photo {
    _photo = photo;

    
    self.imageView.image = photo.image;
//    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:photo.thumb]];
//    UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:cacheKey];
//    
//    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:_photo.thumb] placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    }];
//    
    [self layoutIfNeeded];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > 1) {
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5, scrollView.contentSize.height * 0.5);
    }else{
        self.imageView.center = scrollView.center;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView.zoomScale > 1) {
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5, scrollView.contentSize.height * 0.5);
    }else{
        self.imageView.center = scrollView.center;
    }
}

- (void)clickForDismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewCellDidEndPreview:)]) {
        [self.delegate previewCellDidEndPreview:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.contentView.bounds;
    self.imageView.frame = self.scrollView.bounds;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    [self centerImageViewToScrollView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.frame = self.bounds;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self centerImageViewToScrollView];
    return [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
}

- (void)centerImageViewToScrollView {
    CGFloat imageH = ceilf(_photo.imageRatio * self.imageView.bounds.size.width);
    if (imageH > self.scrollView.bounds.size.height) {
        CGRect newFrame = self.imageView.frame;
        newFrame.size.height = imageH;
        self.imageView.frame = newFrame;
        
        self.scrollView.contentSize = self.imageView.bounds.size;
        self.imageView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.contentSize.height * 0.5);
        [self.scrollView setContentOffset:CGPointMake(0, (newFrame.size.height - self.scrollView.bounds.size.height) * 0.5) animated:NO];
    }
}

- (void)doubleClickForZooming:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0f animated:YES];
    }else{
        [self.scrollView setZoomScale:2.0f animated:YES];
    }
}

- (void)longPressForSavingPhoto {
    if (!_sheet) {
        _sheet = [[UIActionSheet alloc] initWithTitle:@"是否要保存到相册？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [_sheet showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self saveToPhotosAlbum];
        [actionSheet dismissWithClickedButtonIndex:actionSheet.firstOtherButtonIndex animated:YES];
    }
}

- (void)saveToPhotosAlbum {
    UIGraphicsBeginImageContext(self.imageView.bounds.size);
    
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(temp, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存成功");
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0f;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForDismiss)];
        singleTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        _imageView.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForDismiss)];
        singleTap.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickForZooming:)];
        doubleTap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self.scrollView addSubview:_imageView];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForSavingPhoto)];
        [_imageView addGestureRecognizer:longTap];
    }
    return _imageView;
}


@end
