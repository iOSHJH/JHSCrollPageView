//
//  JHSCrollPageVC.h
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 关于UIPageViewController性能，用到的控制器才会加载
 缺陷：当快速的切换页面的时候，造成闪退
 */
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

/** 创建方式*/
- (instancetype)initWithVCs:(NSArray<UIViewController *> *)vcs titles:(NSArray<NSString *> *)titles;

- (void)selectTitleVC:(NSUInteger)integer;

@end

