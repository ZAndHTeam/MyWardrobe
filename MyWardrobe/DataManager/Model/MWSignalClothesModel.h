//
//  MWSignalClothesModel.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/13.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWSignalClothesModel : NSObject<NSMutableCopying>

/** 单品Id */
@property (nonatomic, copy) NSString *signalClothesId;
/** 分类名称（未分类，上衣等 */
@property (nonatomic, copy) NSString *catogaryName;
/** 季节 */
@property (nonatomic, strong) NSArray<NSString *> *seasonArr;
/** 图片 */
@property (nonatomic, copy) NSArray <NSData *>*imageDataArr;
/** 颜色 */
@property (nonatomic, copy) NSString *color;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 品牌 */
@property (nonatomic, copy) NSString *brand;
/** 备注 */
@property (nonatomic, copy) NSString *mark;

@end
