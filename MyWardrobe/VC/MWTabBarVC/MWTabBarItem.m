//
// Created by Simon Mr on 2018/8/29.
// Copyright (c) 2018 光合. All rights reserved.
//


#import "MWTabBarItem.h"

#import "UIView+Yoga.h"
#import "MWTabBarButton.h"
#import "ReactiveCocoa.h"

@interface MWTabBarItem ()

@property (nonatomic, strong) MWTabBarButton *barButton;


@end

@implementation MWTabBarItem

- (instancetype)initWithNormalImage:(UIImage *)image
                      selectedImage:(UIImage *)selectedImage
                               type:(MWTabBarItemType)type {
    self = [super init];
    if (!self) {
        return nil;
    }

    _itemType = type;
    _backgroundView = [UIView new];
    [self createItemWithImage:image selectedImage:selectedImage];

    return self;
}

- (void)addTabbarItemTo:(UIView *)superView {
    if (!superView) {
        return;
    }

    [superView addSubview:self.backgroundView];
}

- (void)setNormalImage:(UIImage *)normalImage {
	[self.barButton setImage:normalImage forState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
	[self.barButton setImage:selectedImage forState:UIControlStateSelected];
}

#pragma mark - private method
- (void)createItemWithImage:(UIImage *)image
              selectedImage:(UIImage *)selectedImage {
    if (self.itemType == MWTabBarItemType_TopImageBottomTitle) {
        // 配置上图下文
        [self setTopImageBottomTitleTypeWithImage:image
                                    selectedImage:selectedImage];
    } else if (self.itemType == MWTabBarItemType_Image
        || self.itemType == MWTabBarItemType_Plus) {
        // 配置全图片类型
        [self setImageTypeWithImage:image
                      selectedImage:selectedImage];
    }
}

/**
 * 配置全图片类型button
 */
- (void)setImageTypeWithImage:(UIImage *)image
                selectedImage:(UIImage *)selectedImage {
    self.barButton = [MWTabBarButton buttonWithType:UIButtonTypeCustom];
    [self.barButton setImage:image forState:UIControlStateNormal];
    [self.barButton setImage:selectedImage forState:UIControlStateSelected];
    self.barButton.frame = (CGRect){CGPointZero, self.barButton.currentImage.size};
    self.barButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.barButton.adjustsImageWhenDisabled = NO;
    self.barButton.adjustsImageWhenHighlighted = NO;
    [self.backgroundView addSubview:self.barButton];
    [self.barButton configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.alignSelf = YGAlignCenter;
    }];

    @weakify(self);
    [[self.barButton
        rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            @strongify(self);
            if (self.clickAction) {
                self.clickAction();
            }
        }];

    self.itemSize = self.barButton.currentImage.size;
}

/**
 * 设置上图下文类型button
 */
- (void)setTopImageBottomTitleTypeWithImage:(UIImage *)image
                              selectedImage:(UIImage *)selectedImage {
    NSAssert(self.title.length > 0, @"上图下文模式需要设置item title");
    // TODO: 上文下图布局
}

#pragma mark - setter && getter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.barButton.selected = selected;
}

@end
