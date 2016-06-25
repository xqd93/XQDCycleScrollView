# XQDCycleScrollView
可高度自定义的轮播图控件

## 接口文档
@property (nonatomic, strong) NSArray<UIView *> * dataSource;
@property (nonatomic, weak) id <XQDCycleScrollViewDelegate> cycleScrollViewDelegate;

@property (nonatomic, assign, readonly) NSInteger currentPage;
/**
*  自动滚动的页数 默认 1
*  正数 往前
*  负数 往后
*/
@property (nonatomic, assign) NSInteger autoNextPage;

@property (nonatomic, assign) CGFloat autoPlayTime;//动画间隔时间，默认3秒
@property (nonatomic, assign) CGFloat transitionTime;//动画执行时间，默认0.4秒

@property (nonatomic, assign) XQDCycleScrollViewDirection direction;//滚动方向，默认水平

@property (nonatomic, assign) BOOL autoPlay;//自动执行动画，默认YES
@property (nonatomic, assign) BOOL cycleScrollEnabled;//是否能循环拖动，默认YES
@property (nonatomic, assign) UIViewAnimationOptions options;//默认 UIViewAnimationOptionCurveEaseInOut

//移动几页 前+ 后-
 - (void)moveByPages:(NSInteger)offset animated:(BOOL)animated;
//移动到第几页
 - (void)setPage:(NSInteger)newIndex animated:(BOOL)animated;
 - (void)setPage:(NSInteger)newIndex transition:(XQDCycleScrollViewTransition)transition animated:(BOOL)animated;


 - (id)initWithFrame:(CGRect)frame
direction:(XQDCycleScrollViewDirection)direction
cycleScroll:(BOOL)cycleScrolling;

 - (void)initWithDirection:(XQDCycleScrollViewDirection)direction;

## 代理
 - (void)cycleScrollView:(XQDCycleScrollView *)cycleScrollView currentPageChanged:(NSInteger)currentPage;