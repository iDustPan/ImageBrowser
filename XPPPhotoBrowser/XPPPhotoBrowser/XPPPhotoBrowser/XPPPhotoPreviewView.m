//
//  XPPPhotoPreviewView.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/19.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//

#import "XPPPhotoPreviewView.h"
#import "UIColor+RandomColor.h"
#import "XPPPhotoPreviewCell.h"
#import "XPPPhoto.h"


static CGFloat const kLineSpacing = 40;

@interface XPPPhotoPreviewView()< UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource, XPPPhotoPreviewCellDelegate>


@property (nonatomic, strong) UIPageControl *pageControll;

@end

@implementation XPPPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewCollView.frame = CGRectMake(-kLineSpacing * 0.5, 0, self.bounds.size.width + kLineSpacing, self.bounds.size.height);

    self.pageControll.frame = CGRectMake(0,
                                         self.bounds.size.height - 20,
                                         self.pageControll.bounds.size.width,
                                         20);
}

- (void)previewCurrentPageAtIndex:(NSInteger)page {
    [self layoutIfNeeded];
    self.pageControll.currentPage = page;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page
                                                     inSection:0];
    [self.previewCollView scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:NO];
    
}

- (void)setPhotosArr:(NSArray<XPPPhoto *> *)photosArr {
    _photosArr = photosArr;
    
    self.pageControll.numberOfPages = photosArr.count;
    
    [self.pageControll updateCurrentPageDisplay];
    
    [self layoutIfNeeded];
    [self.previewCollView reloadData];
    [self bringSubviewToFront:self.pageControll];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - kLineSpacing, collectionView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kLineSpacing * 0.5, 0, kLineSpacing * 0.5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XPPPhotoPreviewCell *previewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XPPPhotoPreviewCell class]) forIndexPath:indexPath];
    previewCell.backgroundColor = [UIColor randomColor];
    previewCell.delegate = self;
    if (indexPath.item < _photosArr.count) {
        previewCell.photo = _photosArr[indexPath.item];
    }
    return previewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageForDismiss)]) {
        [self.delegate clickImageForDismiss];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.previewCollView indexPathsForVisibleItems].firstObject;
    [self.pageControll setCurrentPage:indexPath.item];
}

- (void)previewCellDidEndPreview:(XPPPhotoPreviewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImageForDismiss)]) {
        [self.delegate clickImageForDismiss];
    }
}

- (UICollectionView *)previewCollView {
    if (!_previewCollView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _previewCollView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _previewCollView.translatesAutoresizingMaskIntoConstraints = NO;
        _previewCollView.pagingEnabled = YES;
        _previewCollView.delegate = self;
        _previewCollView.dataSource = self;
        [_previewCollView registerClass:[XPPPhotoPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([XPPPhotoPreviewCell class])];
        [self addSubview:_previewCollView];
    }
    return _previewCollView;
}

- (UIPageControl *)pageControll {
    if (!_pageControll) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControll.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:_pageControll];
    }
    return _pageControll;
}

@end
