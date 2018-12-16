//
//  MWClothesCatogary.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWClothesCatogaryModel.h"

#pragma mark - utils
#import "MWIDGenerator.h"
#import "MJExtension.h"

@implementation MWClothesCatogaryModel

+ (NSDictionary *)objectClassInArray {
    return @{@"clothesArr": [MWSignalClothesModel class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self catogaryId];
    }
    return self;
}

/** 生成id */
- (NSString *)catogaryId {
    if (!_catogaryId) {
        _catogaryId = [[MWIDGenerator generateID] copy];
    }
    
    return _catogaryId;
}

@end
