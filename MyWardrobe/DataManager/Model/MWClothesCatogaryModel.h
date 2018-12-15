//
//  MWClothesCatogary.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWSignalClothesModel.h"

/**
 衣服分类
 */
@interface MWClothesCatogaryModel : NSObject

/** 分类Id */
@property (nonatomic, copy) NSString *catogaryId;
/** 分类名称（未分类，上衣等 */
@property (nonatomic, copy) NSString *catogaryName;
/** 单品数组 */
@property (nonatomic, copy) NSArray <MWSignalClothesModel *>*clothesArr;

@end
