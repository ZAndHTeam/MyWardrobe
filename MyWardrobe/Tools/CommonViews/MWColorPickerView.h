//
//  MWColorPickerView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorClickBlock)(NSString *colorName);

/**
 颜色选择view tag从10000开始
 */
@interface MWColorPickerView : UIView

- (instancetype)initWithWidth:(CGFloat)viewWidth selectedColorArr:(NSArray *)selectedColorArr;

@property (nonatomic, copy) ColorClickBlock colorAction;

@end
