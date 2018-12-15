//
//  MWNavigationView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MWNavigationPopBlock)(void);

@interface MWNavigationView : UIView

/**
 初始化导航栏,目前只是支持一种样式,如有以后有需求,在增加
 
 @param title       导航栏标题
 @param navPopBlock 按钮的回调
 
 @return 返回一个导航栏
 */
+ (instancetype)navigationWithTitle:(NSString *)title
                          popAction:(MWNavigationPopBlock)navPopBlock;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/** 返回按钮 */
@property (nonatomic, strong) UIButton *navBackBtn;
/** 标题 */
@property (nonatomic, copy) NSString *navTitleString;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *navTitleColor;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editButton;
/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteButton;

@end
