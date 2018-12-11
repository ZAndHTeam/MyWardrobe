//
//  MWNewClothesVC.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNewClothesVC.h"

#import "UIView+Yoga.h"
#import "MacroLayout.h"
#import "UIView+MWFrame.h"
#import "UIViewController+NavExtension.h"
#import "ReactiveCocoa.h"

@interface MWNewClothesVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MWNewClothesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // navi
    [self layoutNavi];
    // 主view
    [self layoutScrollView];
    
    
    // 布局
    [self.scrollView.yoga applyLayoutPreservingOrigin:YES];
}

- (void)layoutNavi {
    @weakify(self);
    self.navigationView = [MWNavigationView navigationWithTitle:@"添加单品"
                                                      popAction:^{
                                                          @strongify(self);
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      }];
}

- (void)layoutScrollView {
    self.scrollView = [UIScrollView new];
    self.scrollView.mw_top = NAV_BAR_HEIGHT;
    self.scrollView.backgroundColor = [UIColor redColor];
    
    [self.scrollView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(SCREEN_SIZE_WIDTH);
        layout.height = YGPointValue(SCREEN_SIZE_HEIGHT - NAV_BAR_HEIGHT);
    }];
    
    [self.view addSubview:self.scrollView];
}

@end
