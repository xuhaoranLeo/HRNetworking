//
//  ViewController.m
//  HRNetworking
//
//  Created by 许昊然 on 2016/9/21.
//  Copyright © 2016年 许昊然. All rights reserved.
//

#import "ViewController.h"
#import "TestAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestAPI *api = [[TestAPI alloc] initWithKeyword:@"茶壶"];
    [api start:^(id handleData) {
        NSLog(@"%@", handleData);
    } error:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
