//
//  ViewController2.m
//  XQDCycleScrollViewDemo
//
//  Created by QiDongXiao on 16/6/25.
//  Copyright © 2016年 QiDongXiao. All rights reserved.
//

#import "ViewController2.h"
#import "XQDCycleScrollView.h"
#import "TestView.h"

@interface ViewController2 ()<XQDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet XQDCycleScrollView *cycleScrollView1;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray * ary4 = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        TestView * view = [[NSBundle mainBundle] loadNibNamed:@"TestView" owner:nil options:nil].firstObject;
        view.label.text = [NSString stringWithFormat:@"%d",i];
        view.label.layer.borderWidth = 4;
        view.label.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 2;
        view.backgroundColor = [self arndomColor];
        [ary4 addObject:view];
    }
    _cycleScrollView1.dataSource = ary4;
//    _cycleScrollView1.direction = XQDCycleScrollViewDirectionVertical;
    _cycleScrollView1.autoPlay = NO;
    _cycleScrollView1.cycleScrollViewDelegate = self;
    _cycleScrollView1.autoNextPage = -1;
}

- (void)cycleScrollView:(XQDCycleScrollView *)cycleScrollView currentPageChanged:(NSInteger)currentPage
{
    NSLog(@"currentPage = %ld",currentPage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forward:(id)sender {
    NSLog(@">>");
    [_cycleScrollView1 moveByPages:3 animated:YES];
}

- (IBAction)backward:(id)sender {
    NSLog(@"<<");
    [_cycleScrollView1 moveByPages:-3 animated:YES];
}

- (UIColor *)arndomColor
{
    return [UIColor colorWithRed: (arc4random()%255)/255.
                           green: (arc4random()%255)/255.
                            blue: (arc4random()%255)/255.
                           alpha: 1.0];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
