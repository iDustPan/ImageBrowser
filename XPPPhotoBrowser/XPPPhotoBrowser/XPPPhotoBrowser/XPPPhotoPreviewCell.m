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
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, assign) CGPoint tapPoint;

@end

@implementation XPPPhotoPreviewCell


- (void)setPhoto:(XPPPhoto *)photo {
    _photo = photo;
    
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:photo.thumb]];
    UIImage *img = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:cacheKey];
    
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:_photo.full] placeholderImage:img options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > 1) {
        CGRect frame = self.imageView.frame;
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width / 4, scrollView.contentSize.height / 4)];
        
        
    }else{
        
        
        
    }
}

- (void)clickForDismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewCellDidEndPreview:)]) {
        [self.delegate previewCellDidEndPreview:self];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGRect frame = view.frame;
    NSLog(@"%@", NSStringFromCGRect(frame));
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += frame.origin.y * 2;
    
    self.scrollView.contentSize = contentSize;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    CGSize imgSize = self.imageView.image.size;
    if (CGSizeEqualToSize(imgSize, CGSizeZero)) {
        NSLog(@"图片尺寸为0");
        return;
    }
    CGFloat imgW = self.scrollView.bounds.size.width;
    CGFloat imgH = imgSize.height * imgW / imgSize.width;
    self.scrollView.frame = self.bounds;
    
    CGRect newFrame = self.imageView.frame;
    //    if (imgSize.width >= imgSize.height) {
    newFrame.size.width = imgW;
    newFrame.size.height = imgH;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.scrollView.center.y - imgH * 0.5;
    //    }else{
    //        newFrame.origin = CGPointMake(0, 0);
    //        newFrame.size.width = imgW;
    //        newFrame.size.height = imgSize.height * imgW / imgSize.width;
    //    }
    self.imageView.frame = newFrame;
    self.scrollView.contentSize = newFrame.size;
}

- (void)doubleClickForZooming:(UITapGestureRecognizer *)tap {
    if (self.scrollView.zoomScale > 1.0f) {
        
        
        [self.scrollView setZoomScale:1.0f animated:YES];
    }else{
        [self.scrollView setZoomScale:2.0f animated:YES];
        
        _tapPoint = [tap locationInView:self.imageView];
        
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
        [self addSubview:_scrollView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForDismiss)];
        singleTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
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
