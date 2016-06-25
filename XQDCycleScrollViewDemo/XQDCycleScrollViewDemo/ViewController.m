//
//  ViewController.m
//  XQDCycleScrollViewDemo
//
//  Created by QiDongXiao on 16/6/25.
//  Copyright © 2016年 QiDongXiao. All rights reserved.
//

#import "ViewController.h"
#import "XQDCycleScrollView.h"
#import "TestView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet XQDCycleScrollView * cycleScrollView1;
@property (weak, nonatomic) IBOutlet XQDCycleScrollView * cycleScrollView2;
@property (weak, nonatomic) IBOutlet XQDCycleScrollView * cycleScrollView3;
@property (weak, nonatomic) IBOutlet XQDCycleScrollView * cycleScrollView4;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}


- (void)test
{
    NSArray * ary1 = [self getDataSourceArray];
    NSArray * ary2 = [self getDataSourceArray];
    NSArray * ary3 = [self getDataSourceArray];
    NSArray * ary4 = [self getDataSourceArray];
    
    _cycleScrollView1.dataSource = ary1;
    
    _cycleScrollView2.dataSource = ary2;
    _cycleScrollView2.autoNextPage = -1;
    
    _cycleScrollView3.direction = XQDCycleScrollViewDirectionVertical;
    _cycleScrollView3.dataSource = ary3;
    _cycleScrollView3.autoNextPage = 3;
    
    
    _cycleScrollView4.dataSource = ary4;
    _cycleScrollView4.direction = XQDCycleScrollViewDirectionVertical;
    _cycleScrollView4.cycleScrollEnabled = NO;
    _cycleScrollView4.options = UIViewAnimationOptionCurveEaseIn;
    _cycleScrollView4.autoNextPage = -1;
    _cycleScrollView4.autoPlayTime = 2;
    _cycleScrollView4.transitionTime = 1.9;
    
}

- (NSArray *)getDataSourceArray
{
    NSMutableArray * ary = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        TestView * view = [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:nil options:nil].firstObject;
        view.label.text = [NSString stringWithFormat:@"%d",i];
        view.label.layer.borderWidth = 4;
        view.label.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 2;
        view.backgroundColor = [self arndomColor];
        [ary addObject:view];
    }
    return ary;
}

- (UIColor *)arndomColor
{
    return [UIColor colorWithRed: (arc4random()%255)/255.
                           green: (arc4random()%255)/255.
                            blue: (arc4random()%255)/255.
                           alpha: 1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end