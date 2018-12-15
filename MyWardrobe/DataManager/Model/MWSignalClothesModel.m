//
//  MWSignalClothesModel.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWSignalClothesModel.h"

#pragma mark - utils
#import "MWIDGenerator.h"
#import "MJExtension.h"

@implementation MWSignalClothesModel

/** 生成id */
- (NSString *)catogaryId {
    if (!_signalClothesId) {
        return [[MWIDGenerator generateID] copy];
    }
    
    return _signalClothesId;
}

@end
