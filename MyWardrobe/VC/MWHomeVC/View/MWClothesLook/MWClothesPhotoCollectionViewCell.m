//
//  MWClothesPhotoCollectionViewCell.m
//  MyWardrobe
//
//  Created by zt on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWClothesPhotoCollectionViewCell.h"
#import "MWSignalClothesModel.h"
#import "MWDragTagView.h"
@interface MWClothesPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *bigScrollV;
@property (nonatomic, strong) MWDragTagView *tagView;
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
    self.tagView = [[MWDragTagView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageView.frame) + 20, SCREEN_SIZE_WIDTH - 30, 42)
                                                        imageName:@"tag_normal"
                                                             edit:NO
                                                       tagNameArr:@[@"未分类", @"四季", @"没有牌子", @"橙色"]];
    @weakify(self);
    [self.tagView.reloadSubject
     subscribeNext:^(NSNumber *height) {
         @strongify(self);
         self.tagView.mw_height = [height integerValue];
         self.msgLabel.frame = CGRectMake(15, self.tagView.mw_bottom + 11, SCREEN_SIZE_WIDTH - 30, 20);
         self.bigScrollV.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, self.msgLabel.mw_bottom + 20.f);
     }];
    
    self.tagView.backgroundColor = [UIColor whiteColor];
    
    [self.bigScrollV addSubview:self.tagView];
    
    [self.tagView configUI];
    
    //注意事项
    self.msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tagView.frame) + 11, SCREEN_SIZE_WIDTH - 30, 20)];
    [self.bigScrollV addSubview:self.msgLabel];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.msgLabel.font = [UIFont systemFontOfSize:17];
}

- (void)configWithModel:(MWSignalClothesModel *)model {
    self.imageView.image = [UIImage imageWithData:model.imageDataArr[0]];
    self.msgLabel.text = model.mark;
//    self.msgLabel.text = @"切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记切记不可水洗！！！切记不可水洗！！！切记";
    [self.msgLabel sizeToFit];
    self.bigScrollV.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, CGRectGetMaxY(self.msgLabel.frame));

}

@end
