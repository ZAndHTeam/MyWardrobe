//
//  MWTabBarVC.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/10.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWTabBarVC.h"

#pragma mark - views
#import "MWTabBarItem.h"
#import "MWTabBar.h"
#import "MWNewClothesVC.h"
#import "MWHomeVC.h"

#pragma mark - utils
#import "UIViewController+MWTabBarItem.h"

static const CGFloat kTabItemImageOffsetY = 5;

@interface MWTabBarVC () <UITabBarControllerDelegate, MWTabBarDelegate>

/** 自定义tabBar */
@property (nonatomic, strong) MWTabBar *mw_tabbar;

@end

@implementation MWTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configTabBar];
}

- (void)configTabBar {
    NSMutableArray *childViewControllers = @[].mutableCopy;
    // 衣橱首页
    MWHomeVC *allClothes = [MWHomeVC new];
    allClothes.view.backgroundColor = [UIColor whiteColor];
    allClothes.tabBarItem.imageInsets = UIEdgeInsetsMake(kTabItemImageOffsetY, 0, -kTabItemImageOffsetY, 0);
    allClothes.mw_tabBarItem = [[MWTabBarItem alloc] initWithNormalImage:[UIImage imageNamed:@"tabbar_icon_clothes_normal"]
                                                           selectedImage:[UIImage imageNamed:@"tabbar_icon_clothes_highlighted"]
                                                                    type:MWTabBarItemType_Image];
    [childViewControllers addObject:allClothes];
    
    // 添加按钮
    UIViewController *addNewVC = [[UIViewController alloc] init];
    addNewVC.view.backgroundColor = [UIColor blueColor];
    addNewVC.mw_tabBarItem = [[MWTabBarItem alloc] initWithNormalImage:[UIImage imageNamed:@"tabbar_icon_add"]
                                                        selectedImage:[UIImage imageNamed:@"tabbar_icon_add"]
                                                                 type:MWTabBarItemType_Plus];
    [childViewControllers addObject:addNewVC];
    
    // 设置中心
    UIViewController *settingVC = [[UIViewController alloc] init];
    settingVC.mw_tabBarItem = [[MWTabBarItem alloc] initWithNormalImage:[UIImage imageNamed:@"tabbar_icon_site_normal"]
                                                          selectedImage:[UIImage imageNamed:@"tabbar_icon_site_highlighted"]
                                                                   type:MWTabBarItemType_Image];
    [childViewControllers addObject:settingVC];
    
    // 配置自定义TabBar
    self.mw_tabbar = [[MWTabBar alloc] init];
    self.mw_tabbar.needShadow = YES;
    self.mw_tabbar.mw_delegate = self;
    [self.mw_tabbar addTabBarItem:childViewControllers];
    [self.mw_tabbar injectToTabBarVC:self];
    
    self.viewControllers = childViewControllers;
}

- (void)didSelectItemAtIndex:(NSUInteger)index ignore:(BOOL)ignore {
    if (ignore) {
        return;
    }
    
    self.selectedIndex = index;
    
}

- (void)didSelectPlusItemAtIndex:(NSUInteger)index {
    MWNewClothesVC *newClothesVC = [MWNewClothesVC new];
    
    UINavigationController *controllerToPresent = [[UINavigationController alloc] initWithRootViewController:newClothesVC];
    [controllerToPresent setNavigationBarHidden:YES];
    
    [controllerToPresent setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:controllerToPresent
                       animated:YES
                     completion:NULL];
    
}

@end
