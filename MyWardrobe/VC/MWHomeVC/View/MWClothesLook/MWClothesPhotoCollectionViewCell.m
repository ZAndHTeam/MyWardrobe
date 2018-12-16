//
//  MWClothesPhotoCollectionViewCell.m
//  MyWardrobe
//
//  Created by zt on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWClothesPhotoCollectionViewCell.h"
#import "MWSignalClothesModel.h"
@interface MWClothesPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *bigScrollV;
@property (nonatomic, strong) UICollectionView *tagCollectionV;
@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation MWClothesPhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.bigScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, self.frame.size.height)];
    [self.contentView addSubview:self.bigScrollV];
    self.bigScrollV.bounces = NO;
    self.bigScrollV.showsVerticalScrollIndicator = NO;
    //照片
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(15, 0, SCREEN_SIZE_WIDTH - 30, (SCREEN_SIZE_WIDTH - 30)/345.0 * 460.0);
    [self.bigScrollV addSubview:self.imageView];
    //标签
    UICollectionViewLayout *flowLayou = [[UICollectionViewLayout alloc]init];
    self.tagCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageView.frame) + 20, SCREEN_SIZE_WIDTH - 30, 250) collectionViewLayout:flowLayou];
    [self.bigScrollV addSubview:self.tagCollectionV];
    //注意事项
    self.msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tagCollectionV.frame) + 11, SCREEN_SIZE_WIDTH - 30, 20)];
    [self.bigScrollV addSubview:self.msgLabel];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.msgLabel.font = [UIFont systemFontOfSize:17];
}

- (void)configWithModel:(MWSignalClothesModel *)model {
    self.imageView.image = [UIImage imageWithData:model.imageDataArr[0]];
//    self.msgLabel.text = model.mark;
    self.msgLabel.text = @"切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记";
    [self.msgLabel sizeToFit];
    self.bigScrollV.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, CGRectGetMaxY(self.msgLabel.frame));

}

@end
