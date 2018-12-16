//
//  MWEqualSpaceFlowLayout.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MWEqualSpaceFlowLayoutDelegate <NSObject>

@required

/** 返回cell大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MWEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<MWEqualSpaceFlowLayoutDelegate> delegate;

//距离上下左右的距离
@property (nonatomic,assign) UIEdgeInsets sectionInsets;

//上下两个item的距离
@property (nonatomic,assign) CGFloat lineSpacing;

//左右两个item的距离
@property (nonatomic,assign) CGFloat interitemSpacing;


@end


