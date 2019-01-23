//
//  MWPhotoVC.m
//  MyWardrobe
//
//  Created by zt on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWPhotoVC.h"
#import "MWClothesPhotoCollectionViewCell.h"
#import "MWSignalClothesModel.h"
#import "MWNewClothesVC.h"
#import "MWNewClothesVM.h"
@interface MWPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@end

@implementation MWPhotoVC

- (instancetype)initWithPhotos:(NSArray *)photos withIndex:(NSInteger)index{
    if (self = [super init]) {
        if (photos.count > 0) {
            self.dataArray = [NSMutableArray arrayWithArray:photos];
        } else {
            self.dataArray = [NSMutableArray array];
        }
        
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutNavi];
    
    //添加collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"isfirst"]
        && self.dataArray.count > 1
        && self.index == 0) {
        @weakify(self);
        self.collectionView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            @strongify(self);
            [self.collectionView setContentOffset:CGPointMake(SCREEN_SIZE_WIDTH * self.index + SCREEN_SIZE_WIDTH/2.0, 0)];
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    @strongify(self);
                    [self.collectionView setContentOffset:CGPointMake(SCREEN_SIZE_WIDTH * self.index, 0) animated:YES];
                    self.collectionView.userInteractionEnabled = YES;
                    [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"isfirst"];
                }];
            }
            
        }];
    }
}

- (void)layoutNavi {
    @weakify(self);
    NSString *naviTitle = @"查看单品";
    self.navigationView = [MWNavigationView navigationWithTitle:naviTitle
                                                      popAction:^{
                                                          @strongify(self);
                                                          [self.navigationController popViewControllerAnimated:YES];                                                          
                                                      }];
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:rightButton1];
    rightButton1.mw_width = 24;
    rightButton1.mw_height = 24;
    rightButton1.mw_right = self.navigationView.mw_right - 15.f;
    rightButton1.mw_centerY = self.navigationView.navTitleLabel.mw_centerY;
    [rightButton1 setImage:[UIImage imageNamed:@"navigation_icon_delect"] forState:UIControlStateNormal];
    [rightButton1 setImage:[UIImage imageNamed:@"navigation_icon_delect"] forState:UIControlStateHighlighted];
    [[rightButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [[MWDataManager dataManager] removeSignalClothes:self.dataArray[self.index]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:rightButton2];
    rightButton2.mw_width = 24;
    rightButton2.mw_height = 24;
    rightButton2.mw_right = rightButton1.mw_left - 15.f;
    rightButton2.mw_centerY = self.navigationView.navTitleLabel.mw_centerY;
    [rightButton2 setImage:[UIImage imageNamed:@"navigation_icon_edit"] forState:UIControlStateNormal];
    [rightButton2 setImage:[UIImage imageNamed:@"navigation_icon_edit"] forState:UIControlStateHighlighted];
    [[rightButton2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        MWNewClothesVM *vm = [[MWNewClothesVM alloc] initWithData:self.dataArray[self.index]];
        MWNewClothesVC *vc = [[MWNewClothesVC alloc] initWithVM:vm];
        [self.navigationController pushViewController:vc animated:YES];
    }];

}
#pragma mark -- collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MWClothesPhotoCollectionViewCell *cell = (MWClothesPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MWClothesPhotoCollectionViewCell"
                                                                                                                           forIndexPath:indexPath];
    MWSignalClothesModel *model = self.dataArray[indexPath.row];
    [cell configWithModel:model];

    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - (NAV_BAR_HEIGHT + 28));
        flow.minimumLineSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT + 28, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT - (NAV_BAR_HEIGHT + 28)) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[MWClothesPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MWClothesPhotoCollectionViewCell"];
        
    }
    return _collectionView;
}

@end
