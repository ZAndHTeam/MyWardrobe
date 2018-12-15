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
#import "MBProgressHUD.h"

@interface MWNewClothesVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MWNewClothesVM *viewModel;

@end

@implementation MWNewClothesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewModel = [[MWNewClothesVM alloc] initWithData:nil];
    
    // navi
    [self layoutNavi];
    // 主view
    [self layoutTableView];
    // 加入按钮
    [self layoutAddButton];
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

- (void)layoutAddButton {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 190.f, 44.f);
    [addButton setTitle:@"放入衣橱" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont fontWithName:MEDIUM_FONT size:20.f];
    addButton.mw_centerX = self.view.mw_centerX;
    addButton.mw_bottom = self.view.mw_bottom - HOME_INDICATOR_HEIGHT - 44.f;
    addButton.backgroundColor = [UIColor colorWithHexString:@"#FF4141"];
    
    // 阴影 && 圆角
    addButton.layer.cornerRadius = 24.f;
    addButton.layer.shadowColor = [[UIColor colorWithHexString:@"#FF4141"] colorWithAlphaComponent:0.33].CGColor;
    addButton.layer.shadowOffset = CGSizeMake(0,2);
    addButton.layer.shadowOpacity = 1.f;
    addButton.layer.shadowRadius = 8.f;
    
    @weakify(self);
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.viewModel.signalClothesModel.imageDataArr.count == 0) {
             MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             hud.mode = MBProgressHUDModeAnnularDeterminate;
             hud.label.text = @"忘记拍照了呦，只有先拍照才能放入衣橱里~";
             
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 // Do something...
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             });
             return;
         }
     }];
    
    [self.view addSubview:addButton];
    [self.view bringSubviewToFront:addButton];
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
    
    [pictureCell configCellWithData:self.viewModel];
    
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
