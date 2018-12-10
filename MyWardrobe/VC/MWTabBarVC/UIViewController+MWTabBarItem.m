//
// Created by Simon Mr on 2018/8/30.
// Copyright (c) 2018 光合. All rights reserved.
//

#import "UIViewController+MWTabBarItem.h"
#import <objc/runtime.h>

static char kMWTabBarItem = '\0';

@implementation UIViewController (MWTabBarItem)

- (void)setMw_tabBarItem:(MWTabBarItem *)mw_tabBarItem {
    objc_setAssociatedObject(self,
                             &kMWTabBarItem,
                             mw_tabBarItem,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MWTabBarItem *)mw_tabBarItem {
    return objc_getAssociatedObject(self, &kMWTabBarItem);
}

@end
