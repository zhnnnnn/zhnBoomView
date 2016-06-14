//
//  ViewController.m
//  zhnBoomView
//
//  Created by zhn on 16/6/14.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+zhnBoom.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic,weak) UIImageView * boomView1;

@property (nonatomic,weak) UIImageView * boomView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView * boomView1 = [[UIImageView alloc]init];
    [self.view addSubview:boomView1];
    boomView1.image = [UIImage imageNamed:@"kobe"];
    boomView1.frame = CGRectMake(10, 10, 100, 100);
    self.boomView1 = boomView1;
    boomView1.userInteractionEnabled = YES;
    
    UIImageView * boomView2 = [[UIImageView alloc]init];
    [self.view addSubview:boomView2];
    boomView2.image = [UIImage imageNamed:@"chaz5"];
    boomView2.frame = CGRectMake(200, 200, 100, 100);
    self.boomView2 = boomView2;
    boomView2.userInteractionEnabled = YES;
   
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    [boomView1 addGestureRecognizer:tap1];
    [boomView2 addGestureRecognizer:tap2];
    
    

}

- (void)tap1:(UITapGestureRecognizer *)tap{
    
    [self.boomView1 boom];
}

- (void)tap2:(UITapGestureRecognizer *)tap{
    
    [self.boomView2 boom];
}



@end
