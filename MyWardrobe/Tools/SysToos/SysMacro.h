//
//  SysMacro.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/10.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#ifndef SysMacro_h
#define SysMacro_h

//判断是nil 或者Null
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//角度转弧度
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

//获取系统时间戳
#define CURRENT_SYSTEM_TIME [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]


#pragma mark - iOS系统版本判断

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)

#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)

#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES : NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define WeakObj(o) try {}@finally {} __weak typeof(o) o##Weak = o;

#define StrongObj(o) try {}@finally {} __strong typeof(o) o = o##Weak;

#define YCEnsureValidString(x) x ? :@""

#define YCEnsureValidNumber(x) x ? :@0

// 设备判断
#define isIPhoneXSeries \
({ \
    BOOL iPhoneXSeries = NO;\
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) { \
        iPhoneXSeries; \
    } \
 \
    if (@available(iOS 11.0, *)) { \
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window]; \
        if (mainWindow.safeAreaInsets.bottom > 0.0) { \
            iPhoneXSeries = YES; \
        } \
    } \
    iPhoneXSeries; \
}) \

#endif /* SysMacro_h */
