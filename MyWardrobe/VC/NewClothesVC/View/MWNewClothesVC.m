//
//  MWNewClothesVC.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/11.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWNewClothesVC.h"

#pragma mark - viewModels
#import "MWNewClothesVM.h"

#pragma mark - utils
#import "MacroLayout.h"
#import "UIView+MWFrame.h"
#import "UIViewController+NavExtension.h"
#import "ReactiveCocoa.h"

@interface MWNewClothesVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MWNewClothesVM *viewModel;

@end

@implementation MWNewClothesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // navi
    [self layoutNavi];
    // 主view
    [self layoutScrollView];
    
    
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   NAV_BAR_HEIGHT,
                                                                   SCREEN_SIZE_WIDTH,
                                                                   SCREEN_SIZE_HEIGHT - NAV_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor redColor];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

@end
