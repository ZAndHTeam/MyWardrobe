//
//  MWChooseClothesVM.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWChooseClothesVM.h"

@interface MWChooseClothesVM ()

@property (nonatomic, copy) NSArray *clothesArr;

@end

@implementation MWChooseClothesVM

- (instancetype)initWithData:(NSArray *)clothesArr {
    self = [super init];
    if (self) {
        _clothesArr = [clothesArr copy];
    }
    
    return self;
}

@end
