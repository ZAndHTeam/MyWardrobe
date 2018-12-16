//
//  MWChooseClothesVC.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWChooseClothesVC.h"

#pragma mark - viewModels


#pragma mark - utils
#import "ReactiveCocoa.h"
#import "MBProgressHUD+SimpleLoad.h"
#import "MWAlertView.h"

@interface MWChooseClothesVC ()

@end

@implementation MWChooseClothesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // navi
    [self layoutNavi];
}

- (void)layoutNavi {
    @weakify(self);
    self.navigationView = [MWNavigationView navigationWithTitle:@"查看单品"
                                                      popAction:^{
                                                          @strongify(self);
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
    
    UILabel *label = [UILabel new];
    label.mw_width = 40.f;
    label.mw_height = 17.f;
    label.mw_left = self.navigationView.navTitleLabel.mw_right + 5;
    label.mw_bottom = self.navigationView.navTitleLabel.mw_bottom;
//    label.text = [NSString stringWithFormat:@"%ld/%ld"];
    
}


@end
