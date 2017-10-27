//
//  JHSCrollPageVC.h
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSCrollPageVC : UIViewController

/** titles view*/
@property (nonatomic,strong) UIView *navBarView;
/***  滑动条*/
@property (nonatomic,strong) UIView *slipView;
/** titles 默认字体颜色*/
@property (nonatomic, strong) UIColor *normalTitleColor;
/** titles 高亮字体颜色*/
@property (nonatomic, strong) UIColor *highlightedTitleColor;
/***  记录选中的label*/
@property (nonatomic,strong) UILabel *selectLabel;
/** 记住选中的title index*/
@property (nonatomic, assign) NSInteger selectIndex;
/***  将要显示的子控制器*/
@property (nonatomic,strong) UIViewController *willShowVC;
/** 隐藏显示导航条*/
@property (nonatomic, assign) BOOL navigationBarHide;

/** 创建方式*/
- (instancetype)initWithVCs:(NSArray<UIViewController *> *)vcs titles:(NSArray<NSString *> *)titles;

- (void)selectTitleVC:(NSUInteger)integer;

@end
