//
//  MWColorPickerView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWColorPickerView.h"

#pragma mark - utils
#import "UIView+Yoga.h"

static NSInteger const kColorViewTagBeginNumner = 1000;

@interface MWColorPickerView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, copy) NSArray *colorArr;
@property (nonatomic, assign) NSInteger frontClickIdx;
@property (nonatomic, assign) CGFloat viewWidth;

@end

@implementation MWColorPickerView

- (instancetype)initWithWidth:(CGFloat)viewWidth {
    self = [super init];
    if (self) {
        self.frontClickIdx = -1;
        self.viewWidth = viewWidth;
        [self configTagUI];
    }
    return self;
}

- (void)configTagUI {
    [self configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.justifyContent = YGJustifyCenter;
    }];
    
    [self addSubview:({
        self.scrollView = [UIScrollView new];
        [self.scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.flexDirection = YGFlexDirectionRow;
        }];
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView;
    })];
    
    [self.scrollView addSubview:({
        self.scrollContentView = [UIView new];
        [self.scrollContentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.flexDirection = YGFlexDirectionRow;
        }];
        self.scrollContentView;
    })];
    
    // 初始化标签
    @weakify(self);
    self.colorArr = @[@"#000000", @"#FFFFFF", @"#CDCDCD", @"#FFCC00", @"#FFA000",
                      @"#FF4141", @"#57D96C", @"#3091F2", @"#7A45E6"];
    [self.colorArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.scrollContentView addSubview:[self createColorImage:obj idx:idx]];
    }];
    
    CGSize size = self.scrollContentView.yoga.intrinsicSize;
    if (size.width > self.viewWidth) {
        size = CGSizeMake(self.viewWidth, size.height);
    }
    
    [self.scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.width = YGPointValue(size.width);
    }];
    
    self.scrollView.contentSize = self.scrollContentView.yoga.intrinsicSize;
    
    [self addSubview:({
        UIView *div = [UIView new];
        [div configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(10.f);
        }];
        div;
    })];
    
    [self.yoga applyLayoutPreservingOrigin:YES];
}

- (UIView *)createColorImage:(NSString *)colorName idx:(NSInteger)idx {
    UIView *colorView = [UIView new];
    colorView.layer.borderWidth = 0.5;
    colorView.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.2].CGColor;
    colorView.backgroundColor = [UIColor colorWithHexString:colorName];
    colorView.tag = kColorViewTagBeginNumner + idx;
    [colorView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(32.f);
        layout.justifyContent = YGJustifyCenter;
        layout.alignItems = YGAlignCenter;
        layout.marginRight = YGPointValue(10.f);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOneColor:)];
    [tap setNumberOfTapsRequired:1];
    [colorView addGestureRecognizer:tap];
    
    return colorView;
}

- (void)clickOneColor:(UITapGestureRecognizer *)tap {
    UIView *targetView = tap.view;
    NSString *colorName = self.colorArr[targetView.tag - kColorViewTagBeginNumner];
    
    UIView *frontView = (UIView *)[self viewWithTag:self.frontClickIdx];
    
    [frontView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (self.frontClickIdx == targetView.tag) {
        self.frontClickIdx = -1;
        colorName = nil;
    } else {
        [targetView addSubview:({
            UIImageView *imageView = [UIImageView new];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"check"];
            [imageView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
                layout.isEnabled = YES;
                layout.width = layout.height = YGPointValue(24.f);
            }];
            imageView;
        })];
        self.frontClickIdx = targetView.tag;
    }
    
    if (self.colorAction) {
        self.colorAction(colorName);
    }
}

@end
