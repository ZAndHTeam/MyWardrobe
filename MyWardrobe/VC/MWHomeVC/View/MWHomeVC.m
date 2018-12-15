//
//  MWHomeVC.m
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWHomeVC.h"
#import "MWHomeTableViewCell.h"
#import "MWHomeVM.h"
@interface MWHomeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;//本页面的主view
@property (nonatomic,strong) UILabel *headerLabel;//所有单品的label;
@property (nonatomic, strong) MWHomeVM *viewModel;


@end

@implementation MWHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self crateHeaderView];//所有单品
    //创建tableView
    [self createTableView];
    //获取数据源
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)getData {
    self.viewModel = [[MWHomeVM alloc]init];
    [self.tableView reloadData];
}

#pragma mark -- 创建UI
- (void)createTableView {
    [self.view addSubview:self.tableView];
}

- (void)crateHeaderView {
    UILabel *headerLabelName = [[UILabel alloc]initWithFrame:CGRectMake(15, NAV_BAR_HEIGHT - 64 + 19, 82, 28)];
    [self.view addSubview:headerLabelName];
    headerLabelName.textColor = [UIColor colorWithHexString:@"#333333"];
    headerLabelName.font = [UIFont fontWithName:MEDIUM_FONT size:20];
    headerLabelName.text = @"所有单品";

    self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerLabelName.frame) + 2, CGRectGetMaxY(headerLabelName.frame) - 19, SCREEN_SIZE_WIDTH - CGRectGetMaxX(headerLabelName.frame) - 15, 17)];
    [self.view addSubview:self.headerLabel];
    self.headerLabel.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4];
    self.headerLabel.font = [UIFont fontWithName:LIGHT_FONT size:12];
    self.headerLabel.text = @"0/5";
    
}

#pragma mark -- tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MWHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWHomeTableViewCell"];
    if (!cell) {
        cell = [[MWHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MWHomeTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.viewModel returnClothesArrWithCatogaryName:self.viewModel.titleArr[indexPath.section]].count == 0) {
        cell.isZero = YES;
    }else {
        cell.isZero = NO;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *string = [NSString stringWithFormat:@"%@ %lu",self.viewModel.titleArr[section],(unsigned long)[self.viewModel returnClothesArrWithCatogaryName:self.viewModel.titleArr[section]].count];
    NSArray *strArr = [string componentsSeparatedByString:@" "];
    UIView *view = [UIView new];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, SCREEN_SIZE_WIDTH - 30, 24)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:MEDIUM_FONT size:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:LIGHT_FONT size:12],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4]} range:NSMakeRange([NSString stringWithFormat:@"%@",strArr.firstObject].length, string.length - [NSString stringWithFormat:@"%@",strArr.firstObject].length)];
    headerLabel.attributedText = attributedStr;
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel returnClothesArrWithCatogaryName:self.viewModel.titleArr[indexPath.section]].count == 0) {
        return 40;
    }
    return 120;
}

#pragma mark -- 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 2;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
