//
//  XPPPhotoView.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPPhotoView.h"
#import "UIColor+RandomColor.h"
#import "XPPDefaultPhotoCell.h"
#import "XPPPhoto.h"
#import "XPPPhotoBrowseController.h"

#define kDefaultPhotoSize CGSizeMake(96, 96);

static CGFloat const kDefaultPhotoLineSpacing = 6;
static CGFloat const kDefaultInteriSpacing = 6;

@interface XPPPhotoView ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *photosView;
@property (nonatomic, strong) XPPPhotoBrowseController *browseControlelr;

@end

@implementation XPPPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maxPhotosForLine = 3;
        _interSpacing = 5;
        _lineSpacing = 5;
        _photoSize = CGSizeMake(96, 96);
        [self registerCell];
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos {
    _photos = photos;
    [self.photosView reloadData];
}


- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self.photosView reloadData];
}

- (void)setInterSpacing:(CGFloat)interSpacing {
    _interSpacing = interSpacing;
    [self.photosView reloadData];
}

- (void)setPhotoSize:(CGSize)photoSize {
    _photoSize = photoSize;
    [self.photosView reloadData];
}

- (void)setMaxPhotosForLine:(NSInteger)maxPhotosForLine {
    _maxPhotosForLine = maxPhotosForLine;
    [self.photosView reloadData];
}

- (void)reloadPhotos {
    _photos = [self.delegate photosNeedShow];
    if (_photos.count) {
        [self.photosView reloadData];
    }
}

- (CGSize)caculatePhotosViewSize {
    CGFloat width = _maxPhotosForLine * _photoSize.width + (_maxPhotosForLine - 1) * _interSpacing;
    CGFloat rows = (_photos.count / _maxPhotosForLine) + 1;
    CGFloat Height = rows * _photoSize.height + (rows - 1) * _lineSpacing;
    return CGSizeMake(width, Height);
}

- (void)registerCell {
    [self.photosView registerNib:[UINib nibWithNibName:NSStringFromClass([XPPDefaultPhotoCell class]) bundle:nil]
      forCellWithReuseIdentifier:NSStringFromClass([XPPDefaultPhotoCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XPPDefaultPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XPPDefaultPhotoCell class]) forIndexPath:indexPath];

    if (indexPath.item < _photos.count) {
        [photoCell setPhoto:_photos[indexPath.item]];
    }
    return photoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XPPDefaultPhotoCell *cell = (XPPDefaultPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView *snapView  = [cell snapshotViewAfterScreenUpdates:YES];
    CGRect cellFrame = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath].frame;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGRect cellABSFrame = [window convertRect:cellFrame fromView:self];
    _browseControlelr = [[XPPPhotoBrowseController alloc] init];
    
    [_browseControlelr previewPhotos:_photos fromView:snapView fromFrame:cellABSFrame currentPage:indexPath.item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!CGSizeEqualToSize(_photoSize, CGSizeZero)) {
        return _photoSize;
    }
    return kDefaultPhotoSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (_lineSpacing) {
        return _lineSpacing;
    }
    return kDefaultPhotoLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (_interSpacing) {
        return _interSpacing;
    }
    return kDefaultInteriSpacing;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize photosViewSize = [self caculatePhotosViewSize];
    self.photosView.frame = CGRectMake(0, 0, photosViewSize.width, photosViewSize.height);
    
    CGRect newFrame = self.frame;
    newFrame.size = photosViewSize;
    self.frame = newFrame;
    
}

- (UICollectionView *)photosView {
    if (!_photosView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _photosView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _photosView.showsVerticalScrollIndicator = NO;
        _photosView.showsHorizontalScrollIndicator = NO;
        _photosView.backgroundColor = [UIColor randomColor];
        _photosView.dataSource = self;
        _photosView.delegate = self;
        [self addSubview:_photosView];
    }
    return _photosView;
}

@end
