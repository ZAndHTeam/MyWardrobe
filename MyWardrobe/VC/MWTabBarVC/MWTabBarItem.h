//
// Created by Simon Mr on 2018/8/29.
// Copyright (c) 2018 光合. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ReactiveCocoa, MWTabBarItem;

/** TabBar点击事件 */
typedef void (^MWTabBarItemClickAction)();

/**
 * TabBar类型
 */
typedef NS_ENUM(NSInteger, MWTabBarItemType) {
    MWTabBarItemType_Image,                 // 只有图片
    MWTabBarItemType_TopImageBottomTitle,   // 上图下文，需设置文字
    MWTabBarItemType_Plus                   // 加号类型
};

/**
 * MWTabBarItem
 */
@interface MWTabBarItem : NSObject

/** 文字 */
@property (nonatomic, copy) NSString *title;


/** 角标 */
@property (nonatomic, assign) NSUInteger index;
/** TabBar类型 */
@property (nonatomic, assign) MWTabBarItemType itemType;
/** Size */
@property (nonatomic, assign) CGSize itemSize;
/** 背景视图，layout使用 */
@property (nonatomic, strong) UIView *backgroundView;
/** 选中状态 */
@property (nonatomic, assign) BOOL selected;
/** tab点击事件 */
@property (nonatomic, copy) MWTabBarItemClickAction clickAction;

/** 正常情况的图片 */
@property (nonatomic, strong) UIImage *normalImage;

/** 选中情况的图片 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 * 初始化方法
 * @param image
 * @param selectedImage
 * @param type
 * @return
 */
- (instancetype)initWithNormalImage:(UIImage *)image
                      selectedImage:(UIImage *)selectedImage
                               type:(MWTabBarItemType)type;

/**
 * 添加TabBar的item
 * @param superView 俯视图
 */
- (void)addTabbarItemTo:(UIView *)superView;

@end
