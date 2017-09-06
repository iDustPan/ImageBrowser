//
//  XPPDefaultPhotoCell.h
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPPPhoto;

@interface XPPDefaultPhotoCell : UICollectionViewCell

- (void)setPhoto:(XPPPhoto *)photo;
- (void)updateContentMode:(UIViewContentMode)mode;

@end
