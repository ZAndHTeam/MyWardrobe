//
//  MWDragTagCell.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWDragTagCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, strong) UIColor *tagTextColor;

- (void)setTagName:(NSString *)tagName cellWidth:(CGFloat)width;
- (void)setImageName:(NSString *)imageName cellWidth:(CGFloat)width;

@end
