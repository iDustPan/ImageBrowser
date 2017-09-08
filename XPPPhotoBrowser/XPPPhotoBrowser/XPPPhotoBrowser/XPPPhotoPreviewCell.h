//
//  XPPPhotoPreviewCell.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/20.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPPPhoto;

@protocol XPPPhotoPreviewCellDelegate;

@interface XPPPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) XPPPhoto *photo;

@property (nonatomic, weak) id<XPPPhotoPreviewCellDelegate> delegate;

@end

@protocol XPPPhotoPreviewCellDelegate <NSObject>

- (void)previewCellWillEndPreview:(XPPPhotoPreviewCell *)cell;
- (void)previewCellDidEndPreview:(XPPPhotoPreviewCell *)cell;

@end

