//
//  SpringTableHeaderView.m
//  SpringTableHeader
//
//  Created by Wayne on 2018/6/14.
//  Copyright © 2018年 Wayne. All rights reserved.
//

#import "SpringTableHeaderView.h"

@interface SpringTableHeaderView ()

@end

@implementation SpringTableHeaderView

#if DEBUG
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
#endif

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.contentView = [UIView new];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView == nil)
        return;
    
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:_contentView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
        return;
    }
    
    if (newSuperview == self.superview) {
        return;
    }
    
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {
        NSCAssert(NO, @"Must be added in an UIScrollView.");
        return;
    }
    
    self.frame = CGRectMake(0, 0, newSuperview.frame.size.width, _intrinsicContentHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [newSuperview addObserver:self
                   forKeyPath:@"contentOffset"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.superview sendSubviewToBack:self];
}

- (BOOL)_isSelfAtBottomInSuperView
{
    NSArray *subviews = self.superview.subviews;
    
    if (subviews.count == 0)
        return NO;
    
    return subviews[0] == self;
}

- (void)_updateContentViewFrame
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    CGRect frame = self.contentView.frame;
    
    frame.origin.x = 0;
    frame.size.width = self.bounds.size.width;
    
    frame.size.height = -scrollView.contentOffset.y + _intrinsicContentHeight;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    
    self.contentView.frame = frame;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat percentage = 0, distance = _intrinsicContentHeight;
    
    if (offset.y <= 0) {
        percentage = fabs(offset.y) / distance;
        [self _callDelegateWithScale:percentage];
        
        [self _updateContentViewFrame];
        if (![self _isSelfAtBottomInSuperView]) {
            [self.superview sendSubviewToBack:self];
        }
    } else if (percentage != 0) {
        percentage = 0;
        [self _callDelegateWithScale:percentage];
    }
    
    
}

- (void)_callDelegateWithScale:(CGFloat)percentage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:percentageOfStretching:)]) {
        [self.delegate headerView:self percentageOfStretching:percentage];
    }
}

@end
