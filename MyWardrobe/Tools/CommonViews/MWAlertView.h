//
//  MWAlertView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 确认按钮回调的block */
typedef void(^ConfirmCallback)(NSString *inputString);

/** 取消 */
typedef void(^CancelCallback)(void);

@interface MWAlertView : UIView


/**
 简单弹框

 @param title title
 @param confirmString confirmString
 @param cancelString cancelString
 @param confirmBlock confirmBlock
 @param cancelBlock cancelBlock
 @return 实例化对象
 */
- (instancetype)initWithTitle:(NSString *)title
                confirmString:(NSString *)confirmString
                 cancelString:(NSString *)cancelString
                  confirBlock:(ConfirmCallback)confirmBlock
                  cancelBlock:(CancelCallback)cancelBlock;

/**
 初始化输入弹框
 
 @param title title
 @param inputText 输入框文本
 @param confirmString 确定按钮文案
 @param cancelString 取消按钮文案
 @param confirmBlock 确定事件
 @param cancelBlock 取消事件
 @return 实例化对象
 */
- (instancetype)initWithTitle:(NSString *)title
                    inputText:(NSString *)inputText
                confirmString:(NSString *)confirmString
                 cancelString:(NSString *)cancelString
                  confirBlock:(ConfirmCallback)confirmBlock
                  cancelBlock:(CancelCallback)cancelBlock;

#pragma mark - show和dismiss
- (void)showAlert;
- (void)dismissAlert;

@end
