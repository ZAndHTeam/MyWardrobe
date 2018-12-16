//
//  UIImage+ScaleSize.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleSize)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
