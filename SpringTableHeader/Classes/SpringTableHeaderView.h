//
//  SpringTableHeaderView.h
//  SpringTableHeader
//
//  Created by Wayne on 2018/6/14.
//  Copyright © 2018年 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpringTableHeaderView;

@protocol SpringTableHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(SpringTableHeaderView *)headView percentageOfStretching:(CGFloat)percentage;

@end

/**
 SpringTableHeaderView 作为一个容器视图，其内容需要 contentView 进行填充。
 */
@interface SpringTableHeaderView : UIView

@property (nonatomic, weak) id<SpringTableHeaderViewDelegate> delegate;

/**
 Header 的固有高度，应在在添加视图之前设置这个值。
 默认为 0.
 */
@property (nonatomic, assign) CGFloat intrinsicContentHeight;

@property (nonatomic, strong) __kindof UIView *contentView;

@end
