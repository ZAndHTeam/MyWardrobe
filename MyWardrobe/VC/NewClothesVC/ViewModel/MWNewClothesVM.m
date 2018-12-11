//
//  MWNewClothesVM.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNewClothesVM.h"

@interface MWNewClothesVM ()

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation MWNewClothesVM

- (NSArray *)dataSource {
    return @[@"picture", @"分类", @"季节", @"颜色", @"品牌", @"价格", @"备注"];
}

@end
