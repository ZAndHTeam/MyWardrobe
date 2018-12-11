//
//  MacroLayout.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/10.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#ifndef MacroLayout_h
#define MacroLayout_h

#import "SysMacro.h"

/** 自定义字体 */
static NSString * const REGULAR_FONT = @"PingFangSC-Regular";
/**加粗字体*/
static NSString * const MEDIUM_FONT = @"PingFangSC-Medium";

//设备宽高
#define SCREEN_SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//导航栏默认y
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

// 导航栏高度
#define NAV_BAR_HEIGHT (STATUS_BAR_HEIGHT + 44)

// home indicator
#define HOME_INDICATOR_HEIGHT (IOS11 ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom : 0)

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define RandColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
//16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* MacroLayout_h */
