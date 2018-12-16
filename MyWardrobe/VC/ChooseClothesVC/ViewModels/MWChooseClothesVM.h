//
//  MWChooseClothesVM.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWChooseClothesVM : NSObject

@property (nonatomic, copy, readonly) NSArray *clothesArr;

- (instancetype)initWithData:(NSArray *)clothesArr;

@end
