//
//  MWNewClothesVM.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNewClothesVM.h"

#pragma mark - models

@interface MWNewClothesVM ()

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, strong) MWSignalClothesModel *signalClothesModel;

@property (nonatomic, assign) MWNewClothesVMType viewType;

@end

@implementation MWNewClothesVM

- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        if (data
            && [data isKindOfClass:[MWSignalClothesModel class]]) {
            self.viewType = MWNewClothesVMType_Edit;
            _signalClothesModel = (MWSignalClothesModel *)data;
        } else if (!data) {
            self.viewType = MWNewClothesVMType_New;
            _signalClothesModel = [MWSignalClothesModel new];
            _signalClothesModel.seasonArr = [NSMutableArray array];
        } else {
            NSAssert([data isKindOfClass:[MWSignalClothesModel class]], @"data需为单品模型");
        }
    }
    
    return self;
}

#pragma mark - table view相关
// 数据源
- (NSArray *)dataSource {
    return @[@"picture", @"分类", @"季节", @"颜色", @"品牌", @"价格", @"备注"];
}

// cell高度字典
- (NSMutableDictionary *)cellHeightDic {
    if (!_cellHeightDic) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    
    return _cellHeightDic;
}

#pragma mark - public method
- (void)saveCatogaryName:(NSString *)catogaryName {
    self.signalClothesModel.catogaryName = catogaryName.copy;
}

- (void)savePicture:(NSData *)picture {
    if (!picture) {
        return;
    }
    self.signalClothesModel.imageDataArr = [NSArray arrayWithObject:picture];
}

- (void)saveSeason:(NSString *)season {
    if (season.length == 0) {
        return;
    }
    [self.signalClothesModel.seasonArr addObject:season];
}

- (void)deleteSeason:(NSString *)season {
    if (season.length == 0) {
        return;
    }
    [self.signalClothesModel.seasonArr removeObject:season];
}

- (void)saveColor:(NSString *)colorName {
    self.signalClothesModel.color = colorName.copy;
}

- (void)saveBrand:(NSString *)brand {
    self.signalClothesModel.brand = brand.copy;
}

- (void)savePrice:(NSString *)price {
    self.signalClothesModel.price = price.copy;
}

- (void)saveMark:(NSString *)mark {
    self.signalClothesModel.mark = mark.copy;
}

- (NSString *)saveClothes {
    if (!self.signalClothesModel) {
        return @"放入失败，请重新尝试";
    }
    
    MWDataSaveResult result = [[MWDataManager dataManager] updateSignalClothes:self.signalClothesModel];
    if (result == MWDataSaveResult_Error) {
        return @"放入失败，请重新尝试";
    }
    
    return @"衣橱里有更新哦！";
}

@end
