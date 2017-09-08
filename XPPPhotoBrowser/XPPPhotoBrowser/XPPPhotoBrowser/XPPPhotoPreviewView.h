//
//  XPPPhotoPreviewView.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPPPhoto;

@protocol XPPPhotoPreviewViewDelegate;
@interface XPPPhotoPreviewView : UIView

@property (nonatomic, strong) UICollectionView *previewCollView;
@property (nonatomic, strong) NSArray<XPPPhoto *> *photosArr;

@property (nonatomic, weak) id<XPPPhotoPreviewViewDelegate> delegate;

- (void)previewCurrentPageAtIndex:(NSInteger)page;

@end

@protocol XPPPhotoPreviewViewDelegate <NSObject>

- (void)clickPhotofromFrame:(CGRect)frame atIndexPath:(NSIndexPath *)indexPath;

@end
