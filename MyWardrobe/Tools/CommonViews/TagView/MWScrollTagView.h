//
//  MWScrollTagView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/14.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString *(^AddNewLabelBlock)(void);
typedef void(^SizeChangeBlock)(void);
typedef void(^TagChooseBlock)(NSString *tagName);

/**
 布局完后需要外部调用apply
 */
@interface MWScrollTagView : UIView

@property (nonatomic, copy) AddNewLabelBlock addNewLabelBlock;
@property (nonatomic, copy) SizeChangeBlock sizeChangeBlock;
@property (nonatomic, copy) TagChooseBlock tagChooseBlock;

@property (nonatomic, assign) BOOL haveAddButton;

- (instancetype)initWithTagArr:(NSArray<NSString *> *)tagArr maxLeftWidth:(CGFloat)leftMaxWidth;

- (instancetype)init NS_UNAVAILABLE;

- (void)scrollToBottom;

@end
