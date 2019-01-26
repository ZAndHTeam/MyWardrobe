//
//  MWClothesPhotoCollectionViewCell.m
//  MyWardrobe
//
//  Created by zt on 2018/12/16.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import "MWClothesPhotoCollectionViewCell.h"
#import "MWSignalClothesModel.h"
#import "MWDragTagView.h"

@interface MWClothesPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *bigScrollV;
@property (nonatomic, strong) MWDragTagView *tagView;
@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) MWSignalClothesModel *cellModel;

@end

@implementation MWClothesPhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.bigScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, self.frame.size.height)];
    [self.contentView addSubview:self.bigScrollV];
    self.bigScrollV.bounces = NO;
    self.bigScrollV.showsVerticalScrollIndicator = NO;
    
    // 照片
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(15, 0, SCREEN_SIZE_WIDTH - 30, (SCREEN_SIZE_WIDTH - 30)/345.0 * 460.0);
    [self.bigScrollV addSubview:self.imageView];
    
    // 标签
    self.tagView = [[MWDragTagView alloc] initWithFrame:CGRectMake(15, self.imageView.mw_bottom + 20, SCREEN_SIZE_WIDTH - 30, 26)
                                              imageName:@"tag_highlighted"
                                                   edit:NO
                                             tagNameArr:@[]];
    self.tagView.tagTextColor = [UIColor whiteColor];
    
    @weakify(self);
    [self.tagView.reloadSubject
     subscribeNext:^(NSNumber *height) {
         @strongify(self);
         self.tagView.mw_height = [height integerValue];
         self.msgLabel.frame = CGRectMake(15, self.tagView.mw_bottom + 15.f, SCREEN_SIZE_WIDTH - 30, 20);
         self.bigScrollV.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, self.msgLabel.mw_bottom + HOME_INDICATOR_HEIGHT + 40.f);
     }];
    [self.bigScrollV addSubview:self.tagView];
    
    //注意事项
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.tagView.mw_bottom + 15.f, SCREEN_SIZE_WIDTH - 30.f, 20.f)];
    [self.bigScrollV addSubview:self.msgLabel];
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.msgLabel.font = [UIFont systemFontOfSize:17];
}

#pragma mark - 数据处理
- (void)configWithModel:(MWSignalClothesModel *)model {
    _cellModel = model;
    
    [self setImageWithData:model.imageDataArr[0]];
    self.msgLabel.text = model.mark;
    [self.msgLabel sizeToFit];
    self.bigScrollV.contentSize = CGSizeMake(SCREEN_SIZE_WIDTH, self.msgLabel.mw_bottom + HOME_INDICATOR_HEIGHT + 40.f);
    
    //标签
    NSMutableArray *tagArr = [NSMutableArray array];
    if (self.cellModel.catogaryName.length > 0) [tagArr addObject:self.cellModel.catogaryName];
    if (self.cellModel.brand.length > 0) [tagArr addObject:self.cellModel.brand];
    if (self.cellModel.seasonArr.count > 0) [tagArr addObjectsFromArray:self.cellModel.seasonArr];
    if (self.cellModel.color.length > 0) [tagArr addObject:self.cellModel.color];
    [self.tagView reloadDataWithTagNameArr:tagArr.copy];
}

#pragma mark - 图片处理
// 无滤镜
- (void)setImageWithData:(NSData *)data {
    //导入CIImage
    CIImage *ciImage = [[CIImage alloc] initWithData:data];
    
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    self.imageView.image = showImage;
    CGImageRelease(cgImage);
}

// 滤镜
- (void)setFilterWithImage:(NSData *)data {
    NSArray* filters =  [CIFilter filterNamesInCategory:kCICategoryDistortionEffect];
    NSLog(@"总共有%ld种滤镜效果:%@",filters.count,filters);
    for (NSString* filterName in filters) {
        NSLog(@"filter name:%@",filterName);
        // 我们可以通过filterName创建对应的滤镜对象
        CIFilter* filter = [CIFilter filterWithName:filterName];
        NSDictionary* attributes = [filter attributes];
        // 获取属性键/值对（在这个字典中我们可以看到滤镜的属性以及对应的key）
        NSLog(@"filter attributes:%@",attributes);
    }
    //导入CIImage
    CIImage *ciImage = [[CIImage alloc] initWithData:data];
    //创建出Filter滤镜
    CIFilter *fliter = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:kCIInputImageKey,ciImage, nil];
    [fliter setDefaults];
    
    CIImage *outImage = [fliter outputImage];
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    self.imageView.image = showImage;
    CGImageRelease(cgImage);
}

@end
