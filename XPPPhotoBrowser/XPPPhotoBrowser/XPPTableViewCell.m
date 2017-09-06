//
//  XPPTableViewCell.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/20.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPTableViewCell.h"
#import "XPPPhotoView.h"
#import <Masonry.h>

@interface XPPTableViewCell ()<XPPPhotoViewDelegate>

@property (nonatomic, strong) XPPPhotoView *pv;

@end

@implementation XPPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _pv = [[XPPPhotoView alloc] initWithFrame:CGRectZero];
        _pv.delegate = self;
        [self.contentView addSubview:_pv];
        [_pv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        _pv.maxPhotosForLine = 3;
        _pv.photoSize = CGSizeMake(60, 60);
        _pv.interSpacing = 10;
        _pv.lineSpacing = 10;
        
    }
    return self;
}

- (NSArray<XPPPhoto *> *)photosNeedShow {
    
    NSMutableArray *tempArr = @[].mutableCopy;
    for (NSString *ph in _photos) {
        XPPPhoto *photo = [XPPPhoto new];
        photo.thumb = ph;
        [tempArr addObject:photo];
    }
    return tempArr.copy;
}

- (void)setPhotos:(NSArray *)photots {
    _photos = photots;
    [_pv reloadPhotos];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
