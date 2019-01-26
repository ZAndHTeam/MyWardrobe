//
//  MWExpandCell.h
//  MyWardrobe
//
//  Created by zt on 2019/1/26.
//  Copyright © 2019 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWExpandCell : UITableViewCell

@property (nonatomic, assign) BOOL isExpand;

- (void)setCustomAccessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
