//
//  MWHomeTableViewCell.h
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWHomeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isZero;

- (void)configData:(NSArray *)clothesArr;

@end
