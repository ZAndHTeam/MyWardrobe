//
//  MWPickPictureCell.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MWNewClothesCellType) {
    MWNewClothesCellType_PickPicture,
    MWNewClothesCellType_AddTag,
    MWNewClothesCellType_ShowTag,
    MWNewClothesCellType_PickColor,
    MWNewClothesCellType_Price,
    MWNewClothesCellType_Mark,
};

typedef void (^MWPickPictureCellHeightChangeBlock)(CGSize);

typedef void (^MWNewClothesCellTakePictureBlock)(void);

@interface MWNewClothesCell : UITableViewCell

@property (nonatomic, copy) MWPickPictureCellHeightChangeBlock heightChangeBlock;

@property (nonatomic, copy) MWNewClothesCellTakePictureBlock takePictureBlock;

/**
 初始化

 @param style style
 @param reuseIdentifier reuseIdentifier
 @param type cell类型
 @param data vm
 @return 实例化对象
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                         type:(NSString *)type
                         data:(id)data;

- (void)configCellWithData:(id)data;

- (CGSize)getCellSize;

@end
