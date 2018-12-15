//
//  MWAlertView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWAlertView.h"

@interface MWAlertView ()

/** 确认按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 输入框 */
@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *inputText;
@property (nonatomic, copy) NSString *confirmString;
@property (nonatomic, copy) NSString *cancelString;

/** 确认按钮回调 */
@property (nonatomic, copy) ConfirmCallback confirmBlock;
/** 确认按钮回调 */
@property (nonatomic, copy) CancelCallback cancelBlock;

/** 蒙版 */
@property (nonatomic, weak) UIView *becloudView;

@end

@implementation MWAlertView

- (instancetype)initWithTitle:(NSString *)title
                    inputText:(NSString *)inputText
                confirmString:(NSString *)confirmString
                 cancelString:(NSString *)cancelString
                  confirBlock:(ConfirmCallback)confirmBlock
                  cancelBlock:(CancelCallback)cancelBlock {
    self = [super init];
    if (self) {
        _title = title.copy;
        _inputText = inputText.copy;
        _confirmString = confirmString.copy;
        _cancelString = confirmString.copy;
        _confirmBlock = [confirmBlock copy];;
        _cancelBlock = [cancelBlock copy];
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    
}

- (void)showAlerr {
    // 蒙版
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [UIColor blackColor];
    becloudView.layer.opacity = 0.3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView:)];
    [becloudView addGestureRecognizer:tapGR];
    
    [[UIApplication sharedApplication].keyWindow addSubview:becloudView];
    self.becloudView = becloudView;
    
    self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
    self.confirmBtn.layer.opacity = 0.5;
    
    // 输入框
    self.frame = CGRectMake(0, 0, becloudView.frame.size.width * 0.8, becloudView.frame.size.height * 0.3);
    self.center = CGPointMake(becloudView.center.x, becloudView.frame.size.height * 0.4);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

@end
