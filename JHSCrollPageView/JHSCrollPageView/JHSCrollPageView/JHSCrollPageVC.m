//
//  JHSCrollPageVC.m
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import "JHSCrollPageVC.h"

// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND3
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
// 这个头文件一定要放在上面两个宏的后面
#import "Masonry.h"

// 状态栏+导航栏：非x：64
#define Height_NavBar (([UIScreen mainScreen].bounds.size.height > 800) ? 88 : 64)

@interface JHSCrollPageVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextField *textField;
/***  子控制器*/
@property (nonatomic,strong) NSArray *viewControllers;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *titleLabels;

@property (nonatomic,strong) UIPageViewController *pageVC;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleConView;

@property (nonatomic, assign) CGFloat conViewWidth;


@end

CGFloat navBarViewHeight = 100;
/// title间距
CGFloat titleJianju = 20;

@implementation JHSCrollPageVC

- (instancetype)initWithVCs:(NSArray<UIViewController *> *)vcs titles:(NSArray<NSString *> *)titles {
    if (self = [super init]) {
        self.viewControllers = vcs;
        self.titles = titles;
        if (!self.normalTitleColor) {
            self.normalTitleColor = UIColor.blackColor;
        }
        if (!self.highlightedTitleColor) {
            self.highlightedTitleColor = UIColor.brownColor;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查询记录";
    [self prepareSetup];
    [self prepareUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)prepareUI {
    
    [self initTitles];
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navBarView.mas_bottom);
    }];
}

- (void)prepareSetup {
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initTitles {
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Height_NavBar);
        make.left.right.equalTo(self.view);
        make.height.equalTo(navBarViewHeight);
    }];
    
    [self.navBarView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(8);
        make.height.equalTo(40);
    }];
    
    [self.navBarView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navBarView);
        make.top.equalTo(self.textField.mas_bottom).offset(8);
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    /* 计算titleConView的宽度，相当于scrollView的self.scrollView.contentSize.width */
    for (int i = 0; i < self.titles.count; ++i) {
        UILabel *label = [UILabel new];
        label.text = self.titles[i];
        label.font = font;
        CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
        self.conViewWidth = self.conViewWidth + labelSize.width + titleJianju;
    }
    self.conViewWidth += titleJianju;
    
    [self.scrollView addSubview:self.titleConView];
    [self.titleConView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.conViewWidth < self.view.frame.size.width) {
            CGFloat left = (self.view.frame.size.width - self.conViewWidth) * 0.5;
            make.left.equalTo(self.scrollView).offset(left);
        }else {
            make.left.equalTo(self.scrollView);
        }
        make.right.top.bottom.equalTo(self.scrollView);
        make.centerY.equalTo(self.scrollView);
        make.width.equalTo(self.conViewWidth);
    }];
    
    UILabel *pastLabel = nil;
    for (int i = 0; i < self.titles.count; ++i) {
        /*
         title label
         */
        UILabel *label = [UILabel new];
        label.text = self.titles[i];
        label.textColor = self.normalTitleColor;
        label.font = font;
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
        [self.titleConView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (pastLabel) {
                make.left.equalTo(pastLabel.mas_right).offset(titleJianju);
            }else {
                make.left.equalTo(titleJianju);
            }
            make.top.equalTo(10);
        }];
        if (i == 0) {
            [self.titleConView addSubview:self.slipView];
            [self.slipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(label);
                make.bottom.equalTo(label).offset(10);
                make.height.equalTo(2);
            }];
        }
        pastLabel = label;
    }
}

- (void)labelTap:(UITapGestureRecognizer *)tap {
    self.selectLabel.textColor = self.normalTitleColor;
    
    UILabel *label = (UILabel *)tap.view;
    [self moveSlipView:label];
    label.textColor = self.highlightedTitleColor;
    
    NSArray *vcs = [NSArray arrayWithObject:self.viewControllers[label.tag - 1000]];
    [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.selectLabel = label;
    
    [self moveScrollView:label];
}

/// 移动scrollView的offset.X值
- (void)moveScrollView:(UILabel *)label {
    if (self.conViewWidth < self.view.frame.size.width) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat offsetX = CGRectGetMaxX(label.frame) - self.view.frame.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        CGFloat maxOffsetX = CGRectGetMaxX(self.titleConView.frame) - self.view.frame.size.width;
        if (offsetX > maxOffsetX ) {
            offsetX = maxOffsetX;
        }
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    }];
}

/// 移动下划线的位置
- (void)moveSlipView:(UILabel *)label {
    [self.slipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(label);
        make.bottom.equalTo(label).offset(10);
        make.height.equalTo(2);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)selectTitleVC:(NSUInteger)integer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectLabel.textColor = self.normalTitleColor;
        
        UILabel *label = self.titleLabels[integer];
        [self moveSlipView:label];
        label.textColor = self.highlightedTitleColor;
        
        NSArray *vcs = [NSArray arrayWithObject:self.viewControllers[label.tag - 1000]];
        [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.selectLabel = label;
        
        [self moveScrollView:label];
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
        
        for (UIView *view in self.titleConView.subviews) {
            if (view.tag == 1000+index) {
                UILabel *label = [view viewWithTag:view.tag];
                label.textColor = self.highlightedTitleColor;
                self.selectLabel = label;
                //                [self.slipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                //                    make.left.right.equalTo(label);
                //                    make.bottom.equalTo(label).offset(10);
                //                    make.height.equalTo(2);
                //                }];
                //                [UIView animateWithDuration:0.25 animations:^{
                //                    [self.view layoutIfNeeded];
                //                }];
                [self moveSlipView:label];
                
                [self moveScrollView:label];
            }else {
                if ([[view viewWithTag:view.tag] isKindOfClass:[UILabel class]]) {
                    UILabel *label = [view viewWithTag:view.tag];
                    label.textColor = self.normalTitleColor;
                }
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        NSLog(@"offsetX = %f",scrollView.contentOffset.x);
}


#pragma mark - lazy load

- (UITextField *)textField {
    if (_textField) return _textField;
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @" 搜索手机号/客户姓名";
    _textField.backgroundColor = UIColor.groupTableViewBackgroundColor;
    _textField.layer.cornerRadius = 4;
    _textField.layer.masksToBounds = YES;
    return _textField;
}

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
        _navBarView.backgroundColor = UIColor.whiteColor;
    }
    return _navBarView;
}

- (UIScrollView *)scrollView {
    if (_scrollView) return _scrollView;
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    return _scrollView;
}

- (UIView *)titleConView {
    if (_titleConView) return _titleConView;
    _titleConView = [[UIView alloc] init];
    _titleConView.backgroundColor = UIColor.clearColor;
    return _titleConView;
}

- (UIView *)slipView {
    if (!_slipView) {
        _slipView = [UIView new];
        _slipView.backgroundColor = UIColor.brownColor;
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


