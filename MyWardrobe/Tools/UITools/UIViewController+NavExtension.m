//
//  UIViewController+NavExtension.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/10.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "UIViewController+NavExtension.h"
#import <objc/runtime.h>

static char kMWNavExtension;

@implementation UIViewController (NavExtension)

/**
 生成get方法

 @return navigation导航栏
 */
- (UIView *)navigationView {
    return objc_getAssociatedObject(self, &kMWNavExtension);
}

/**
 set方法,关联属性

 @param navigationView 导航栏
 */
- (void)setNavigationView:(UIView *)navigationView {
    if (navigationView != self.navigationView) {
        // 删除旧的，添加新的
        [self.navigationView removeFromSuperview];
        [self.view insertSubview:navigationView atIndex:20];
        objc_setAssociatedObject(self, &kMWNavExtension, navigationView, OBJC_ASSOCIATION_RETAIN);
    }
}


@end
