//
//  MWDragTagView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TagClickBlock)(NSString *tagName);
typedef void(^TagUpdateBlock)(NSString *oldTagName, NSString *newTagName);

@interface MWDragTagView : UIView

/** 刷新订阅 */
@property (nonatomic, strong) RACSubject *reloadSubject;
/** tag颜色 */
@property (nonatomic, strong) UIColor *tagTextColor;
/** tag更新事件 */
@property (nonatomic, copy) TagUpdateBlock updateBlock;
/** tag删除事件 */
@property (nonatomic, copy) TagClickBlock deleteBlock;
/** tag增加事件 */
@property (nonatomic, copy) TagClickBlock addBlock;

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                         edit:(BOOL)canEdit
                      canDrag:(BOOL)canDrag
                   tagNameArr:(NSArray *)tagNameArr;

- (void)configUI;

// 重置数据
- (void)reloadDataWithTagNameArr:(NSArray *)tagNameArr;

@end
