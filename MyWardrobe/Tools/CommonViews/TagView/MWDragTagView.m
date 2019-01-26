//
//  MWDragTagView.m
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWDragTagView.h"

#pragma mark - utils
#import "MWEqualSpaceFlowLayout.h"

#pragma mark - views
#import "MWDragTagCell.h"
#import "MWAlertView.h"
#import "MBProgressHUD+SimpleLoad.h"

static NSString *identity = @"identity";
static NSString *lastItemidentity = @"lastItem";

@interface MWDragTagView () <UICollectionViewDelegate, UICollectionViewDataSource, MWEqualSpaceFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *tagNameArr;
@property (nonatomic, strong) MWEqualSpaceFlowLayout *layout;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, assign) BOOL canEdit;
/** 外部传来的size */
@property (nonatomic, assign) CGSize outSize;

@property (nonatomic, copy) NSString *bgImageName;

@end

@implementation MWDragTagView

- (void)reloadDataWithTagNameArr:(NSArray *)tagNameArr {
    self.tagNameArr = [tagNameArr mutableCopy];
    [self reloadCollectionView];
}

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName edit:(BOOL)canEdit tagNameArr:(NSArray *)tagNameArr {
    self = [super initWithFrame:frame];
    if (self) {
        _reloadSubject = [RACSubject subject];
        _bgImageName = imageName.copy;
        _canEdit = canEdit;
        _tagNameArr = [tagNameArr mutableCopy];
        _outSize = frame.size;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.layout = [[MWEqualSpaceFlowLayout alloc] init];
    self.layout.delegate = self;
    // 设置滚动方向（默认垂直滚动）
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.outSize.width, 20) collectionViewLayout:self.layout];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[MWDragTagCell class] forCellWithReuseIdentifier:identity];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:lastItemidentity];
    collectionView.pagingEnabled = YES;
    
    if (self.canEdit) {
        //1.CollectionView 添加长按手势
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longHandle:)];
        [collectionView addGestureRecognizer:longTap];
    }
    
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.tagNameArr.count) {
        return CGSizeMake(40.f, 26.f);
    }
    
    NSString *tagName = self.tagNameArr[indexPath.row];
    CGFloat width = [self getWidthWithText:tagName height:24.f font:[UIFont fontWithName:REGULAR_FONT size:17.f]];
    return CGSizeMake(width + 25, 26.f);
}

- (void)longHandle:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
            // cell.layer添加抖动手势
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
                [self starShake:cell];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            [self.collectionView endInteractiveMovement];
            //cell.layer移除抖动手势
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
                [self stopShake:cell];
            }
            break;
        }
            
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.canEdit) {
        return self.tagNameArr.count;
    }
    return self.tagNameArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.tagNameArr.count) {
        // 最后一个
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lastItemidentity
                                                                               forIndexPath:indexPath];
        
        [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
        }];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = CGRectMake(0, 0, 40, 26.f);
        self.addButton.layer.borderWidth = 0.5;
        self.addButton.layer.borderColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.2].CGColor;
        [self.addButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [cell.contentView addSubview:self.addButton];
        
        @weakify(self);
        [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             @strongify(self);
             [[[MWAlertView alloc] initWithTitle:@"添加标签"
                                       inputText:@""
                                   confirmString:@"更新"
                                    cancelString:@"取消"
                                     confirBlock:^(NSString *inputString) {
                                         @strongify(self);
                                         if (inputString.length > 0) {
                                             if ([self.tagNameArr containsObject:inputString]) {
                                                 [MBProgressHUD showLoadingWithTitle:@"标签已存在"];
                                                 return;
                                             }
                                             
                                             [self.tagNameArr addObject:inputString];
                                             [self reloadCollectionView];
                                             
                                             if (self.addBlock) {
                                                 self.addBlock(inputString);
                                             }
                                         }
                                     } cancelBlock:^{}] showAlert];
         }];
        
        return cell;
    } else {
        MWDragTagCell *cell = (MWDragTagCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identity
                                                                                         forIndexPath:indexPath];
        cell.tagTextColor = self.tagTextColor;
        
        CGFloat cellWidth = [self getWidthWithText:self.tagNameArr[indexPath.row]
                                           height:24.f
                                             font:[UIFont fontWithName:REGULAR_FONT size:17.f]] + 25;
        
        [cell setTagName:self.tagNameArr[indexPath.row] cellWidth:cellWidth];
        [cell setImageName:self.bgImageName cellWidth:cellWidth];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.mw_height = self.layout.collectionViewContentSize.height;
    self.collectionView.mw_height = self.mw_height;
    [self.reloadSubject sendNext:@(self.layout.collectionViewContentSize.height)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.tagNameArr.count) {
        return;
    }
    NSString *tagName = self.tagNameArr[indexPath.row];
    @weakify(self, tagName);
    [[[MWAlertView alloc] initWithTitle:@"编辑标签"
                              inputText:tagName
                          confirmString:@"更新"
                           cancelString:@"删除"
                            confirBlock:^(NSString *inputString) {
                                @strongify(self, tagName);
                                if (inputString.length > 0) {
                                    if ([tagName isEqualToString:@"未分类"]) {
                                        [MBProgressHUD showLoadingWithTitle:@"该标签不能更改哦~"];
                                        return;
                                    }
                                    
                                    if ([self.tagNameArr containsObject:inputString]) {
                                        [MBProgressHUD showLoadingWithTitle:@"标签已存在"];
                                        return;
                                    }
                                    
                                    [self.tagNameArr replaceObjectAtIndex:indexPath.row withObject:inputString];
                                    [self reloadCollectionView];
                                    
                                    if (self.updateBlock) {
                                        self.updateBlock(tagName, inputString);
                                    }
                                }
                            } cancelBlock:^{
                                @strongify(self, tagName);
                                if ([tagName isEqualToString:@"未分类"]) {
                                    [MBProgressHUD showLoadingWithTitle:@"该标签不能删除哦~"];
                                    return;
                                }
                                
                                [self.tagNameArr removeObject:tagName];
                                [self reloadCollectionView];
                                
                                if (self.deleteBlock) {
                                    self.deleteBlock(tagName);
                                }
                            }] showAlert];
}

// 3.设置可移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.tagNameArr.count) {
        return NO;
    }
    return YES;
}

// 4.移动完成后的方法  －－ 交换数据
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.tagNameArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

// 抖动
- (void)starShake:(UICollectionViewCell *)cell{
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-3 / 180.0 * M_PI),@(3 /180.0 * M_PI),@(-3/ 180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = MAXFLOAT;
    [cell.layer addAnimation:keyAnimaion forKey:@"cellShake"];
}

- (void)stopShake:(UICollectionViewCell *)cell{
    [cell.layer removeAnimationForKey:@"cellShake"];
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text
                     height:(CGFloat)height
                       font:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    return rect.size.width;
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
    
    self.mw_height = self.layout.collectionViewContentSize.height;
    
    [self.reloadSubject sendNext:@(self.layout.collectionViewContentSize.height)];
}

@end
