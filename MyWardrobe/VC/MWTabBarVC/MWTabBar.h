//
//  MWTabBar.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/8/28.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWTabBarItem.h"

@protocol MWTabBarDelegate <NSObject>

@required
- (void)didSelectItemAtIndex:(NSUInteger)index ignore:(BOOL)ignore;

@optional
- (void)didSelectPlusItemAtIndex:(NSUInteger)index;

@end

@interface MWTabBar : UITabBar

@property (nonatomic, weak) id<MWTabBarDelegate> mw_delegate;

@property (nonatomic, assign) BOOL needShadow;

@property (nonatomic, strong) NSNumber *selectIndex;

/**
 * 添加item
 * @param item tabbarItem
 */
- (void)addTabBarItem:(NSArray<UIViewController *> *)item;

/**
 * TabBar注入
 * @param tabBarVC 目标TabBar控制器
 */
- (void)injectToTabBarVC:(UITabBarController *)tabBarVC;

@end
