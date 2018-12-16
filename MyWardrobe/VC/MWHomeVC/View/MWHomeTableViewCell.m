//
//  MWHomeTableViewCell.m
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWHomeTableViewCell.h"

#pragma mark - views
#import "MWHomeCollectionViewCell.h"

#pragma mark - models
#import "MWSignalClothesModel.h"

#pragma mark - utils
#import "UIImage+ScaleSize.h"

@interface MWHomeTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <MWSignalClothesModel *>*clothesArr;

@end

@implementation MWHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    //添加collectionView
    [self.contentView addSubview:self.collectionView];
}

- (void)setIsZero:(BOOL)isZero {
    _isZero = isZero;
    [self.collectionView reloadData];
}

- (void)configData:(NSArray *)clothesArr {
    _clothesArr = clothesArr.copy;
    [self.collectionView reloadData];
}

#pragma mark -- collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_isZero) {
        self.collectionView.hidden = YES;
        return 0;
    }
    self.collectionView.hidden = NO;
    return self.clothesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MWHomeCollectionViewCell *cell = (MWHomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                                           forIndexPath:indexPath];
    
    cell.clothesImage = [[UIImage imageWithData:self.clothesArr[indexPath.row].imageDataArr.firstObject] imageByScalingAndCroppingForSize:CGSizeMake(90, 120)];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lookBlock) {
        self.lookBlock(self.clothesArr, indexPath.row);
    }
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(90, 120);
        flow.minimumLineSpacing = 5;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 120) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MWHomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}


@end
