//
//  MWDragTagView.h
//  MyWardrobe
//
//  Created by Simon Mr on 2018/12/15.
//  Copyright © 2018 Simon Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWDragTagView : UIView

/** 刷新订阅 */
@property (nonatomic, strong) RACSubject *reloadSubject;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName edit:(BOOL)canEdit tagNameArr:(NSArray *)tagNameArr;

- (void)configUI;

@end
