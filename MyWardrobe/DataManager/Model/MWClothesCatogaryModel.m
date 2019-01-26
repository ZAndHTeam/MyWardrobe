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

#pragma mark - 解档 归档
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
