//
//  MWNavigationView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNavigationView.h"

#pragma mark - utils
#import "UIColor+MWEX.h"

@interface MWNavigationView ()

@property (nonatomic, copy) MWNavigationPopBlock navPopBlock;

@end

@implementation MWNavigationView

/** 类方法,调用初始化方法 */
+ (instancetype)navigationWithTitle:(NSString *)title
                          popAction:(MWNavigationPopBlock)navPopBlock {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, NAV_BAR_HEIGHT)
                              navTitle:title
                           navPopBlock:(MWNavigationPopBlock)navPopBlock];
}

#pragma mark - private method
- (instancetype)initWithFrame:(CGRect)frame
                     navTitle:(NSString *)title
                  navPopBlock:(MWNavigationPopBlock)navPopBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _navTitleString = [title copy];
        _navPopBlock = [navPopBlock copy];
        
        ///初始化
        [self initMWNavigationViews];
    }
    return self;
}

/** 初始化 */
- (void)initMWNavigationViews {
    // 返回
    _navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBackBtn.frame = CGRectMake(8, STATUS_BAR_HEIGHT, 40, 40);
    // 增强返回按钮在同一界面上多个控件接受事件时的排他性,避免在一个界面上同时触发多个响应事件导致 crash 问题
    self.navBackBtn.exclusiveTouch = YES;
    [self.navBackBtn setImage:[UIImage imageNamed:@"navigation_icon_back"]
                     forState:UIControlStateNormal];
    
    [self.navBackBtn addTarget:self
                        action:@selector(ycnavigationBack)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.navBackBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:self.navBackBtn];
    
    // 标题
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.navBackBtn.mw_right, STATUS_BAR_HEIGHT, SCREEN_SIZE_WIDTH - 80 * 2, 40.f)];
    self.navTitleLabel.textAlignment   = NSTextAlignmentLeft;
    self.navTitleLabel.font            = [UIFont fontWithName:MEDIUM_FONT size:20.f];
    self.navTitleLabel.textColor       = [UIColor colorWithHexString:@"#333333"];
    self.navTitleLabel.text            = self.navTitleString;
    self.navTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.navTitleLabel];
}

/** 按钮点击事件 */
- (void)ycnavigationBack {
    if (_navPopBlock) {
        _navPopBlock();
    }
}

@end
