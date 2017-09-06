//
//  XPPPhoto.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPPhoto.h"

@implementation XPPPhoto

- (CGSize)imgSize {
    return self.image.size;
}

- (CGFloat)imageRatio {
    if (CGSizeEqualToSize(self.imgSize, CGSizeZero)) {
        return 1;
    }
    return self.imgSize.height / self.imgSize.width;
}

@end
