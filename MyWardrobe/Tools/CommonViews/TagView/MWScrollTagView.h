//
//  MWScrollTagView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/14.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddNewLabelBlock)(NSString *tagName);
typedef void(^SizeChangeBlock)(void);
typedef void(^TagChooseBlock)(NSString *tagName);
typedef void(^TagCancelChooseBlock)(NSString *tagName);

/**
 滚动标签，tag从1000开始，布局完后需要外部调用apply
 */
@interface MWScrollTagView : UIView

@property (nonatomic, copy) AddNewLabelBlock addNewLabelBlock;
@property (nonatomic, copy) SizeChangeBlock sizeChangeBlock;
@property (nonatomic, copy) TagChooseBlock tagChooseBlock;
@property (nonatomic, copy) TagCancelChooseBlock tagCancelChooseBlock;

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertConfirmString;
@property (nonatomic, copy) NSString *alertCancelString;

@property (nonatomic, copy) NSString *selectStr;

@property (nonatomic, assign) BOOL haveAddButton;

// 多选
@property (nonatomic, strong) NSMutableArray *selectedStrArr;

/**
 单选

 @param tagArr 标签数组
 @param leftMaxWidth leftMaxWidth
 @param selectStr 已选标签
 @return 实例化对象
 */
- (instancetype)initWithTagArr:(NSArray<NSString *> *)tagArr
                  maxLeftWidth:(CGFloat)leftMaxWidth
                 withSelectStr:(NSString *)selectStr;


/**
 多选

 @param tagArr 标签数组
 @param leftMaxWidth leftMaxWidth
 @param selectStrArr 已选标签数组
 @return 实例化对象
 */
- (instancetype)initWithTagArr:(NSArray<NSString *> *)tagArr
                  maxLeftWidth:(CGFloat)leftMaxWidth
              withSelectStrArr:(NSArray *)selectStrArr;

- (instancetype)init NS_UNAVAILABLE;

- (void)scrollToBottom;

@end
