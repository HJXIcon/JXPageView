//
//  ViewController.m
//  OC版PageView
//
//  Created by mac on 17/8/4.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "ViewController.h"
#import "JXPageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    NSArray *titles = @[@"适合",@"十二班",@"的华",@"推荐爱推荐爱",@"人丹33",@"适合",@"十二班",@"的华"];
    JXPageStyle *style = [[JXPageStyle alloc]init];
    
    style.isScrollEnable = NO;
    style.isShowBottomLine = YES;
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        
        [childVcs addObject:vc];
    }
    
    CGRect pageViewFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    
    [self.view addSubview:pageView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
