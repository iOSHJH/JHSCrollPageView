//
//  JHSCrollPageVC.m
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import "JHSCrollPageVC.h"

@interface JHSCrollPageVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

/***  子控制器*/
@property (nonatomic,strong) NSArray *viewControllers;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *titleLabels;

@property (nonatomic,strong) UIPageViewController *pageVC;

@property (nonatomic, assign) CGFloat titleWidth;

@end

@implementation JHSCrollPageVC

- (instancetype)initWithVCs:(NSArray<UIViewController *> *)vcs titles:(NSArray<NSString *> *)titles {
    if (self = [super init]) {
        self.viewControllers = vcs;
        self.titles = titles;
        _titleWidth = [UIScreen mainScreen].bounds.size.width / titles.count;
        if (!self.normalTitleColor) {
            self.normalTitleColor = [UIColor redColor];
        }
        if (!self.highlightedTitleColor) {
            self.highlightedTitleColor = [UIColor blueColor];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSetup];
    [self prepareUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = self.navigationBarHide;
    //    // 2所以创建之前 要先移除self.navBarView
    //    for (UIView *view in self.navBarView.subviews) {
    //        [view removeFromSuperview];
    //    }
    //    [self.navBarView removeFromSuperview];
    //    [self.titleLabels removeAllObjects];
    
    //    // 1因为这里会调用很多次 创建很多self.navBarView
    //    [self initTitles];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)prepareUI {
    
    [self initTitles];
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    CGRect rect = self.view.frame;
    CGFloat y = CGRectGetMaxY(self.navBarView.frame);
    self.pageVC.view.frame = CGRectMake(0, y, rect.size.width, rect.size.height - y);

}

- (void)prepareSetup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initTitles {
    
    CGFloat top = self.navigationBarHide ? 0 : 64;
    
    [self.view addSubview:self.navBarView];
    CGRect rect = self.view.frame;
    self.navBarView.frame = CGRectMake(0, top, rect.size.width, 64);
    
    for (int i = 0; i < self.titles.count; ++i) {
        /*
         title label
         */
        UILabel *label = [UILabel new];
        label.text = self.titles[i];
        label.textColor = self.normalTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i + 1000;
        label.userInteractionEnabled = YES;
        
        if([label.text isEqualToString:self.selectLabel.text] || (!self.selectLabel && i == 0)) {
            self.selectLabel = label;
            label.textColor = self.highlightedTitleColor;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
        [label addGestureRecognizer:tap];
        
        [self.titleLabels addObject:label];
        [self.navBarView addSubview:label];

        // 根据字符串获得宽高
        CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
        CGFloat y = CGRectGetMaxY(self.navBarView.frame) - labelSize.height - 10 - top;
        label.frame = CGRectMake(_titleWidth * i, y, _titleWidth, labelSize.height);
    }
    
    [self.navBarView addSubview:self.slipView];

    // 根据字符串获得宽高
    CGSize selectlabelSize = [self.selectLabel.text sizeWithAttributes:@{NSFontAttributeName: self.selectLabel.font}];
    CGFloat x = _titleWidth * (self.selectLabel.tag - 1000) + (_titleWidth-selectlabelSize.width)*0.5;
    CGFloat y = CGRectGetMaxY(self.navBarView.frame) - 10 - top;
    self.slipView.frame = CGRectMake(x, y, selectlabelSize.width, 4);
}

- (void)labelTap:(UITapGestureRecognizer *)tap {
    self.selectLabel.textColor = self.normalTitleColor;
    
    UILabel *label = (UILabel *)tap.view;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.slipView.frame;
        // 根据字符串获得宽高
        CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
        CGFloat x = _titleWidth * (label.tag - 1000) + (_titleWidth-labelSize.width)*0.5;
        self.slipView.frame = CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
    }];
    label.textColor = self.highlightedTitleColor;
    
    NSArray *vcs = [NSArray arrayWithObject:self.viewControllers[label.tag - 1000]];
    [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.selectLabel = label;
}

- (void)selectTitleVC:(NSUInteger)integer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectLabel.textColor = self.normalTitleColor;
        
        UILabel *label = self.titleLabels[integer];
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.slipView.frame;
            CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
            CGFloat x = _titleWidth * integer + (_titleWidth-labelSize.width)*0.5;
            self.slipView.frame = CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
        }];
        label.textColor = self.highlightedTitleColor;
        
        NSArray *vcs = [NSArray arrayWithObject:self.viewControllers[label.tag - 1000]];
        [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.selectLabel = label;
    });
}

// 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller {
    return [self.viewControllers indexOfObject:viewControlller];
}

- (void)dealloc {
    
}

#pragma mark - UIPageViewControllerDataSource
// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return self.viewControllers[index];
}
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return self.viewControllers[index];
}

#pragma mark - UIPageViewControllerDelegate

// 开始翻页调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    self.willShowVC = pendingViewControllers.firstObject;
}

// 翻页完成调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSInteger index = [self.viewControllers indexOfObject:self.willShowVC];
        
        for (UIView *view in self.navBarView.subviews) {
            if (view.tag == 1000+index) {
                UILabel *label = [view viewWithTag:view.tag];
                label.textColor = self.highlightedTitleColor;
                self.selectLabel = label;
                
                [UIView animateWithDuration:0.25 animations:^{
                    CGRect rect = self.slipView.frame;
                    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
                    CGFloat x = _titleWidth * index + (_titleWidth-labelSize.width)*0.5;
                    self.slipView.frame = CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
                }];
            }else {
                if ([[view viewWithTag:view.tag] isKindOfClass:[UILabel class]]) {
                    UILabel *label = [view viewWithTag:view.tag];
                    label.textColor = self.normalTitleColor;
                }
            }
        }
    }
}


#pragma mark - lazy load

- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        /*
         UIPageViewControllerSpineLocationNone = 0, // 默认UIPageViewControllerSpineLocationMin
         UIPageViewControllerSpineLocationMin = 1,  // 书棱在左边
         UIPageViewControllerSpineLocationMid = 2,  // 书棱在中间，同时显示两页
         UIPageViewControllerSpineLocationMax = 3   // 书棱在右边
         */
        // 设置UIPageViewController的配置项
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        /*
         UIPageViewControllerNavigationOrientationHorizontal = 0, 水平翻页
         UIPageViewControllerNavigationOrientationVertical = 1    垂直翻页
         */
        /*
         UIPageViewControllerTransitionStylePageCurl = 0, // 书本效果
         UIPageViewControllerTransitionStyleScroll = 1 // Scroll效果
         */
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
        // 定义“这本书”的尺寸
        //        _pageVC.view.frame = CGRectMake(0, navBar, ScreenWidth, ScreenHeight-navBar);
        //        _pageVC.view.frame = CGRectMake(0, 100, ScreenWidth, 500);
        //        _pageVC.view.frame = self.view.bounds;
        
        // 要显示的第几页
        NSArray *vcs = [NSArray arrayWithObject:self.viewControllers.firstObject];
        
        // 如果要同时显示两页，options参数要设置为UIPageViewControllerSpineLocationMid
        //        NSArray *vcs = [NSArray arrayWithObjects:self.viewControllers[0], self.viewControllers[1], nil];
        
        self.willShowVC = self.viewControllers.firstObject;
        [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageVC;
}

- (UIView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[UIView alloc] init];
        _navBarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _navBarView;
}

- (UIView *)slipView {
    if (!_slipView) {
        _slipView = [UIView new];
        _slipView.backgroundColor = [UIColor redColor];
        _slipView.layer.cornerRadius = 3;
    }
    return _slipView;
}

- (NSMutableArray *)titleLabels {
    if (_titleLabels) {
        return _titleLabels;
    }
    _titleLabels = [NSMutableArray array];
    
    return _titleLabels;
}

#pragma mark - set



@end

