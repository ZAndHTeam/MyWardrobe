//
//  MWSettingVC.m
//  MyWardrobe
//
//  Created by zt on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWSettingVC.h"

#pragma mark - views
#import "MWDragTagView.h"
#import "MWExpandCell.h"

#pragma mark - utils
#import "UITextView+MWPlaceholder.h"
#import "MBProgressHUD+SimpleLoad.h"
#import "MWDataManager.h"

static NSString * const kSettingCatogary = @"setting_catogary";
static NSString * const kSettingBrand = @"setting_brand";

@interface MWSettingVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

// 设置二字
@property (nonatomic,strong) UILabel *headerLabel;
// 主view
@property (nonatomic,strong) UITableView *tableView;
// 数据源
@property (nonatomic,strong) NSMutableArray *dataArray;
// 发送button
@property (nonatomic,strong) UIButton *postBtn;
// 分类展开高度
@property (nonatomic, assign) CGFloat catogaryHeight;
// 品牌展开高度
@property (nonatomic, assign) CGFloat brandHeight;

@end

@implementation MWSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"分类", @"品牌", nil],
                      [NSMutableArray arrayWithObjects:@"分类", @"品牌", nil],
                      nil];
    [self crateHeaderView];//设置
    //创建tableView
    [self createTableView];

}

#pragma mark -- 创建UI
- (void)createTableView {
    [self.view addSubview:self.tableView];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 194)];
    
    //反馈label
    UILabel *feedBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_SIZE_WIDTH, 20)];
    feedBackLabel.text = @"反馈";
    feedBackLabel.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4];
    feedBackLabel.font = [UIFont fontWithName:LIGHT_FONT size:14];
    [footView addSubview:feedBackLabel];
    
    //textView
    UITextView *feedBackView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(feedBackLabel.frame) + 20, SCREEN_SIZE_WIDTH - 30, 100)];
    feedBackView.font = [UIFont systemFontOfSize:17];
    feedBackView.delegate = self;
    [feedBackView setPlaceholder:@"想要私人定制APP？快来点击输入意见建议" placeholdColor:[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4]];
    [footView addSubview:feedBackView];
    
    //发送button
    self.postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedBackView addSubview:self.postBtn];
    [self.postBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.postBtn.backgroundColor = [UIColor colorWithHexString:@"#FF4141"];
    self.postBtn.frame = CGRectMake(0, CGRectGetMaxY(feedBackView.frame) + 10, 190, 44);
    CGPoint centerPost = self.postBtn.center;
    centerPost.x = SCREEN_SIZE_WIDTH/2.0;
    self.postBtn.center = centerPost;
    self.postBtn.layer.cornerRadius = 22;
    self.postBtn.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:65/255.0 blue:65/255.0 alpha:0.33].CGColor;
    self.postBtn.layer.shadowOffset = CGSizeMake(0,2);
    self.postBtn.layer.shadowOpacity = 1;
    @weakify(self, feedBackView);
    [[self.postBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self, feedBackView);
         self.postBtn.hidden = YES;
         feedBackView.text = nil;
         [self.view endEditing:YES];
         
         [MBProgressHUD showLoadingWithTitle:@"感谢您的反馈哦，祝您生活愉快~"];
     }];
    [footView addSubview:self.postBtn];

    self.postBtn.hidden = YES;
    self.tableView.tableFooterView = footView;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.postBtn.hidden = NO;
    }else {
        self.postBtn.hidden = YES;
    }
}

- (void)crateHeaderView {
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, NAV_BAR_HEIGHT - 24.f, 82, 28)];
    [self.view addSubview:self.headerLabel];
    self.headerLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.headerLabel.font = [UIFont fontWithName:MEDIUM_FONT size:20];
    self.headerLabel.text = @"设置";
}

#pragma mark -- tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MWExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[MWExpandCell alloc] initWithStyle:UITableViewCellStyleValue1
                                   reuseIdentifier:@"UITableViewCell"];
    } else {
        [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MWDragTagView class]]) [obj removeFromSuperview];
        }];
    }
    
    NSArray *array = self.dataArray[indexPath.section];
    
    if ([array[indexPath.row] isEqualToString:kSettingCatogary]) {
        MWDragTagView *tagView = [[MWDragTagView alloc] initWithFrame:CGRectMake(15.f, 5.f, SCREEN_SIZE_WIDTH - 30.f, 24.f)
                                                            imageName:@"tag_normal"
                                                                 edit:NO
                                                           tagNameArr:[MWDataManager dataManager].catogaryNameArr];
        tagView.tagTextColor = [UIColor blackColor];
        @weakify(self, tagView);
        [tagView.reloadSubject
         subscribeNext:^(NSNumber *height) {
             @strongify(self, tagView);
             tagView.mw_height = [height integerValue];
             self.catogaryHeight = tagView.mw_height + 5;
             
             [self.tableView beginUpdates];
             [self.tableView endUpdates];
         }];
        
        tagView.addBlock = ^(NSString *tagName) {
            [[MWDataManager dataManager] addNewCatory:tagName];
        };
        tagView.updateBlock = ^(NSString *oldTagName, NSString *newTagName) {
            [[MWDataManager dataManager] updateOldCatory:oldTagName toNewCatory:newTagName];
        };
        tagView.deleteBlock = ^(NSString *tagName) {
            [[MWDataManager dataManager] removeCatogary:tagName];
        };
        
        [cell addSubview:tagView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if ([array[indexPath.row] isEqualToString:kSettingBrand]) {
        MWDragTagView *tagView = [[MWDragTagView alloc] initWithFrame:CGRectMake(15.f, 5.f, SCREEN_SIZE_WIDTH - 30.f, 24.f)
                                                            imageName:@"tag_normal"
                                                                 edit:NO
                                                           tagNameArr:[MWDataManager dataManager].brandArr];
        tagView.tagTextColor = [UIColor blackColor];
        @weakify(self, tagView);
        [tagView.reloadSubject
         subscribeNext:^(NSNumber *height) {
             @strongify(self, tagView);
             tagView.mw_height = [height integerValue];
             self.brandHeight = tagView.mw_height + 5;
             
             [self.tableView beginUpdates];
             [self.tableView endUpdates];
         }];
        
        tagView.addBlock = ^(NSString *tagName) {
            [[MWDataManager dataManager] addNewBrand:tagName];
        };
        tagView.updateBlock = ^(NSString *oldTagName, NSString *newTagName) {
            [[MWDataManager dataManager] updateOldBrand:oldTagName toNewBrand:newTagName];
        };
        tagView.deleteBlock = ^(NSString *tagName) {
            [[MWDataManager dataManager] removeBrand:tagName];
        };
        
        [cell addSubview:tagView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:MEDIUM_FONT size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:LIGHT_FONT size:14];
    cell.detailTextLabel.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4];
    
    if (indexPath.section == 0) {
        [cell setCustomAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.detailTextLabel.text = @"";
    } else {
        [cell setCustomAccessoryType:UITableViewCellAccessoryNone];
        if (indexPath.row == 0) {
            // 数量
            cell.detailTextLabel.text = [NSString stringWithFormat:@"共计 %ld 件", (long)[MWDataManager dataManager].returnAllClothesNumber];
        }else {
            // 价钱
            cell.detailTextLabel.text = [NSString stringWithFormat:@"共计 %@ 元", [MWDataManager dataManager].returnTotalPrice];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, SCREEN_SIZE_WIDTH - 30, 24)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        headerLabel.text = @"管理标签";
    }else {
        headerLabel.text = @"单品统计";
    }
    headerLabel.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.4];
    headerLabel.font = [UIFont fontWithName:LIGHT_FONT size:14];
    [view addSubview:headerLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.dataArray[indexPath.section];
    
    if ([array[indexPath.row] isEqualToString:kSettingCatogary]) {
        return self.catogaryHeight;
    } else if ([array[indexPath.row] isEqualToString:kSettingBrand]) {
        return self.brandHeight;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = self.dataArray[indexPath.section];
    
    MWExpandCell *cell = (MWExpandCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isExpand = !cell.isExpand;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // catory
            [array containsObject:kSettingCatogary] ? [array removeObject:kSettingCatogary] : [array insertObject:kSettingCatogary atIndex:1];
            
            [self.dataArray replaceObjectAtIndex:0 withObject:array];
            
            if ([array containsObject:kSettingCatogary]) {
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:NO];
            } else {
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:NO];
            }
        } else {
            // brand
            if ([array containsObject:kSettingCatogary]) {
                if (indexPath.row == 2) {
                    [array containsObject:kSettingBrand] ? [array removeObject:kSettingBrand] : [array insertObject:kSettingBrand atIndex:3];
                    [self.dataArray replaceObjectAtIndex:0 withObject:array];
                    
                    if ([array containsObject:kSettingBrand]) {
                        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:NO];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:NO];
                    }
                }
            } else {
                if (indexPath.row == 1) {
                    [array containsObject:kSettingBrand] ? [array removeObject:kSettingBrand] : [array insertObject:kSettingBrand atIndex:2];
                    [self.dataArray replaceObjectAtIndex:0 withObject:array];
                    
                    if ([array containsObject:kSettingBrand]) { 
                        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:NO];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:NO];
                    }
                }
            }
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerLabel.frame), SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 2;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
