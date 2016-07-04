//
//  XQDCycleScrollView.m
//  XQDCycleScrollViewDemo
//
//  Created by QiDongXiao on 16/6/8.
//  Copyright © 2016年 QiDongXiao. All rights reserved.
//

#import "XQDCycleScrollView.h"

#define XQDCycleScrollViewDefaultOffsetCount 1

typedef NS_ENUM(NSInteger ,XQDCycleScrollViewScrollDirection) {
    XQDCycleScrollViewScrollDirectionBackward = 0,
    XQDCycleScrollViewScrollDirectionForward  = 1
};

@interface XQDCycleScrollView ()<UIScrollViewDelegate>
{
    NSUInteger _selfWidth;
    NSUInteger _selfHeight;
    
    NSTimer * _timer;
    BOOL _isManualAnimating;
}

@property (nonatomic, assign) NSUInteger selfSize;
@property (nonatomic, assign) NSUInteger numberOfPages;

@end

@implementation XQDCycleScrollView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame direction:XQDCycleScrollViewDirectionHorizontal cycleScroll:YES];
}

- (id)initWithFrame:(CGRect)frame
          direction:(XQDCycleScrollViewDirection)direction
        cycleScroll:(BOOL)cycleScrolling
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithDirection:direction cycleScroll:cycleScrolling];
    }
    return self;
}

- (void)initWithDirection:(XQDCycleScrollViewDirection)direction
{
    [self initWithDirection:direction cycleScroll:YES];
}

- (void)initWithDirection:(XQDCycleScrollViewDirection)direction cycleScroll:(BOOL)cycleScrolling
{
    _direction = direction;
    _cycleScrollEnabled = cycleScrolling;
    _autoPlayTime = 3.0;
    _transitionTime = 0.4;
    _autoPlay = YES;
    _isManualAnimating = YES;
    _currentPage = -1;
    _autoNextPage = 1;
    _options = UIViewAnimationOptionCurveEaseInOut;
    [self initializeControl];
}

- (void)initializeControl
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initWithDirection:XQDCycleScrollViewDirectionHorizontal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selfWidth = self.frame.size.width;
    _selfHeight = self.frame.size.height;
    
    int offset = (int)([self hasMultiplePages] ? 3 : 1);//_numberOfPages + 2
    if (_direction == XQDCycleScrollViewDirectionHorizontal) {
        self.contentSize = CGSizeMake(_selfWidth * offset,
                                      _selfHeight);
    } else {
        self.contentSize = CGSizeMake(_selfWidth,
                                      _selfHeight * offset);
    }
}

- (NSUInteger)selfSize
{
    if (_direction == XQDCycleScrollViewDirectionHorizontal) {
        return _selfWidth;
    }
    return _selfHeight;
}

- (BOOL)hasMultiplePages {
    return _numberOfPages > 1;
}

#pragma mark - setter

- (void)setDataSource:(NSArray<UIView *> *)dataSource
{
    _dataSource = dataSource;
    self.numberOfPages = _dataSource.count;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        [self reloadData];
    }
}

- (void)setDirection:(XQDCycleScrollViewDirection)direction
{
    if (_direction != direction) {
        _direction = direction;
        [self reloadData];
    }
}

- (void)setAutoPlay:(BOOL)autoPlay
{
    _autoPlay = autoPlay;
    [self reloadData];
}

- (void)setCycleScrollViewDelegate:(id<XQDCycleScrollViewDelegate>)CycleScrollViewDelegate
{
    _cycleScrollViewDelegate = CycleScrollViewDelegate;
    
    if ([_cycleScrollViewDelegate respondsToSelector:@selector(numberOfPagesInCycleScrollView:)]) {
        _numberOfPages = [_cycleScrollViewDelegate numberOfPagesInCycleScrollView:self];
    }
}

- (void)setAutoPlayTime:(CGFloat)autoPlayTime
{
    _autoPlayTime = autoPlayTime;
    
    [self autoPlayPause];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoPlayTime target:self selector:@selector(autoPlayNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - timer

- (void)resetAutoPlay
{
    if(_autoPlay)
    {
        self.autoPlayTime = _autoPlayTime;
    }
    else
    {
        [self autoPlayPause];
    }
}

- (void)autoPlayNextPage
{
    if ([self hasMultiplePages]) {
        [self goToNextPage];
    }
}

- (void)goToNextPage
{
    NSInteger nextPage = [self pageIndexByAdding:_autoNextPage from:_currentPage];
    [self setPage:nextPage animated:YES];
}

- (void)autoPlayPause
{
    if(_timer)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayNextPage) object:nil];
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)autoPlayResume
{
    [self resetAutoPlay];
}

#pragma mark - func

- (void)reloadData
{
    if (_numberOfPages <= 0) {
        return;
    }
    [self autoPlayPause];
    [self layoutIfNeeded];
    [self setMustCurrentViewAtIndex:0];
    [self resetAutoPlay];
}

- (CGPoint)createPoint:(CGFloat)size
{
    if (_direction == XQDCycleScrollViewDirectionHorizontal) {
        return CGPointMake(size, 0);
    } else {
        return CGPointMake(0, size);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.bounces = YES;
    [self autoPlayResume];
    if (_cycleScrollViewDelegate && [_cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollViewDidEndDragging:willDecelerate:)]) {
        [_cycleScrollViewDelegate cycleScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = (_direction==XQDCycleScrollViewDirectionHorizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y;
    if (offset != self.selfSize*XQDCycleScrollViewDefaultOffsetCount) {
        [scrollView setContentOffset:[self createPoint:self.selfSize*XQDCycleScrollViewDefaultOffsetCount] animated:YES];
    }
    
    if (_cycleScrollViewDelegate && [_cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollViewDidEndDecelerating:)]) {
        [_cycleScrollViewDelegate cycleScrollViewDidEndDecelerating:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isManualAnimating = NO;
    [self autoPlayPause];
    if (_cycleScrollViewDelegate && [_cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollViewWillBeginDragging:)]) {
        [_cycleScrollViewDelegate cycleScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isManualAnimating) {
        return;
    }
    if (_cycleScrollViewDelegate && [_cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollViewDidScroll:)]) {
        [_cycleScrollViewDelegate cycleScrollViewDidScroll:self];
    }
    
    CGFloat offset = (_direction==XQDCycleScrollViewDirectionHorizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y;
    
    
    XQDCycleScrollViewScrollDirection proposedScroll = (offset <= (self.selfSize*XQDCycleScrollViewDefaultOffsetCount) ?
                                                      XQDCycleScrollViewScrollDirectionBackward :
                                                      XQDCycleScrollViewScrollDirectionForward);
    
    BOOL canScrollBackward = (_cycleScrollEnabled || (!_cycleScrollEnabled && _currentPage != 0));
    BOOL canScrollForward = (_cycleScrollEnabled || (!_cycleScrollEnabled && _currentPage < (_numberOfPages-1)));
    
    NSInteger prevPage = [self pageIndexByAdding:-1 from:_currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:_currentPage];
    if (prevPage == nextPage) {
        [self loadViewAtIndex:prevPage andPlaceAtIndex:(proposedScroll == XQDCycleScrollViewScrollDirectionBackward ? -1 : 1)];
    }
    
    if ( (proposedScroll == XQDCycleScrollViewScrollDirectionBackward && !canScrollBackward) ||
        (proposedScroll == XQDCycleScrollViewScrollDirectionForward && !canScrollForward)) {
        self.bounces = NO;
        [scrollView setContentOffset:[self createPoint:self.selfSize*XQDCycleScrollViewDefaultOffsetCount] animated:NO];
        return;
    } else self.bounces = YES;
    
    NSInteger newPageIndex = _currentPage;
    
    if (offset <= 0)//self.selfSize*(XQDCycleScrollViewDefaultOffsetCount-1)
        newPageIndex = [self pageIndexByAdding:-1 from:_currentPage];
    else if (offset >= self.selfSize*(XQDCycleScrollViewDefaultOffsetCount+1))
        newPageIndex = [self pageIndexByAdding:+1 from:_currentPage];
    
    [self setCurrentViewAtIndex:newPageIndex];
}

- (void)setCurrentViewAtIndex:(NSInteger)index {
    if (index == _currentPage) return;
    [self setMustCurrentViewAtIndex:index];

    if ([_cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollView:currentPageChanged:)])
        [_cycleScrollViewDelegate cycleScrollView:self currentPageChanged:_currentPage];
}

- (void)setMustCurrentViewAtIndex:(NSInteger)index
{
    _currentPage = index;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger prevPage = [self pageIndexByAdding:-1 from:_currentPage];
    NSInteger nextPage = [self pageIndexByAdding:+1 from:_currentPage];
    
    [self loadViewAtIndex:index andPlaceAtIndex:0];
    if ([self hasMultiplePages]) {
        [self loadViewAtIndex:prevPage andPlaceAtIndex:-1];
        [self loadViewAtIndex:nextPage andPlaceAtIndex:1];
    }
    self.contentOffset = [self createPoint:self.selfSize * ([self hasMultiplePages] ? XQDCycleScrollViewDefaultOffsetCount : 0)];
}

- (NSInteger)pageIndexByAdding:(NSInteger)offset from:(NSInteger)index {
    while (offset<0) offset += _numberOfPages;
    return (_numberOfPages+index+offset) % _numberOfPages;
    
}

- (void)moveByPages:(NSInteger)offset animated:(BOOL)animated {
    NSUInteger finalIndex = [self pageIndexByAdding:offset from:self.currentPage];
    XQDCycleScrollViewTransition transition = (offset >= 0 ?  XQDCycleScrollViewTransitionForward :
                                             XQDCycleScrollViewTransitionBackward);
    [self setPage:finalIndex transition:transition animated:animated];
}

- (void)setPage:(NSInteger)newIndex animated:(BOOL)animated {
    [self setPage:newIndex transition:_autoNextPage > 0 ? XQDCycleScrollViewTransitionForward:XQDCycleScrollViewTransitionBackward animated:animated];
}

- (void)setPage:(NSInteger)newIndex transition:(XQDCycleScrollViewTransition)transition animated:(BOOL)animated {
    if (newIndex == _currentPage) return;
    
    if (animated) {
        CGPoint finalOffset;
        
        if (transition == XQDCycleScrollViewTransitionAuto) {
            if (newIndex > self.currentPage) transition = XQDCycleScrollViewTransitionForward;
            else if (newIndex < self.currentPage) transition = XQDCycleScrollViewTransitionBackward;
        }
        
        if (transition == XQDCycleScrollViewTransitionForward) {
            [self loadViewAtIndex:newIndex andPlaceAtIndex:1];
            finalOffset = [self createPoint:(self.selfSize*(XQDCycleScrollViewDefaultOffsetCount+1))];
        } else {
            [self loadViewAtIndex:newIndex andPlaceAtIndex:-1];
            finalOffset = [self createPoint:(self.selfSize*(XQDCycleScrollViewDefaultOffsetCount-1))];
        }
        _isManualAnimating = YES;
        
        [UIView animateWithDuration:_transitionTime
                              delay:0.0
                            options:_options
                         animations:^{
                             self.contentOffset = finalOffset;
                         } completion:^(BOOL finished) {
                             if (!finished) return;
                             [self setCurrentViewAtIndex:newIndex];
                             _isManualAnimating = NO;
                         }];
    } else {
        [self setCurrentViewAtIndex:newIndex];
    }
}

- (UIView *)loadViewAtIndex:(NSInteger)index andPlaceAtIndex:(NSInteger)destIndex {
    UIView * view = nil;
    if (_cycleScrollViewDelegate && [self.cycleScrollViewDelegate respondsToSelector:@selector(cycleScrollView:viewForRowAtIndex:)]) {
        view = [_cycleScrollViewDelegate cycleScrollView:self viewForRowAtIndex:index];
    } else {
        if (_dataSource.count > index) {
            view = _dataSource[index];
        }
    }
    if (!view) {
        return nil;
    }
    
    CGRect viewFrame = CGRectMake(0, 0, _selfWidth, _selfHeight);
    int offset = [self hasMultiplePages] ? XQDCycleScrollViewDefaultOffsetCount : 0;
    if (_direction == XQDCycleScrollViewDirectionHorizontal) {
        viewFrame = CGRectOffset(viewFrame, _selfWidth * (destIndex + offset), 0);
    } else {
        viewFrame = CGRectOffset(viewFrame, 0, _selfHeight * (destIndex + offset));
    }
    
    view.frame = viewFrame;
    [self addSubview:view];
    return view;
}


@end
