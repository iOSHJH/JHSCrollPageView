//
//  ViewController.m
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import "ViewController.h"
#import "JHSCrollPageVC.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    TestViewController *vc1 = [TestViewController new];
    vc1.title = @"vc1";
    vc1.view.backgroundColor = [UIColor brownColor];
    TestViewController *vc2 = [TestViewController new];
    vc2.title = @"vc2";
    vc2.view.backgroundColor = [UIColor lightGrayColor];
    TestViewController *vc3 = [TestViewController new];
    vc3.title = @"vc3";
    vc3.view.backgroundColor = [UIColor brownColor];
    TestViewController *vc4 = [TestViewController new];
    vc3.title = @"vc4";
    vc3.view.backgroundColor = [UIColor brownColor];
    TestViewController *vc5 = [TestViewController new];
    vc3.title = @"vc5";
    vc3.view.backgroundColor = [UIColor brownColor];
    TestViewController *vc6 = [TestViewController new];
    vc3.view.backgroundColor = [UIColor brownColor];
    TestViewController *vc7 = [TestViewController new];
    vc3.view.backgroundColor = [UIColor brownColor];
    
    // 关于NSArray性能：默认会加载前三个控制器，后面的用到才加载
    NSArray *vcs = @[vc1, vc2, vc3, vc4, vc5, vc6, vc7];
//    NSLog(@"%@",vcs);
    
    JHSCrollPageVC *vc = [[JHSCrollPageVC alloc] initWithVCs:vcs titles:@[@"vc1", @"vc2", @"vc3", @"vc4", @"vc5", @"vc6", @"vc7"]];
    [vc selectTitleVC:1];
//    vc.navigationBarHide = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
