//
//  FYSegmentBar.m
//  FYSegmentBar
//
//  Created by 冯勇 on 2019/11/15.
//  Copyright © 2019 冯勇. All rights reserved.
//
#define FYWidth  [UIScreen mainScreen].bounds.size.width
#define FYHeight  [UIScreen mainScreen].bounds.size.height

#import "FYSegmentBar.h"

@interface FYSegmentBar ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *backgorundView;//背景
@property (nonatomic, strong) UIView *sliderV;//滑条
@property (nonatomic, strong) UIButton *selectedBtn;//选中的按钮
@property (nonatomic, strong) NSArray *names;//栏目数据源
@property (nonatomic, strong) NSArray *views;//页面数据源
@property (nonatomic, assign) CGFloat offSet;//position偏移量
@property (nonatomic, strong) UIScrollView *sv;//滑动条
@property (nonatomic, assign) CGFloat offSet_sv;//SV偏移量

@end

@implementation FYSegmentBar
//子类有指定初始化函数 就重写上一级的父类指定初始化函数
- (instancetype)initWithFrame:(CGRect)frame andNames:(NSArray *)names andViews:(nonnull NSArray *)views
{
    if (self = [super initWithFrame:frame]) {
        self.names = names;
        self.views = views;
        [self setUI];
    }
    return self;
}

//子类要重写父类的指定初始化函数 designed - initializaer
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andNames:@[] andViews:@[]];
}

- (void)setUI
{
    if (self.names.count == 0 ||self.views.count == 0 ||self.views.count !=self.names.count) {
        NSLog(@"初始化FYSegment错误");
        return;
    }
    self.userInteractionEnabled = YES;
    self.offSet = (float)([UIScreen mainScreen].bounds.size.width/self.names.count)/2;
    self.offSet_sv = 0;
    
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width/self.names.count;
    self.backgorundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 50)];
    self.backgorundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgorundView];
    for (int i = 0; i<self.names.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, 50)];
        [btn setTitle:self.names[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgorundView addSubview:btn];
    }
    
    self.sliderV = [[UIView alloc] initWithFrame:CGRectMake(0, 48, btnW, 2)];
    self.sliderV.backgroundColor = [UIColor greenColor];
    [self.backgorundView addSubview:self.sliderV];
    
    [self addSubview:self.sv];
    
    for (int i = 0; i < self.views.count; i++) {
        UIView *v = self.views[i];
        v.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, self.sv.bounds.size.height);
        [self.sv addSubview:v];
    }
}

- (void)btnClick:(UIButton *)btn
{
    self.selectedBtn = btn;
    [self sliderViewAnimation];
    self.offSet_sv = (self.selectedBtn.tag - 100)*[UIScreen mainScreen].bounds.size.width;
    self.sv.contentOffset = CGPointMake((self.selectedBtn.tag - 100)*[UIScreen mainScreen].bounds.size.width, 0);//偏移的点
    NSLog(@"");
}

- (void)changeSliderViewPositionWithIndex:(NSInteger)index
{
    NSLog(@"current Index:%ld",(long)index);
    self.selectedBtn = (UIButton *)[self viewWithTag:index + 100];
    [self sliderViewAnimation];
}

- (void)sliderViewAnimation
{
    //滑动条动画
    CGFloat btnW = FYWidth/self.names.count;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.offSet,48)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((self.selectedBtn.tag - 100)*btnW +btnW/2,48)];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [self.sliderV.layer addAnimation:animation forKey:nil];
    //刷新移动之后的偏移量
    self.offSet = btnW/2 + (self.selectedBtn.tag - 100)*btnW;
}

#pragma mark -- UIScrollViewDeleage
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat currentOffset =  self.sv.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    [self  changeSliderViewPositionWithIndex:(NSInteger)currentOffset];
}

#pragma mark -- lazy
- (UIScrollView *)sv
{
    if (!_sv) {
        _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.backgorundView.frame.origin.y + self.backgorundView.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.backgorundView.frame.origin.y + self.backgorundView.frame.size.height)];
        _sv.pagingEnabled = YES;
        _sv.scrollEnabled = YES;
        _sv.delegate = self;
        _sv.bounces = NO;
        _sv.contentSize = CGSizeMake(self.views.count*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.backgorundView.frame.origin.y + self.backgorundView.frame.size.height);
    }
    return _sv;
}
@end
