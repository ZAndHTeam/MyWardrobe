//
//  MWHomeVM.h
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWSignalClothesModel;

@interface MWHomeVM : NSObject

/** title Arr */
@property (nonatomic, copy, readonly) NSArray *titleArr;

/**
 刷新数据
 */
- (void)refreshData;

/**
 获取分类下 衣服数组

 @param catogaryName 分类名
 @return 衣服数组
 */
- (NSArray <MWSignalClothesModel *>*)returnClothesArrWithCatogaryName:(NSString *)catogaryName;

@end
