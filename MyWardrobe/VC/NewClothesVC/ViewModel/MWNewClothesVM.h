//
//  MWNewClothesVM.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWSignalClothesModel.h"
#import "MWClothesCatogaryModel.h"
#import "MWSignalClothesModel.h"

typedef NS_ENUM(NSUInteger, MWNewClothesVMType) {
    MWNewClothesVMType_New,
    MWNewClothesVMType_Edit,
};

@interface MWNewClothesVM : NSObject
/** 单品数据 */
@property (nonatomic, strong, readonly) MWSignalClothesModel *signalClothesModel;
/** 数据源 */
@property (nonatomic, copy, readonly) NSArray *dataSource;
/** cell高度字典 */
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic;

@property (nonatomic, assign, readonly) MWNewClothesVMType viewType;

- (instancetype)initWithData:(id)data;

- (void)savePicture:(NSData *)picture;

- (void)saveCatogaryName:(NSString *)catogaryName;

- (void)saveSeason:(NSString *)season;

- (void)saveColor:(NSString *)colorName;

- (void)saveBrand:(NSString *)brand;

- (void)savePrice:(NSString *)price;

- (void)saveMark:(NSString *)mark;

- (NSString *)saveClothes;

@end
