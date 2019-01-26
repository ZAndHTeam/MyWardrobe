//
//  MWAlertView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWAlertView.h"

@interface MWAlertView () <UITextFieldDelegate>

/** 确认按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 输入框 */
@property (nonatomic, strong) UITextField *inputTextField;

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
        _inputText = inputText.length > 0 ? inputText.copy : @"";
        _confirmString = confirmString.copy;
        _cancelString = cancelString.copy;
        _confirmBlock = [confirmBlock copy];;
        _cancelBlock = [cancelBlock copy];
        [self configUI];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                confirmString:(NSString *)confirmString
                 cancelString:(NSString *)cancelString
                  confirBlock:(ConfirmCallback)confirmBlock
                  cancelBlock:(CancelCallback)cancelBlock {
    self = [super init];
    if (self) {
        _title = title.copy;
        _confirmString = confirmString.copy;
        _cancelString = cancelString.copy;
        _confirmBlock = [confirmBlock copy];;
        _cancelBlock = [cancelBlock copy];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.f;
    self.frame = CGRectMake(0, 0, 270.f + 38.f - 24.f, 160.f);
    
    // title
    UILabel *titleLabel = ({
        UILabel *label  = [UILabel new];
        label.text = self.title;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:MEDIUM_FONT size:17.f];
        label.frame = CGRectMake(5.f, 20.f, self.mw_width - 10.f, 24.f);
        label;
    });
    [self addSubview:titleLabel];
    
    if (self.inputText) {
        // 输入框
        [self addSubview:({
            self.inputTextField = [UITextField new];
            self.inputTextField.delegate = self;
            self.inputTextField.mw_width = self.mw_width - 32.f;
            self.inputTextField.mw_left = 16.f;
            self.inputTextField.mw_top = titleLabel.mw_bottom + 21.f;
            self.inputTextField.mw_height = 38.f;
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 4.f, 24.f)];
            self.inputTextField.leftView = paddingView;
            self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
            
            self.inputTextField.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.06];
            self.inputTextField.text = self.inputText;
            
            self.inputTextField.font = [UIFont fontWithName:REGULAR_FONT size:15.f];
            
            self.inputTextField;
        })];
    }
    
    // 横竖线
    [self addSubview:({
        // 横线
        UIView *view = [UIView new];
        view.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.1];
        view.mw_width = self.mw_width;
        view.mw_height = 0.5;
        view.mw_top = self.inputTextField.mw_bottom + 12.f;
        view;
    })];
    
    [self addSubview:({
        // 竖线
        UIView *view = [UIView new];
        view.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.1];
        view.mw_width = 0.5;
        view.mw_height = 44.f;
        view.mw_bottom = self.mw_bottom;
        view.mw_centerX = self.mw_centerX;
        view;
    })];
    
    // 按钮
    [self addSubview:({
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn.backgroundColor = [UIColor whiteColor];
        [self.confirmBtn setTitle:self.confirmString forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
        [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FF4141"] forState:UIControlStateNormal];
        
        @weakify(self);
        [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             if (self.confirmBlock) {
                 self.confirmBlock(self.inputTextField.text);
             }
             
             [self dismissAlert];
         }];
        
        self.confirmBtn.mw_width = self.mw_width / 2 - 10.f;
        self.confirmBtn.mw_height = 24.f;
        self.confirmBtn.mw_bottom = self.mw_bottom - 8.f;
        self.confirmBtn.mw_centerX = self.mw_centerX * 1.5;
        self.confirmBtn;
    })];
    
    [self addSubview:({
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.backgroundColor = [UIColor whiteColor];
        [self.cancelBtn setTitle:self.cancelString forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont fontWithName:REGULAR_FONT size:17.f];
        [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        @weakify(self);
        [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             if (self.cancelBlock) {
                 self.cancelBlock();
             }
             
             [self dismissAlert];
         }];
        
        self.cancelBtn.mw_width = self.mw_width / 2 - 10.f;
        self.cancelBtn.mw_height = 24.f;
        self.cancelBtn.mw_bottom = self.mw_bottom - 8.f;
        self.cancelBtn.mw_centerX = self.mw_centerX / 2;
        self.cancelBtn;
    })];
    
    // 键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    // 键盘的消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)showAlert {
    // 蒙版
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView:)];
    [becloudView addGestureRecognizer:tapGR];
    
    [[UIApplication sharedApplication].keyWindow addSubview:becloudView];
    self.becloudView = becloudView;
    
    // 添加
    self.center = self.becloudView.center;
    [self.becloudView addSubview:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:[[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""]]) {
        return NO;
    }
    
    NSString * inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.inputTextField]) {
        if (inputString.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - 消失
- (void)closeAlertView:(UITapGestureRecognizer *)sender {
    [self dismissAlert];
}

- (void)dismissAlert {
    [self.becloudView removeFromSuperview];
}

#pragma mark - 计算
- (CGSize)getLabelHeightWithText:(NSString *)text
                           width:(CGFloat)width {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:REGULAR_FONT size:14.f]} context:nil];
    
    return rect.size;
}

#pragma mark ----- 键盘处理
- (void)keyboardWasShown:(NSNotification*)aNotification {
    //获得键盘的大小
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.mw_bottom > SCREEN_SIZE_HEIGHT - kbSize.height) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:7];
        self.center = CGPointMake(self.mw_centerX, SCREEN_SIZE_HEIGHT - kbSize.height - self.mw_height / 2 - 50.f);
        [UIView commitAnimations];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.center = self.becloudView.center;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    [UIView commitAnimations];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
