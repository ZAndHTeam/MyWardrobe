//
//  MWHomeCollectionViewCell.m
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWHomeCollectionViewCell.h"

@interface MWHomeCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MWHomeCollectionViewCell

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
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(0, 0, 90, 120.f);
    [self addSubview:self.imageView];
}

- (void)setClothesImage:(UIImage *)clothesImage {
    self.imageView.image = clothesImage;
}

@end
