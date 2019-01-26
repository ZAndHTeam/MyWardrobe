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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self catogaryId];
    }
    return self;
}

/** 生成id */
- (NSString *)catogaryId {
    if (!_signalClothesId) {
        _signalClothesId = [[MWIDGenerator generateID] copy];
    }
    
    return _signalClothesId;
}

#pragma mark - 深拷贝
- (id)mutableCopyWithZone:(NSZone *)zone {
    MWSignalClothesModel *clothesModel = [[MWSignalClothesModel allocWithZone:zone] init];
    clothesModel.signalClothesId = self.signalClothesId.copy;
    clothesModel.catogaryName = self.catogaryName.copy;
    clothesModel.seasonArr = self.seasonArr.copy;
    clothesModel.imageDataArr = self.imageDataArr.copy;
    clothesModel.color = self.color.copy;
    clothesModel.price = self.price.copy;
    clothesModel.brand = self.brand.copy;
    clothesModel.mark = self.mark.copy;
    
    return clothesModel;
}

@end
