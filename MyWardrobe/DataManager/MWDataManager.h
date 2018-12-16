//
//  MWDataManager.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWSignalClothesModel, MWClothesCatogaryModel;

typedef NS_ENUM(NSUInteger, MWDataSaveResult) {
    MWDataSaveResult_Error,
    MWDataSaveResult_Exist,
    MWDataSaveResult_Success,
};

@interface MWDataManager : NSObject

// 分类名数组，数组保证有序
@property (nonatomic, strong, readonly) NSMutableArray <NSString *>*catogaryNameArr;
// 品牌数组
@property (nonatomic, strong, readonly) NSMutableArray <NSString *>*brandArr;
// 用户数据
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, MWClothesCatogaryModel *>*userData;

+ (instancetype)dataManager;

#pragma mark - 更新
/**
 增加新类别

 @param catogaryName 衣服类型名称
 @return 存储结果
 */
- (MWDataSaveResult)addNewCatory:(NSString *)catogaryName;


/**
 更新类别

 @param oldName 旧类别名
 @param newName 新类别n名
 @return 存储结果
 */
- (MWDataSaveResult)updateOldCatory:(NSString *)oldName toNewCatory:(NSString *)newName;

/**
 移动类别位置

 @param chooseCatory 选择的类别
 @param index 新位置
 */
- (void)exchangeCatory:(NSString *)chooseCatory toIndex:(NSInteger)index;

/**
 添加新单品（添加和修改）

 @param signalClothesModel 单品模型
 @return 存储结果
 */
- (MWDataSaveResult)updateSignalClothes:(MWSignalClothesModel *)signalClothesModel;

/**
 增加新品牌

 @param brand 品牌名
 @return 存储结果
 */
- (MWDataSaveResult)addNewBrand:(NSString *)brand;


/**
 更新品牌数据

 @param oldName 旧品牌名
 @param newName 新品牌名
 @return 存储结果
 */
- (MWDataSaveResult)updateOldBrand:(NSString *)oldName toNewBrand:(NSString *)newName;

#pragma mark - 查询
/** 单品总数 */
- (NSInteger)returnAllClothesNumber;

/** 拥有单品的分类数 */
- (NSInteger)returnAllInvalidNumber;

/** 某个分类下的单品数 */
- (NSInteger)returnClothesNumberWithCatogary:(NSString *)catogaryName;

/** 总价格 */
- (NSString *)returnTotalPrice;

#pragma mark - 移除
/**
 移除单品

 @param signalClothesModel 单品模型
 @return 存储结果
 */
- (MWDataSaveResult)removeSignalClothes:(MWSignalClothesModel *)signalClothesModel;

/**
 移除分类

 @param catogaryName 分类名
 @return 存储结果
 */
- (MWDataSaveResult)removeCatogary:(NSString *)catogaryName;


/**
 移除品牌

 @param brand 品牌名
 @return 存储结果
 */
- (MWDataSaveResult)removeBrand:(NSString *)brand;

@end
