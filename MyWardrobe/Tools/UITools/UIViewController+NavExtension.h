//
//  UIViewController+NavExtension.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/10.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>
//导航控制器的view
#import "MWNavigationView.h"

@interface UIViewController (NavExtension)

/**
 导航栏
 */
@property (nonatomic, strong) MWNavigationView *navigationView;

@end
