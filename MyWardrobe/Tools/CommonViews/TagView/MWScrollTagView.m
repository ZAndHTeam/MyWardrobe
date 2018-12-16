//
//  MWScrollTagView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/14.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWScrollTagView.h"

#pragma mark - utils
#import "UIView+Yoga.h"
#import "MWAlertView.h"

static NSInteger const kScrollTagViewBeginNumner = 100;

@interface MWScrollTagView ()

@property (nonatomic, strong) NSMutableArray <NSString *>*tagArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, assign) CGFloat leftMaxWidth;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, assign) NSInteger recordScrollTagViewNumber;
@property (nonatomic, assign) NSInteger frontClickIdx;

@end

@implementation MWScrollTagView

- (instancetype)initWithTagArr:(NSArray<NSString *> *)tagArr maxLeftWidth:(CGFloat)leftMaxWidth withSelectStr:(NSString *)selectStr {
    self = [super init];
    if (self) {
        self.tagArr = [NSMutableArray arrayWithArray:tagArr];
        self.leftMaxWidth = leftMaxWidth;
        self.frontClickIdx = -1;
        self.selectStr = [selectStr copy];
        self.recordScrollTagViewNumber = kScrollTagViewBeginNumner;
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
    if (self.tagArr.count > 0) {
        [self.tagArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if ([obj isEqualToString:self.selectStr]) {
                self.frontClickIdx = idx;
            }
            [self.scrollContentView addSubview:[self createLabelWithText:obj]];
        }];
        
        CGSize leftSize = self.scrollContentView.yoga.intrinsicSize;
        if (leftSize.width > self.leftMaxWidth) {
            leftSize = CGSizeMake(self.leftMaxWidth, leftSize.height);
        }
        
        [self.scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.width = YGPointValue(leftSize.width);
        }];
        
        self.scrollView.contentSize = self.scrollContentView.yoga.intrinsicSize;
    }
    
    [self addSubview:({
        UIView *div = [UIView new];
        [div configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(10.f);
        }];
        div;
    })];
    
    [self addSubview:({
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.layer.borderWidth = 0.5;
        self.addButton.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.2].CGColor;
        [self.addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [self.addButton configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(40.f);
            layout.height = YGPointValue(24.f);
        }];
        
        [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             [[[MWAlertView alloc] initWithTitle:self.alertTitle
                                       inputText:@""
                                   confirmString:self.alertConfirmString
                                    cancelString:self.alertCancelString
                                     confirBlock:^(NSString *inputString) {
                                         @strongify(self);
                                         if (inputString.length > 0) {
                                             [self addNewTagWithText:inputString];
                                         }
                                     } cancelBlock:^{}] showAlert];
         }];
        self.addButton;
    })];
}

// 添加新标签
- (void)addNewTagWithText:(NSString *)text {
    UIView *label = [self createLabelWithText:text];
    [self.scrollContentView addSubview:label];
    
    CGSize leftSize = self.scrollContentView.yoga.intrinsicSize;
    if (leftSize.width > self.leftMaxWidth) {
        leftSize = CGSizeMake(self.leftMaxWidth, leftSize.height);
    }
    
    [self.scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.width = YGPointValue(leftSize.width);
    }];
    
    self.scrollView.contentSize = self.scrollContentView.yoga.intrinsicSize;
    
    [self.tagArr addObject:text];
    
    if (self.addNewLabelBlock) {
        self.addNewLabelBlock(text);
    }
    
    if (self.sizeChangeBlock) {
        self.sizeChangeBlock();
    }
}

- (UIView *)createLabelWithText:(NSString *)text {
    UIImageView *labelBg = ({
        UIImageView *imageView = [UIImageView new];
        imageView.tag = self.recordScrollTagViewNumber ++;
        imageView.userInteractionEnabled = YES;
        if ([self.selectStr isEqualToString:text]) {
            imageView.image = [self generateImageWithName:@"tag_highlighted"];
        } else {
            imageView.image = [self generateImageWithName:@"tag_normal"];
        }
        [imageView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.flexDirection = YGFlexDirectionRow;
            layout.marginRight = YGPointValue(10.f);
        }];
        imageView;
    });
    
    [labelBg addSubview:({
        UIView *div = [UIView new];
        [div configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(15.f);
        }];
        div;
    })];
    
    UILabel *label = [UILabel new];
    label.userInteractionEnabled = YES;
    label.text = text;
    if ([self.selectStr isEqualToString:text]) {
        label.textColor = [UIColor whiteColor];
    }
    label.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
    [label configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
    }];
    [labelBg addSubview:label];
    
    [labelBg addSubview:({
        UIView *div = [UIView new];
        [div configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(10.f);
        }];
        div;
    })];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOneTag:)];
    [tap setNumberOfTapsRequired:1];
    [labelBg addGestureRecognizer:tap];
    
    return labelBg;
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

#pragma mark - public method
- (void)scrollToBottom {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.mw_width, 0)
                             animated:YES];
}

- (void)setHaveAddButton:(BOOL)haveAddButton {
    if (!haveAddButton) {
        [self.addButton configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.display = YGDisplayNone;
        }];
        
        [self.yoga applyLayoutPreservingOrigin:NO];
    }
}

- (void)clickOneTag:(UITapGestureRecognizer *)tap {
    UIImageView *targetView = (UIImageView *)tap.view;
    NSString *catogaryName = self.tagArr[targetView.tag - kScrollTagViewBeginNumner];
    
    UIImageView *frontView = (UIImageView *)[self viewWithTag:self.frontClickIdx];
    frontView.image = [self generateImageWithName:@"tag_normal"];
    [frontView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)obj;
            label.textColor = [UIColor blackColor];
        }
    }];
    
    if (self.frontClickIdx == targetView.tag) {
        self.frontClickIdx = -1;
        catogaryName = nil;
    } else {
        targetView.image = [self generateImageWithName:@"tag_highlighted"];
        [targetView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)obj;
                label.textColor = [UIColor whiteColor];
            }
        }];
        self.frontClickIdx = targetView.tag;
    }
    
    if (self.tagChooseBlock) {
        self.tagChooseBlock(catogaryName);
    }
}

@end
