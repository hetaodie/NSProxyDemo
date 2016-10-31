//
//  ViewController.m
//  NSProxyDemo
//
//  Created by Weixu on 16/5/19.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array= [[NSMutableArray alloc] init];
    [array addObject:nil];
    [array addObject:@"11"];
    [array insertObject:@"11" atIndex:1];
    
    NSLog(@"%@",array);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:nil forKey:@"key"];
    NSLog(@"%@",dic);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
