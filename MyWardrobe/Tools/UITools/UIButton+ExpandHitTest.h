//
//  UIButton+ExpandHitTest.h
//  MyWardrobe
//
//  Created by zt on 2019/1/24.
//  Copyright © 2019 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ExpandHitTest)

#pragma mark - 点击区域扩大
/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 eg: self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property(nonatomic, assign) UIEdgeInsets hitEdgeInsets;

#pragma mark - 重复点击
/** 用这个给重复点击加间隔 */
@property(nonatomic, assign) NSTimeInterval timeInterval;

/** YES不允许点击NO允许点击 */
@property(nonatomic, assign) BOOL isIgnoreEvent;

@end
