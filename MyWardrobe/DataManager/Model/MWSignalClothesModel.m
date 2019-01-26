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

#pragma mark - 深拷贝 解档 归档
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

// 解档
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (NSInteger i=0; i<count; i++) {
            
            Ivar ivar = ivars[i];
            NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
            id value = [coder decodeObjectForKey:name];
            if(value) [self setValue:value forKey:name];
        }
        
        free(ivars);
    }
    return self;
}

// 归档
- (void)encodeWithCoder:(NSCoder *)coder {
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (NSInteger i=0; i<count; i++) {
        
        Ivar ivar = ivars[i];
        NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:name];
        if(value) [coder encodeObject:value forKey:name];
    }
    
    free(ivars);
}

@end
