//
//  FYSegmentBar.h
//  FYSegmentBar
//
//  Created by 冯勇 on 2019/11/15.
//  Copyright © 2019 冯勇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface FYSegmentBar : UIView


@property (nonatomic, weak) id<FYSegmentBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andNames:(NSArray *)names andViews:(NSArray *)views;

- (void)changeSliderViewPositionWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
