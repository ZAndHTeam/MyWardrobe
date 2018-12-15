//
//  MWHomeVM.m
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWHomeVM.h"

#pragma mark - models
#import "MWSignalClothesModel.h"
#import "MWClothesCatogaryModel.h"

#pragma mark - utils
#import "MWDataManager.h"

@interface MWHomeVM ()

@property (nonatomic, copy) NSArray *titleArr;

@end

@implementation MWHomeVM

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleArr = [[MWDataManager dataManager].catogaryNameArr copy];
    }
    return self;
}

#pragma mark - public method
- (NSArray <MWSignalClothesModel *>*)returnClothesArrWithCatogaryName:(NSString *)catogaryName {
    if (!catogaryName
        || catogaryName.length == 0) {
        return nil;
    }
    
    MWClothesCatogaryModel *clothesCatogaryModel = (MWClothesCatogaryModel *)[[MWDataManager dataManager].userData objectForKey:catogaryName];
    return [clothesCatogaryModel.clothesArr copy];
}

@end
