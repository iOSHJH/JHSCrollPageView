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

/*
    关于
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [titles addObject:[NSString stringWithFormat:@"title%d",i]];
        [vcs addObject:[UIViewController new]];
    }
    JHSCrollPageVC *vc = [[JHSCrollPageVC alloc] initWithVCs:vcs titles:titles];
//    [vc selectTitleVC:1];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
