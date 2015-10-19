//
//  ViewController.m
//  xunhuan
//
//  Created by 韩金波 on 15/6/30.
//  Copyright (c) 2015年 韩金波-psylife. All rights reserved.
//

#import "ViewController.h"
#import "loopPageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    loopPageView *loopV = [[loopPageView alloc]init];
    loopV.imageNames = @[@"00.jpg",@"01.jpg",@"02.jpg",@"03.jpg",@"04.jpg"];
    loopV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    //    loopV.isPortrait = YES;//打开就会竖着显示
    [self.view addSubview:loopV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
