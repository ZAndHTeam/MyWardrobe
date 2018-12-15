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
#import "MBProgressHUD+SimpleLoad.h"
#import <AVFoundation/AVFoundation.h>
#import "MWAlertView.h"

@interface MWNewClothesVC () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
    NSString *naviTitle = (self.viewModel.viewType == MWNewClothesVMType_New) ? @"添加单品" : @"编辑单品";
    self.navigationView = [MWNavigationView navigationWithTitle:naviTitle
                                                      popAction:^{
                                                          @strongify(self);
                                                          if (self.viewModel.viewType == MWNewClothesVMType_New) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          } else {
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          }
                                                          
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
    
    // 加入衣橱操作
    @weakify(self);
    [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [self addOneClothes];
     }];
    
    [self.view addSubview:addButton];
    [self.view bringSubviewToFront:addButton];
}

#pragma mark - 加入衣橱
- (void)addOneClothes {
    if (self.viewModel.signalClothesModel.imageDataArr.count == 0) {
        [MBProgressHUD showLoadingWithTitle:@"需要先拍照，才能放入衣橱哦~"];
        return;
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showLoadingWithTitle:[self.viewModel saveClothes]];
        }];
    }
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
                                                         type:self.viewModel.dataSource[indexPath.row]
                                                         data:self.viewModel];
    }
    
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
    
    pictureCell.takePictureBlock = ^{
        @strongify(self);
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *pickAction = [UIAlertAction actionWithTitle:@"从相册添加"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self configAlbumSession];
                                                           }];
        
        UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"拍照"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self configCameraSession];
                                                           }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        [cancelAction setValue:[UIColor colorWithHexString:@"#FF4141"] forKey:@"_titleTextColor"];
        
        [actionSheetController addAction:pickAction];
        [actionSheetController addAction:takeAction];
        [actionSheetController addAction:cancelAction];
        
        [self presentViewController:actionSheetController animated:YES completion:nil];
    };
    
    return pictureCell;
}

// 相册
- (void)configAlbumSession {
    // 首先查看当前设备是否支持相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentToImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    } else {
        [MBProgressHUD showLoadingWithTitle:@"当前设备不支持相册"];
    }
}


- (void)presentToImagePickerController:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    [self.viewModel savePicture:UIImageJPEGRepresentation(image , 0.1)];
}

// 相机
- (void)configCameraSession {
    @weakify(self);
    // 读取媒体类型
    NSString *mediaType = AVMediaTypeVideo;
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(![self isRearCameraAvailable]) {
        NSString *errorStr = @"设备摄像头不可用";
        [[[MWAlertView alloc] initWithTitle:errorStr
                              confirmString:@"确定"
                               cancelString:@"取消"
                                confirBlock:^(NSString *inputString) {}
                                cancelBlock:^{}] showAlert];
        return;
    } else if(authStatus == AVAuthorizationStatusRestricted
              || authStatus == AVAuthorizationStatusDenied) {
        NSString *errorStr = @"请在设备的\"设置-隐私-相机\"中允许访问相机。";
        
        [[[MWAlertView alloc] initWithTitle:errorStr
                              confirmString:@"确定"
                               cancelString:@"取消"
                                confirBlock:^(NSString *inputString) {
                                    
                                } cancelBlock:^{}] showAlert];
        
        return;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // 以"弹窗要求用户选择是否授权"为例
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            [[RACScheduler mainThreadScheduler] schedule:^{
                @strongify(self);
                if (granted) {
                    // 授权使用
                    [self configInputOutput];
                } else {
                   [MBProgressHUD showLoadingWithTitle:@"已取消"];
                }
            }];
        }];
        return;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self configInputOutput];
    } else {
        // 用户禁止使用
        [MBProgressHUD showLoadingWithTitle:@"已取消"];
    }
}

// 后摄像头是否可用
- (BOOL) isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (void)configInputOutput {
    [self presentToImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

@end
