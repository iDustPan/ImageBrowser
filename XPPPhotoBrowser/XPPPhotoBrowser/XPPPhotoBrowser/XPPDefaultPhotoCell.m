//
//  XPPDefaultPhotoCell.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPDefaultPhotoCell.h"
#import "XPPPhoto.h"
#import <UIImageView+WebCache.h>

@interface XPPDefaultPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;


@end

@implementation XPPDefaultPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateContentMode:(UIViewContentMode)mode {
    self.defaultImageView.contentMode = mode;
}

- (void)setPhoto:(XPPPhoto *)photo {
    NSURL *url;
    if (photo.thumb) {
        url = [NSURL URLWithString:photo.thumb];
    }else if(photo.full){
        url = [NSURL URLWithString:photo.full];
    }
    UIImage *phImage = [UIImage imageNamed:@""];
    [_defaultImageView sd_setImageWithURL:url
                         placeholderImage:phImage
                                completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    photo.image = image;
    }];
}

@end
