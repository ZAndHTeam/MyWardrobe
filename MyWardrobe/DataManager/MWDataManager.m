//
//  MWDataManager.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWDataManager.h"

#import "MWClothesCatogaryModel.h"
#import "MWSignalClothesModel.h"

#import "MJExtension.h"

static NSString * const kUserDataKey = @"user_clothes";
static NSString * const kCatogaryKey = @"catogary_name";
static NSString * const kBrandKey = @"brand";

@interface MWDataManager ()

// 分类名数组，数组保证有序
@property (nonatomic, strong) NSMutableArray <NSString *>*catogaryNameArr;
// 品牌数组
@property (nonatomic, strong) NSMutableArray <NSString *>*brandArr;
// 用户数据
@property (nonatomic, strong) NSMutableDictionary <NSString *, MWClothesCatogaryModel *>*userData;

@end

@implementation MWDataManager

#pragma mark - 单例
+ (instancetype)dataManager {
    static MWDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MWDataManager alloc] init];
        [instance initData];
    });
    return instance;
}

- (void)initData {
    [self initCatogaryNameArr];
    [self initBrandArr];
    [self initUserData];
}

#pragma mark - 懒加载
- (void)initUserData {
    @synchronized (self) {
        if (!_userData) {
            NSMutableDictionary *userDic = [(NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                                       objectForKey:kUserDataKey]] mutableCopy];
            
            if (!userDic) {
                // 本地查询失败 ，则新建数据
                userDic = [NSMutableDictionary dictionary];
                
                [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MWClothesCatogaryModel *catoryModel = [MWClothesCatogaryModel new];
                    catoryModel.catogaryName = obj.copy;
                    catoryModel.clothesArr = [NSArray array];
                    
                    [userDic setObject:catoryModel forKey:obj];
                }];
                
                _userData = userDic;
                [self recordUserData];
            } else {
                // 分类信息字典-->model
                [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MWClothesCatogaryModel *catoryModel = [MWClothesCatogaryModel mj_objectWithKeyValues:[userDic objectForKey:obj]];
                    if (catoryModel) {
                        [userDic setObject:catoryModel forKey:obj];
                    }
                }];
                
                _userData = userDic;
            }
            
        }
    }
}

- (void)initCatogaryNameArr {
    @synchronized (self) {
        if (!_catogaryNameArr) {
            NSArray *catogaryData = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                           objectForKey:kCatogaryKey]];
            if (!catogaryData
                || catogaryData.count == 0) {
                // 本地查询失败 ，则新建数据
                _catogaryNameArr = [NSMutableArray arrayWithObjects:@"未分类", @"外套", @"上衣", @"下装", @"鞋", @"包", nil];
                
                [self recordCatogaryData];
            } else {
                _catogaryNameArr = catogaryData.mutableCopy;
            }
        }
    }
    
}

- (void)initBrandArr {
    @synchronized (self) {
        if (!_brandArr) {
            NSArray *brandData = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                                                                           objectForKey:kBrandKey]];
            if (!brandData) {
                // 本地查询失败 ，则新建数据
                _brandArr = [NSMutableArray array];
                [self recordBrandData];
            } else {
                _brandArr = brandData.mutableCopy;
            }
        }
    }
}

#pragma mark - 压缩数据
// 记录用户数据
- (void)recordUserData {
    if (![_userData isKindOfClass:[NSDictionary class]]
        || _userData.allKeys.count == 0) {
        return;
    }
    
    @synchronized (self) {
        __block NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        [self.userData.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MWClothesCatogaryModel *clothesCatogaryModel = [self.userData objectForKey:obj];
            if (clothesCatogaryModel) {
                [userDic setObject:[clothesCatogaryModel mj_keyValues] forKey:obj];
            }
        }];
        
        // 存储data
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userDic];
        if (userData) {
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:kUserDataKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

// 记录类型数据
- (void)recordCatogaryData {
    if (!_catogaryNameArr) {
        return;
    }
    
    @synchronized (self) {
        // 存储类别名称
        NSData *catogaryNameData = [NSKeyedArchiver archivedDataWithRootObject:self.catogaryNameArr];
        if (catogaryNameData) {
            [[NSUserDefaults standardUserDefaults] setObject:catogaryNameData forKey:kCatogaryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

// 记录品牌
- (void)recordBrandData {
    if (!_brandArr) {
        return;
    }
    
    @synchronized (self) {
        // 存储类别名称
        NSData *catogaryNameData = [NSKeyedArchiver archivedDataWithRootObject:self.brandArr];
        if (catogaryNameData) {
            [[NSUserDefaults standardUserDefaults] setObject:catogaryNameData forKey:kBrandKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

#pragma mark - 添加
// 增加新类别
- (MWDataSaveResult)addNewCatory:(NSString *)catogaryName {
    NSAssert(catogaryName.length > 0, @"需要有分类名称");
    if (!catogaryName
        || catogaryName.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    if ([self.catogaryNameArr containsObject:catogaryName]) {
        return MWDataSaveResult_Exist;
    }
    
    MWClothesCatogaryModel * catoryModel = [MWClothesCatogaryModel new];
    catoryModel.catogaryName = catogaryName;
    
    [self.userData setObject:catoryModel forKey:catogaryName];
    
    // 更新类别
    [self.catogaryNameArr addObject:catogaryName];
    [self recordCatogaryData];
    
    return MWDataSaveResult_Success;
}

// 更新类别
- (MWDataSaveResult)updateOldCatory:(NSString *)oldName toNewCatory:(NSString *)newName {
    NSAssert(oldName.length > 0, @"需要有旧分类名称");
    NSAssert(newName.length > 0, @"需要有新分类名称");
    if (!oldName
        || oldName.length == 0
        || !newName
        || newName.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    if ([self.catogaryNameArr containsObject:newName]) {
        return MWDataSaveResult_Exist;
    }
    
    MWClothesCatogaryModel *catogaryModel = [self.userData objectForKey:oldName];
    [self.userData setObject:catogaryModel forKey:newName];
    
    [self.catogaryNameArr replaceObjectAtIndex:[self.catogaryNameArr indexOfObject:oldName] withObject:newName];
    
    // 更新本地数据
    [self recordCatogaryData];
    // 更新用户数据
    [self recordUserData];
    
    return MWDataSaveResult_Success;
}

// 移动类别位置
- (void)exchangeCatory:(NSString *)chooseCatory toIndex:(NSInteger)index {
    [self.catogaryNameArr removeObject:chooseCatory];
    [self.catogaryNameArr insertObject:chooseCatory atIndex:index];
}

// 更新新单品
- (MWDataSaveResult)updateSignalClothes:(MWSignalClothesModel *)signalClothesModel {
    NSAssert(signalClothesModel.imageDataArr.count > 0, @"需要有图片");
    if (!signalClothesModel
        || signalClothesModel.imageDataArr.count == 0) {
        return MWDataSaveResult_Error;
    }
    
    if (!signalClothesModel) {
        return MWDataSaveResult_Error;
    }
    
    if (!signalClothesModel.catogaryName
        || signalClothesModel.catogaryName.length == 0) {
        // 未写类别则归为"未分类"
        signalClothesModel.catogaryName = @"未分类";
    }
    
    // 查询分类数据
    MWClothesCatogaryModel *catoryModel = [self.userData objectForKey:signalClothesModel.catogaryName];
    
    if (!catoryModel) {
        // 增加新类别
        catoryModel = [MWClothesCatogaryModel new];
        catoryModel.catogaryName = signalClothesModel.catogaryName;
        catoryModel.catogaryName = signalClothesModel.catogaryName;
        
        [self.userData setObject:catoryModel forKey:signalClothesModel.catogaryName];
        
        // 更新类别数组
        [self.catogaryNameArr addObject:signalClothesModel.catogaryName];
        [self recordCatogaryData];
    } else {
        // 已有类别中加入新单品
        NSMutableArray *clothesArr = [catoryModel.clothesArr mutableCopy];
        if (!clothesArr) {
            clothesArr = [NSMutableArray array];
        }
        
        if ([clothesArr containsObject:signalClothesModel]) {
            [clothesArr replaceObjectAtIndex:[clothesArr indexOfObject:signalClothesModel] withObject:signalClothesModel];
        } else {
            [clothesArr addObject:signalClothesModel];
        }
        catoryModel.clothesArr = clothesArr.copy;
        
        [self.userData setObject:catoryModel forKey:signalClothesModel.catogaryName];
    }
    
    // 更新品牌数据l
    if (signalClothesModel.brand
        && ![self.brandArr containsObject:signalClothesModel.brand]) {
        [self addNewBrand:signalClothesModel.brand];
    }
    
    // 更新用户数据
    [self recordUserData];
    
    return MWDataSaveResult_Success;
}

// 更新品牌数据
- (MWDataSaveResult)updateOldBrand:(NSString *)oldName toNewBrand:(NSString *)newName {
    NSAssert(oldName.length > 0, @"需要有旧分类名称");
    NSAssert(newName.length > 0, @"需要有新分类名称");
    if (!oldName
        || oldName.length == 0
        || !newName
        || newName.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    if ([self.brandArr containsObject:newName]) {
        return MWDataSaveResult_Exist;
    }
    
    // 更新单品数据
    @weakify(self, oldName, newName);
    [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self, oldName, newName);
        NSMutableArray *tmpArr = [[self.userData objectForKey:obj].clothesArr mutableCopy];
        @weakify(tmpArr);
        [tmpArr enumerateObjectsUsingBlock:^(MWSignalClothesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(oldName, newName, tmpArr);
            if ([oldName isEqualToString:obj.brand]) {
                obj.brand = newName;
                [tmpArr replaceObjectAtIndex:idx withObject:obj];
            }
        }];
        
        [self.userData objectForKey:obj].clothesArr = tmpArr.copy;
    }];
    
    // 更新品牌数组
    [self.brandArr replaceObjectAtIndex:[self.brandArr indexOfObject:oldName] withObject:newName];
    [self recordBrandData];
    
    // 更新本地数据
    [self recordUserData];
    
    return MWDataSaveResult_Success;
}

// 增加新品牌
- (MWDataSaveResult)addNewBrand:(NSString *)brand {
    NSAssert(brand.length > 0, @"需要有分类名称");
    if (!brand
        || brand.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    if ([self.brandArr containsObject:brand]) {
        return MWDataSaveResult_Exist;
    }
    
    [self.brandArr addObject:brand];
    [self recordBrandData];
    
    return MWDataSaveResult_Success;
}

#pragma mark - 查询
// 单品总数
- (NSInteger)returnAllClothesNumber {
    __block NSInteger clothesNumber = 0;
    @weakify(self);
    [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        clothesNumber += [self.userData objectForKey:obj].clothesArr.count;
    }];
    
    return clothesNumber;
}

// 拥有单品的分类数
- (NSInteger)returnAllInvalidNumber {
    __block NSInteger invalidNumber = 0;
    @weakify(self);
    [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([self.userData objectForKey:obj].clothesArr.count > 0) {
            invalidNumber += 1;
        }
    }];
    
    return invalidNumber;
}

// 某个分类下的单品数
- (NSInteger)returnClothesNumberWithCatogary:(NSString *)catogaryName {
    return [self.userData objectForKey:catogaryName].clothesArr.count;
}

// 总价格
- (NSString *)returnTotalPrice {
    __block CGFloat totalPrice = 0.f;
    @weakify(self);
    [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [[self.userData objectForKey:obj].clothesArr enumerateObjectsUsingBlock:^(MWSignalClothesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            totalPrice += [obj.price floatValue];
        }];
    }];
    
    return [NSString stringWithFormat:@"%.2f", totalPrice];
}

#pragma mark - 移除
// 移除单品
- (MWDataSaveResult)removeSignalClothes:(MWSignalClothesModel *)signalClothesModel {
    if (!signalClothesModel) {
        return MWDataSaveResult_Error;
    }
    
    @weakify(signalClothesModel);
    
    // 删除分类目录下的该单品
    NSMutableArray *tmpArr = [[self.userData objectForKey:signalClothesModel.catogaryName].clothesArr mutableCopy];
    [tmpArr enumerateObjectsUsingBlock:^(MWSignalClothesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(signalClothesModel);
        if ([signalClothesModel.signalClothesId isEqualToString:obj.signalClothesId]) {
            [tmpArr removeObject:obj];
        }
    }];
    
    [self.userData objectForKey:signalClothesModel.catogaryName].clothesArr = tmpArr.copy;
    
    [self recordUserData];
    
    return MWDataSaveResult_Success;
}

// 移除分类
- (MWDataSaveResult)removeCatogary:(NSString *)catogaryName {
    if (!catogaryName
        || catogaryName.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    [self.catogaryNameArr removeObject:catogaryName];
    
    // 如果该分类有单品则移入"未分类"
    if ([self.userData objectForKey:catogaryName].clothesArr.count > 0) {
        NSArray *tmpArr = [self.userData objectForKey:catogaryName].clothesArr.copy;
        NSMutableArray *uncategorizedArr = [self.userData objectForKey:@"未分类"].clothesArr.mutableCopy;
        [uncategorizedArr addObjectsFromArray:tmpArr];
        
        [self.userData setObject:uncategorizedArr.copy forKey:@"未分类"];
    }
    
    [self.userData removeObjectForKey:catogaryName];
    
    [self recordUserData];
    [self recordCatogaryData];
    
    return MWDataSaveResult_Success;
}

// 移除品牌
- (MWDataSaveResult)removeBrand:(NSString *)brand {
    if (!brand
        || brand.length == 0) {
        return MWDataSaveResult_Error;
    }
    
    @weakify(self, brand);
    [self.catogaryNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self, brand);
        NSMutableArray *tmpArr = [[self.userData objectForKey:obj].clothesArr mutableCopy];
        @weakify(tmpArr);
        [tmpArr enumerateObjectsUsingBlock:^(MWSignalClothesModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(brand, tmpArr);
            if ([brand isEqualToString:obj.brand]) {
                obj.brand = nil;
                [tmpArr replaceObjectAtIndex:idx withObject:obj];
            }
        }];
        
        [self.userData objectForKey:obj].clothesArr = tmpArr.copy;
    }];
    
    [self recordUserData];
    [self recordBrandData];
    
    return MWDataSaveResult_Success;
}

@end
