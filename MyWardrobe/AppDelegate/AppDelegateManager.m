//
//  AppDelegateManager.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "AppDelegateManager.h"

#pragma mark - utils
#import "IQKeyboardManager.h"

@implementation AppDelegateManager

+ (instancetype)sharedInstance {
    static AppDelegateManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AppDelegateManager alloc] init];
    });
    
    return shareInstance;
}

/**
 *  autolayout
 */
- (void)autolayout {
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.enable = YES;
    keyManager.shouldResignOnTouchOutside = YES;
    keyManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyManager.enableAutoToolbar = NO;
    keyManager.keyboardDistanceFromTextField = 150;
}

@end
