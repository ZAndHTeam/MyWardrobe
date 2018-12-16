//
//  MWColorPickerView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorClickBlock)(NSString *colorName);

@interface MWColorPickerView : UIView

- (instancetype)initWithWidth:(CGFloat)viewWidth;

@property (nonatomic, copy) ColorClickBlock colorAction;

@end
