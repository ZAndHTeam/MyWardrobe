//
//  MWClothesPhotoCollectionViewCell.h
//  MyWardrobe
//
//  Created by zt on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MWSignalClothesModel;

@interface MWClothesPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) UIImage *clothesImage;

- (void)configWithModel:(MWSignalClothesModel *)model;
@end

