//
//  MWDragTagCell.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWDragTagCell.h"

@interface MWDragTagCell ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat labelWidth;

@end

@implementation MWDragTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}


- (void)configUI {
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.mw_width, self.mw_height)];
    [self.contentView addSubview:self.bgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, self.mw_width - 25.f, 24.f)];
    self.titleLabel.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
    [self.bgView addSubview:self.titleLabel];
}

- (UIImage *)generateImageWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(2,
                                              30,
                                              2,
                                              2);
    image = [image resizableImageWithCapInsets:edgeInset];
    
    return image;
}

- (void)setImageName:(NSString *)imageName cellWidth:(CGFloat)width {
    self.bgView.image = [self generateImageWithName:imageName];
    self.bgView.mw_width = width;
}

- (void)setTagName:(NSString *)tagName cellWidth:(CGFloat)width {
    self.titleLabel.text = tagName;
    self.titleLabel.mw_width = width;
}

- (void)setTagTextColor:(UIColor *)tagTextColor {
    self.titleLabel.textColor = tagTextColor;
}

@end
