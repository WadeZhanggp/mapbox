//
//  ViewController.m
//  MapBox3
//
//  Created by 张光鹏 on 16/6/6.
//  Copyright © 2016年 Tsinova. All rights reserved.
//

#import "ViewController.h"
#import "MapBoxView.h"

@interface ViewController ()

@property (nonatomic, strong) MapBoxView *mapBoxView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mapBoxView = [[MapBoxView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapBoxView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
