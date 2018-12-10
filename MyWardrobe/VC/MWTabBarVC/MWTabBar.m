//
//  MWTabBar.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/8/28.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWTabBar.h"

#import "UIView+Yoga.h"
#import "ReactiveCocoa.h"
#import "UIViewController+MWTabBarItem.h"
#import "UIView+MWFrame.h"
#import "MacroLayout.h"

@interface MWTabBar ()

@property (nonatomic, strong) NSMutableArray<MWTabBarItem *> *tabBarItemArr;

@property (nonatomic, strong) CALayer *shadowLayer;

@property (nonatomic, assign) BOOL isFirstLayout;

@end

@implementation MWTabBar

- (void)addTabBarItem:(NSArray<UIViewController *> *)vcArr {
    NSAssert(vcArr, @"控制器数组不可为空");

    for (UIViewController *vc in vcArr) {
        [vc.mw_tabBarItem addTabbarItemTo:self];
        [self.tabBarItemArr addObject:vc.mw_tabBarItem];
    }

}

- (void)injectToTabBarVC:(UITabBarController *)tabBarVC {
    @weakify(self);

    self.isFirstLayout = YES;
    [self.tabBarItemArr enumerateObjectsUsingBlock:^(MWTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        tabBarItem.index = idx;
        [tabBarItem addTabbarItemTo:self];
    }];

    [self setShadowImage:[UIImage new]];
    [self setBackgroundImage:[UIImage new]];

    [tabBarVC setValue:self forKey:@"tabBar"];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];
        
        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

#pragma mark - private method

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }

    self.backgroundColor = [UIColor whiteColor];

    if (self.isFirstLayout) {
        self.isFirstLayout = NO;
        [self layoutBarItem];
    }
}

#pragma mark - private method
- (void)layoutBarItem {
    [self configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionRow;
        layout.justifyContent = YGJustifySpaceBetween;
        layout.alignItems = YGAlignFlexStart;
        layout.height = YGPointValue(self.mw_height);
    }];

    CGFloat itemWidth = self.mw_width / self.tabBarItemArr.count;

    @weakify(self);
    [self.tabBarItemArr enumerateObjectsUsingBlock:^(MWTabBarItem *tabBarItem, NSUInteger idx, BOOL *stop) {
        [tabBarItem.backgroundView configureLayoutWithBlock:^(YGLayout *layout) {
            @strongify(self);
            layout.isEnabled = YES;
            layout.width = YGPointValue(itemWidth);
            layout.justifyContent = YGJustifyCenter;
            layout.marginBottom = YGPointValue(HOME_INDICATOR_HEIGHT);

            if (tabBarItem.itemType == MWTabBarItemType_Plus) {
                layout.height = YGPointValue(tabBarItem.itemSize.height);
                layout.alignSelf = YGAlignFlexEnd;
            } else {
                layout.height = YGPointValue(self.mw_height - HOME_INDICATOR_HEIGHT);
            }
        }];

        @weakify(tabBarItem);
        [tabBarItem setClickAction:^() {
            @strongify(self, tabBarItem);
            [self actionByItem:tabBarItem];
        }];

        // 默认选中第一个item
        if (idx == 0) {
            [self actionByItem:tabBarItem];
        }

    }];

    [self.yoga applyLayoutPreservingOrigin:YES];
}

- (void)actionByItem:(MWTabBarItem *)tabBarItem {
    if (tabBarItem.itemType == MWTabBarItemType_Plus) {
        if (self.mw_delegate
            || [self.mw_delegate respondsToSelector:@selector(didSelectPlusItemAtIndex:)]) {

            [self.mw_delegate didSelectPlusItemAtIndex:tabBarItem.index];
        }
    } else {
        if (self.selectIndex
            && tabBarItem.index == self.selectIndex.unsignedIntegerValue) {
            return;
        }

        self.selectIndex = @(tabBarItem.index);

        if (self.mw_delegate
            || [self.mw_delegate respondsToSelector:@selector(didSelectItemAtIndex:ignore:)]) {
            [self.mw_delegate didSelectItemAtIndex:tabBarItem.index ignore:NO];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.hidden
        && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];

        if (!result) {
            for (UIView *subview in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subview convertPoint:point fromView:self];
                result = [subview hitTest:subPoint withEvent:event];
            }
        }

        return result;
    }
    return nil;
}

#pragma mark - setter && getter
- (void)setNeedShadow:(BOOL)needShadow {
    _needShadow = needShadow;
    if (needShadow
        && !self.shadowLayer) {
        // 加入阴影
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -4);
        self.layer.shadowRadius = 8.f;
        self.layer.shadowOpacity = 0.1f;
    } else if (!needShadow) {
        [self.shadowLayer removeFromSuperlayer];
        self.shadowLayer = nil;
    }
}

- (NSMutableArray<MWTabBarItem *> *)tabBarItemArr {
    if (!_tabBarItemArr) {
        _tabBarItemArr = [NSMutableArray array];
    }

    return _tabBarItemArr;
}

- (void)setSelectIndex:(NSNumber *)selectIndex {
    // 设置button的选中状态
    MWTabBarItem *preTabBarItem = self.tabBarItemArr[self.selectIndex.unsignedIntegerValue];
    preTabBarItem.selected = NO;
    _selectIndex = selectIndex;
    MWTabBarItem *selectTabBarItem = self.tabBarItemArr[self.selectIndex.unsignedIntegerValue];
    selectTabBarItem.selected = YES;
}

@end
