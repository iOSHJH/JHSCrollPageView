//
//  ViewController.m
//  JHSCrollPageView
//
//  Created by 黄俊煌 on 2017/10/10.
//  Copyright © 2017年 hongsui. All rights reserved.
//

#import "ViewController.h"
#import "JHSCrollPageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor brownColor];
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor lightGrayColor];
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor brownColor];
    
    JHSCrollPageVC *vc = [[JHSCrollPageVC alloc] initWithVCs:@[vc1, vc2, vc3] titles:@[@"vc1", @"vc2", @"vc3"]];
    [vc selectTitleVC:1];
//    vc.navigationBarHide = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
