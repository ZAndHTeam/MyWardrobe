//
//  MWExpandCell.m
//  MyWardrobe
//
//  Created by zt on 2019/1/26.
//  Copyright © 2019 Simon Mr. All rights reserved.
//

#import "MWExpandCell.h"

@interface MWExpandCell ()

@end

@implementation MWExpandCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCustomAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    self.accessoryType = accessoryType;
    
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_normal"]];
        self.accessoryView = accessoryImgView;
    }
}

- (void)setIsExpand:(BOOL)isExpand {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        if (isExpand) {
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow"]];
            self.accessoryView = accessoryImgView;
        } else {
            UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_normal"]];
            self.accessoryView = accessoryImgView;
        }
    }
    
    _isExpand = isExpand;
}

@end
