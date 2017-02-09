//
//  ViewController.m
//  QQBubble
//
//  Created by wufeifan on 2017/2/8.
//  Copyright © 2017年 wufeifan. All rights reserved.
//

#import "ViewController.h"
#import "WFFDragBubbleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WFFDragBubbleView *bubble = [[WFFDragBubbleView alloc] init];
    bubble.backgroundColor = [UIColor cyanColor];
    bubble.tag = 999;
    bubble.frame = CGRectMake((self.view.bounds.size.width - 300) / 2, (self.view.bounds.size.height - 300) / 2, 300, 300);
//    // config. can ignore.
//    bubble.circlePoint = CGPointMake(275, 25);
//    bubble.circleRadius = 25;
//    bubble.touchCircleRadius = 8;
//    bubble.maxDistance = 200;
//    //    bubble.offsetRadian = M_PI / 3;
    [self.view addSubview:bubble];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    WFFDragBubbleView *bubbleView = [self.view viewWithTag:999];
    if (bubbleView) {
        [bubbleView restore];
    }
}


@end
