//
//  AppDelegateManager.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDelegateManager : NSObject

/**
 *  单例
 */
+ (instancetype)sharedInstance;

- (void)autolayout;

@end
