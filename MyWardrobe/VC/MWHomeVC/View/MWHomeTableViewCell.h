//
//  MWHomeTableViewCell.h
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookClothesPhoto)(NSArray *photoArr,NSInteger index);
@interface MWHomeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isZero;
@property (nonatomic,copy) LookClothesPhoto lookBlock;

- (void)configData:(NSArray *)clothesArr;

@end
