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
        self.clipsToBounds = YES;
        _contentView = [UIView new];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    if (_contentView) {
        [self addSubview:_contentView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.top -= _intrinsicContentHeight;
        scrollView.contentInset = contentInset;
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
    UIScrollView *scrollView = (UIScrollView *)newSuperview;
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.top += _intrinsicContentHeight;
    scrollView.contentInset = contentInset;
    
    [scrollView addObserver:self
                 forKeyPath:@"contentOffset"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
    if (offset.y < 0) {
        CGRect frame = self.frame;
        frame.origin.y = offset.y;
        frame.size.height = -offset.y;
        self.frame = frame;
    }
}

@end
