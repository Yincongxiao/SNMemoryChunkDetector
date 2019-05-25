//
//  ViewController.m
//  SNMemoryChunkDetector
//
//  Created by asnail on 2019/5/24.
//  Copyright © 2019 asnail. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    int allocatedMB;
    Byte *p[10000];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 50, CGRectGetWidth(self.view.bounds) - 40, 50);
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn setTitle:@"malloc(100 * 1024 * 1024)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(makeMallocChunk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)makeMallocChunk {
    p[allocatedMB] = malloc(100 * 1048576);
    memset(p[allocatedMB], 0, 100 * 1048576);
    allocatedMB += 1;
}

@end
