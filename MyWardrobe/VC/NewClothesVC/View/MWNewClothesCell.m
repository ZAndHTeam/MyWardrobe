//
//  MWPickPictureCell.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNewClothesCell.h"

#pragma mark - views
#import "MWScrollTagView.h"
#import "MWColorPickerView.h"

#pragma mark - vm
#import "MWNewClothesVM.h"

#pragma mark - utils
#import "UIView+Yoga.h"
#import "MWAlertView.h"

@interface MWNewClothesCell ()

// 背景图
@property (nonatomic, strong) UIView *bgView;
// 图像
@property (nonatomic, strong) UIImageView *pictureImageView;

@property (nonatomic, strong) UITextView *markTextView;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) MWNewClothesVM *viewModel;

@end

@implementation MWNewClothesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString *)type {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _type = type.copy;
    
    [self configUI];
    
    return self;
}

- (void)configCellWithData:(id)data {
    if (![data isKindOfClass:[MWNewClothesVM class]]) {
        return;
    }
    
    self.viewModel = data;
}

#pragma mark - private method
- (void)configUI {
    self.bgView = [UIView new];
    [self.contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
    }];
    
    [self.contentView addSubview:self.bgView];
    
    [self.bgView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(SCREEN_SIZE_WIDTH);
        layout.alignItems = YGAlignCenter;
    }];
    
    // 动态配置
    if ([self.type isEqualToString:@"picture"]) {
        [self configPicture];
    } else if ([self.type isEqualToString:@"分类"]) {
        [self configCatogary];
    } else if ([self.type isEqualToString:@"季节"]) {
        [self configSeason];
    } else if ([self.type isEqualToString:@"颜色"]) {
        [self configPickColor];
    } else if ([self.type isEqualToString:@"品牌"]) {
        [self configBrand];
    } else if ([self.type isEqualToString:@"价格"]) {
        [self configPrice];
    } else if ([self.type isEqualToString:@"备注"]) {
        [self configMark];
    }
    
    [self.bgView addSubview:({
        UIView *view = [UIView new];
        [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(SCREEN_SIZE_WIDTH);
            layout.height = YGPointValue(30.f);
        }];
        
        view;
    })];
    
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
}

#pragma mark - 分类型建立cell
- (void)addMarginViewWithTitle:(NSString *)title {
    [self.bgView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(SCREEN_SIZE_WIDTH);
        layout.alignItems = YGAlignFlexStart;
    }];
    
    [self.bgView addSubview:({
        UILabel *label = [UILabel new];
        label.text = title;
        label.font = [UIFont fontWithName:REGULAR_FONT size:14.f];
        label.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4];
        [label configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.height = YGPointValue(20.f);
            layout.marginLeft = YGPointValue(15.f);
        }];
        
        label;
    })];
    
    [self.bgView addSubview:({
        UIView *view = [UILabel new];
        [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.height = YGPointValue(10.f);
        }];
        view;
    })];
}

// 图片
- (void)configPicture {
    [self.bgView addSubview:({
        self.pictureImageView = [UIImageView new];
        [self.pictureImageView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
            layout.isEnabled = YES;
            layout.width = YGPointValue(255.f);
            layout.height = YGPointValue(340.f);
        }];
        
        // TODO: 需要数据判断
//        self.pictureImageView.image = [UIImage imageNamed:@""];
        
        self.pictureImageView.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.3];
        
        self.pictureImageView;
    })];
}

// 分类
- (void)configCatogary {
    [self addMarginViewWithTitle:@"分类"];
    
    MWScrollTagView *tagScrollView = [[MWScrollTagView alloc] initWithTagArr:[MWDataManager dataManager].catogaryNameArr
                                                                maxLeftWidth:SCREEN_SIZE_WIDTH - 77.f];
    
    tagScrollView.alertTitle = @"添加分类";
    tagScrollView.alertConfirmString = @"添加";
    tagScrollView.alertCancelString = @"放弃";
    
    [tagScrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.height = YGPointValue(26.f);
        layout.marginLeft = YGPointValue(15.f);
    }];
    
    @weakify(self, tagScrollView);
    tagScrollView.sizeChangeBlock = ^{
        @strongify(self, tagScrollView);
        [self.contentView.yoga applyLayoutPreservingOrigin:NO];
        [tagScrollView scrollToBottom];
    };
    
    // 选择
    tagScrollView.tagChooseBlock = ^(NSString *tagName) {
        @strongify(self);
        [self.viewModel saveCatogaryName:tagName];
    };
    
    [self.bgView addSubview:tagScrollView];
}

// 季节
- (void)configSeason {
    [self addMarginViewWithTitle:@"季节"];
    
    MWScrollTagView *tagScrollView = [[MWScrollTagView alloc] initWithTagArr:@[@"四季", @"春", @"夏", @"秋", @"冬"]
                                                                maxLeftWidth:SCREEN_SIZE_WIDTH - 77.f];
    
    [tagScrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.height = YGPointValue(26.f);
        layout.marginLeft = YGPointValue(15.f);
    }];
    
    // 选择
    @weakify(self);
    tagScrollView.tagChooseBlock = ^(NSString *tagName) {
        @strongify(self);
        [self.viewModel saveSeason:tagName];
    };
    
    [tagScrollView setHaveAddButton:NO];
    
    [self.bgView addSubview:tagScrollView];
}

// 颜色
- (void)configPickColor {
    [self addMarginViewWithTitle:@"颜色"];
    MWColorPickerView *colorView = [[MWColorPickerView alloc] initWithWidth:SCREEN_SIZE_WIDTH - 15.f];
    [colorView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.height = YGPointValue(32.f);
        layout.marginLeft = YGPointValue(15.f);
    }];
    
    @weakify(self);
    colorView.colorAction = ^(NSString *colorName) {
        @strongify(self);
        [self.viewModel saveColor:colorName];
        [self.contentView.yoga applyLayoutPreservingOrigin:NO];
    };
    
    [self.bgView addSubview:colorView];
}

// 品牌
- (void)configBrand {
    [self addMarginViewWithTitle:@"品牌"];
    
    MWScrollTagView *tagScrollView = [[MWScrollTagView alloc] initWithTagArr:[MWDataManager dataManager].brandArr
                                                                maxLeftWidth:SCREEN_SIZE_WIDTH - 77.f];
    tagScrollView.alertTitle = @"添加分类";
    tagScrollView.alertConfirmString = @"添加";
    tagScrollView.alertCancelString = @"放弃";
    
    [tagScrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.height = YGPointValue(26.f);
        layout.marginLeft = YGPointValue(15.f);
    }];
    
    @weakify(self, tagScrollView);
    tagScrollView.sizeChangeBlock = ^{
        @strongify(self, tagScrollView);
        [self.contentView.yoga applyLayoutPreservingOrigin:NO];
        [tagScrollView scrollToBottom];
    };
    
    // 选择
    tagScrollView.tagChooseBlock = ^(NSString *tagName) {
        @strongify(self);
        [self.viewModel saveBrand:tagName];
    };
    
    [self.bgView addSubview:tagScrollView];
}

- (void)configPrice {
    [self addMarginViewWithTitle:@"价格"];
    UITextField *textFiled = [UITextField new];
    textFiled.placeholder = @"添加价格";
    textFiled.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
    [textFiled configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.marginLeft = YGPointValue(15.f);
        layout.height = YGPointValue(26.f);
        layout.width = YGPointValue(200.f);
    }];
    
    [self.bgView addSubview:textFiled];

}

- (void)configMark {
    [self addMarginViewWithTitle:@"备注"];
    
    UITextField *textFiled = [UITextField new];
    textFiled.placeholder = @"添加备注";
    textFiled.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
    [textFiled configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.marginLeft = YGPointValue(15.f);
        layout.height = YGPointValue(26.f);
        layout.width = YGPointValue(200.f);
    }];
    
    [self.bgView addSubview:textFiled];
}

#pragma mark - 高度计算
- (CGSize)caculationCellSize {
    CGSize cellSize = self.bgView.yoga.intrinsicSize;
    
    if (self.heightChangeBlock) {
        self.heightChangeBlock(cellSize);
    }
    
    return cellSize;
}

- (CGSize)getCellSize {
    return [self caculationCellSize];
}

- (void)setFrame:(CGRect)frame {
    // 消除右半部分空白区域
    frame.size.width = SCREEN_SIZE_WIDTH;
    frame.origin.x = 0;
    [super setFrame:frame];
}

@end
