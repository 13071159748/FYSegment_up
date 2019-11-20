//
//  ViewController.m
//  FYSegment_up
//
//  Created by 冯勇 on 2019/11/15.
//  Copyright © 2019 冯勇. All rights reserved.
//

#import "ViewController.h"
#import "FYSegmentBar.h"

@interface ViewController ()
@property (nonatomic, strong) FYSegmentBar *fYSegmentBar;
@property (nonatomic, strong) NSArray *dataArr;             //数据源
@property (nonatomic, strong) NSMutableArray <UIView *>*views;        //要放入的View数组
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataArr];
    [self setUI];
}

- (void)getDataArr
{
    //创建View数组
    self.dataArr = @[@"1",@"2",@"3",@"4",@"5",@"6"];//栏目名字
}

- (void)setUI
{
    //设置FYSegmentBar
    FYSegmentBar *bar = [[FYSegmentBar alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50) andNames:self.dataArr andViews:[self createViewArr].copy];
    self.fYSegmentBar = bar;
    [self.view addSubview:bar];
}

- (NSArray *)createViewArr
{
    //创建View数组
    self.views = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    for (int i = 0; i < self.dataArr.count; i++) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [self RandomColor];
        [self.views addObject:v];
    }
    return self.views;
}

//随机色
- (UIColor*)RandomColor {
   NSInteger aRedValue =arc4random() %255;
   NSInteger aGreenValue =arc4random() %255;
   NSInteger aBlueValue =arc4random() %255;
   UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
   return  randColor;
}

#pragma mark --  FYSegmentBarDelegate
- (void)didSegmentWithIndex:(NSInteger)index{
    NSLog(@"current index : %ld",(long)index);
}

@end
