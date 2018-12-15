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
#import "MWNewClothesCell.h"

#pragma mark - utils
#import "ReactiveCocoa.h"

@interface MWNewClothesVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MWNewClothesVM *viewModel;

@end

@implementation MWNewClothesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [MWNewClothesVM new];
    
    // navi
    [self layoutNavi];
    // 主view
    [self layoutTableView];
}

- (void)layoutNavi {
    @weakify(self);
    self.navigationView = [MWNavigationView navigationWithTitle:@"添加单品"
                                                      popAction:^{
                                                          @strongify(self);
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      }];
}

- (void)layoutTableView {
    CGFloat tabbarHeight = isIPhoneXSeries ? HOME_INDICATOR_HEIGHT + 108.f : 108.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f,
                                                                   NAV_BAR_HEIGHT + 20.f,
                                                                   SCREEN_SIZE_WIDTH,
                                                                   SCREEN_SIZE_HEIGHT - NAV_BAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = ({
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 100, tabbarHeight);
        view;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    NSNumber *cellHeight = self.viewModel.cellHeightDic[key];
    
    return cellHeight.floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"MWPickPictureCell-%@", key];
    
    MWNewClothesCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!pictureCell) {
        pictureCell = [[MWNewClothesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier
                                                         type:self.viewModel.dataSource[indexPath.row]];
    }
    
    [pictureCell configCellWithData:nil];
    
    [self.viewModel.cellHeightDic setObject:@([pictureCell getCellSize].height)
                                     forKey:[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
    
    @weakify(self, indexPath);
    pictureCell.heightChangeBlock = ^(CGSize cellSize) {
        @strongify(self, indexPath);
        [self.viewModel.cellHeightDic setObject:@(cellSize.height)
                                         forKey:[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    };
    
    return pictureCell;
}

@end
