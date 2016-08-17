//
//  ViewController.m
//  SUtilDemo
//
//  Created by User01 on 16/8/17.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import "ViewController.h"
#import "SUtil.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cutPng:(id)sender {
    [SUtil screenShot:self.view];
}

@end
