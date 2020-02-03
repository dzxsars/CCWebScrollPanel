//
//  CCWebScrollPanelViewController.m
//  CCWebScrollView
//
//  Created by DuZhixia on 2020/1/23.
//

#import "CCWebScrollPanelViewController.h"

#import "CCWebScrollPanelTopView.h"

@interface CCWebScrollPanelViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView<CCWebView> *webView;
@property (nonatomic, strong) CCWebScrollPanelTopView *topView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundGrayMaskView;
@property (nonatomic, strong) UIVisualEffectView *backgroundGaussianMaskView;

@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *topBarPanGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *syncWebPanGesture;

@property (nonatomic, strong) NSLayoutConstraint *containerTopConstraint;

@property (nonatomic, assign) CGFloat currentPanSessionStartWebOffset; // 当前web页内滑动起始时web页面的偏移
@property (nonatomic, assign) BOOL hasReachTopestSlide; // 是否到顶过

@property (nonatomic, weak) id<CCWebViewScrollPanelActionDelegate> delegate;

@end

@implementation CCWebScrollPanelViewController

- (instancetype)initWithWebView:(UIView<CCWebView> *)webView
{
    return [self initWithWebView:webView delegate:nil];
}

- (instancetype)initWithWebView:(UIView<CCWebView> *)webView delegate:(id<CCWebViewScrollPanelActionDelegate>)delegate
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _webView = webView;
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _delegate = delegate;
    }
    
    [self __setupViews];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    return self;
}

#pragma mark - Public

- (void)setPanelTitle:(NSString *)title
{
    self.topView.titleLabel.text = title;
}

- (void)setBackgroundMaskType:(CCWebScrollPanelBackgroundMaskType)maskType
{
    [UIView animateWithDuration:0.5 animations:^{
        switch (maskType) {
            case CCWebScrollPanelBackgroundMaskTypeNone:
            {
                [self __moveContainerToSuperview:self.view];
                self.backgroundGrayMaskView.hidden = self.backgroundGaussianMaskView.hidden = YES;
                break;
            }
            case CCWebScrollPanelBackgroundMaskTypeGray:
            {
                [self __moveContainerToSuperview:self.backgroundGrayMaskView];
                self.backgroundGaussianMaskView.hidden = YES;
                self.backgroundGrayMaskView.hidden = NO;
                break;
            }
            case CCWebScrollPanelBackgroundMaskTypeGaussian:
            {
                [self __moveContainerToSuperview:self.backgroundGaussianMaskView.contentView];
                self.backgroundGaussianMaskView.hidden = NO;
                self.backgroundGrayMaskView.hidden = YES;
                break;
            }
                
            default:
                break;
        }
    }];
}

#pragma mark - Private

- (void)__setupViews
{
    [self setBackgroundMaskType:CCWebScrollPanelBackgroundMaskTypeNone];
    
    [self.view addGestureRecognizer:self.backgroundTapGesture];
    
    [self.view addSubview:self.backgroundGrayMaskView];
    NSLayoutConstraint *maskGrayLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGrayMaskView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *maskGrayTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGrayMaskView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *maskGrayTopConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGrayMaskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:-[UIScreen mainScreen].bounds.size.height];
    NSLayoutConstraint *maskGrayBottomConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGrayMaskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:maskGrayLeadingConstraint];
    [self.view addConstraint:maskGrayTrailingConstraint];
    [self.view addConstraint:maskGrayTopConstraint];
    [self.view addConstraint:maskGrayBottomConstraint];
    
    [self.view addSubview:self.backgroundGaussianMaskView];
    NSLayoutConstraint *maskGaussianLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGaussianMaskView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *maskGaussianTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGaussianMaskView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *maskGaussianTopConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGaussianMaskView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:-[UIScreen mainScreen].bounds.size.height];
    NSLayoutConstraint *maskGaussianBottomConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundGaussianMaskView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:maskGaussianLeadingConstraint];
    [self.view addConstraint:maskGaussianTrailingConstraint];
    [self.view addConstraint:maskGaussianTopConstraint];
    [self.view addConstraint:maskGaussianBottomConstraint];

    [self.containerView addSubview:self.topView];
    
    NSLayoutConstraint *topViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *topViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *topViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:48];
    NSLayoutConstraint *topViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];

    [self.containerView addConstraint:topViewLeadingConstraint];
    [self.containerView addConstraint:topViewTrailingConstraint];
    [self.topView addConstraint:topViewHeightConstraint];
    [self.containerView addConstraint:topViewTopConstraint];
    
    [self.topView.closeButton addTarget:self action:@selector(handleTapClose) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addGestureRecognizer:self.topBarPanGesture];
    
    [self.containerView addSubview:self.webView];
    
    NSLayoutConstraint *webViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *webViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *webViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *webViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

    [self.containerView addConstraint:webViewLeadingConstraint];
    [self.containerView addConstraint:webViewTrailingConstraint];
    [self.containerView addConstraint:webViewBottomConstraint];
    [self.containerView addConstraint:webViewTopConstraint];
    
    [self.webView addGestureRecognizer:self.syncWebPanGesture];
}

- (void)__close
{
    [self __removeMask];
    [self __callWebViewShouldClose];
}

- (void)__callWebViewShouldClose
{
    if ([self.delegate respondsToSelector:@selector(webViewScrollPanelShouldClose:)]) {
        [self.delegate webViewScrollPanelShouldClose:self];
    }
}

- (void)__removeMask
{
    [self setBackgroundMaskType:CCWebScrollPanelBackgroundMaskTypeNone];
}

/// 这个方法处理了拖动松手后容器的位置变化
/// @param offset 松手时的偏移
/// @param velocity 松手时的速度
- (void)__handlePanReleaseWithOffset:(CGFloat)offset velocity:(CGFloat)velocity
{
    const CGFloat topestMargin = [self topestMargin];
    const CGFloat topInitMargin = [self topInitMargin];

    if (offset > [self closeHeightMargin] || (velocity > [self closeVelocity] && offset > 0)) {
        // 关掉容器
        [self __close];
    } else if (![self heightIncreaseMode]){
        // 不可增高的时候, 如果不关闭容器, 恢复固定的高度
        [UIView animateWithDuration:0.18 animations:^{
            [self __updateContainerTopMargin:topInitMargin];
        }];
    } else {
        // 可增高的时候, 如果不关闭容器, 计算此时是否应该变为增高并修改状态
        CGFloat endTop = [self __containerViewEndTopWithOffset:offset];
        [UIView animateWithDuration:0.18 animations:^{
            [self __updateContainerTopMargin:endTop];
        }];
        self.hasReachTopestSlide = (endTop == topestMargin);
    }
}

/// 这个方法计算了容器应该停留的位置
/// @param offset 垂直方向的偏移量, 传0则能获得容器未偏移的初始位置
- (CGFloat)__containerViewEndTopWithOffset:(CGFloat)offset
{
    const CGFloat topestMargin = [self topestMargin];
    const CGFloat topInitMargin = [self topInitMargin];

    CGFloat top = topInitMargin;
    if (self.hasReachTopestSlide) {
        top = topestMargin;
    }
    
    if (offset > 0) return top;
    
    CGFloat end = top + offset;
    const CGFloat heightToggleRation = [self heightToggleRatio];
    
    if (end <= topestMargin) {
        end = topestMargin;
    } else if (end >= topInitMargin) {
        end = topInitMargin;
    } else if (end < (topInitMargin * heightToggleRation + topestMargin * (1 - heightToggleRation))) {
        end = topestMargin;
    } else {
        end = topInitMargin;
    }
    
    return end;
}

- (void)__updateContainerTopMargin:(CGFloat)topMargin
{
    [self.view removeConstraint:self.containerTopConstraint];
    self.containerTopConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:topMargin];
    [self.view addConstraint:self.containerTopConstraint];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)__moveContainerToSuperview:(UIView *)superview
{
    if (self.containerView.superview == superview) return;
    
    [self.containerView removeFromSuperview];
    
    CGFloat topMargin = [self topInitMargin];
    if (self.containerTopConstraint) {
        topMargin = self.containerTopConstraint.constant;
    }
    
    if (superview == self.backgroundGrayMaskView || superview == self.backgroundGaussianMaskView.contentView) {
        topMargin += [UIScreen mainScreen].bounds.size.height;
    }
    
    [superview addSubview:self.containerView];
    
    NSLayoutConstraint *containerLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *containerTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *containerBottomConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *containerTopConstraint = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1 constant:topMargin];
    self.containerTopConstraint = containerTopConstraint;

    [superview addConstraint:containerLeadingConstraint];
    [superview addConstraint:containerTrailingConstraint];
    [superview addConstraint:containerBottomConstraint];
    [superview addConstraint:containerTopConstraint];
}

#pragma mark - Action

/// 这个方法处理了顶部bar被手势拖动开始/位置改变/结束时容器的位置变化
/// @param recognizer 手势
- (void)handleTopViewPan:(UIPanGestureRecognizer *)recognizer
{
    if (![recognizer isKindOfClass:[UIPanGestureRecognizer class]]) return;
    
    CGFloat yOffset = [recognizer translationInView:recognizer.view].y;
    CGFloat velocity = [recognizer velocityInView:recognizer.view].y;
    const CGFloat topestMargin = [self topestMargin];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGFloat endTop = [self __containerViewEndTopWithOffset:0];
            if ([self heightIncreaseMode] && yOffset < 0) {
                if (endTop + yOffset <= topestMargin) {
                    yOffset = topestMargin - endTop;
                }
            } else if (![self heightIncreaseMode] && yOffset < 0) {
                yOffset = 0;
            }
            [self __updateContainerTopMargin:(endTop + yOffset)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self __handlePanReleaseWithOffset:yOffset velocity:velocity];
            break;
        }
            
        default:
            break;
    }
}

- (void)handleTapDismiss:(UITapGestureRecognizer *)recognizer
{
    if (![recognizer isKindOfClass:[UITapGestureRecognizer class]]) return;
    
    [self __close];
}

- (void)handleTapClose
{
    [self __close];
}

/// 同步webView滚动的触发
/// @param recognizer 同步的Pan手势
- (void)webViewScrollDidScroll:(UIPanGestureRecognizer *)recognizer
{
    if (![recognizer isKindOfClass:[UIPanGestureRecognizer class]]) return;
    
    CGFloat yOffset = [recognizer translationInView:recognizer.view].y;
    CGFloat velocity = [recognizer velocityInView:recognizer.view].y;
    CGFloat currentWebOffset = self.webView.scrollView.contentOffset.y;
    CGFloat endTop = [self __containerViewEndTopWithOffset:0] + yOffset - self.currentPanSessionStartWebOffset;
    
    BOOL webReachTop = currentWebOffset <= 0;
    BOOL isUp = velocity <= 0;
    BOOL isContainerAtTop = [self heightIncreaseMode] ? (endTop <= [self topestMargin]) : (endTop <= [self topInitMargin]);

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.currentPanSessionStartWebOffset = currentWebOffset;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (webReachTop && !isUp) {
                // web不动,容器下滑
                [self __updateContainerTopMargin:endTop];
                self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, -1);
            } else if (!isContainerAtTop && isUp) {
                // web不动,容器上滑
                [self __updateContainerTopMargin:endTop];
                self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, 1);
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (webReachTop || isUp) {
                [self __handlePanReleaseWithOffset:(yOffset - self.currentPanSessionStartWebOffset) velocity:velocity];
            }
            self.currentPanSessionStartWebOffset = 0;
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - UI Params

- (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

/// 初始位置面板顶部和屏幕顶部的距离
- (CGFloat)topInitMargin
{
    return [self screenHeight] * 0.3;
}

/// 面板顶部可达最高处和屏幕顶部的距离
- (CGFloat)topestMargin
{
    return [self screenHeight] * 0.1;
}

/// 面板整体下滑以触发关闭面板的距离
- (CGFloat)closeHeightMargin
{
    return [self screenHeight] * 0.2;
}

/// 触发关闭面板的下滑速度阈值
- (CGFloat)closeVelocity
{
    return 100;
}

- (CGFloat)heightToggleRatio
{
    return 0.8;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.syncWebPanGesture && otherGestureRecognizer == self.webView.scrollView.panGestureRecognizer) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.syncWebPanGesture && otherGestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return YES;
    }
    return NO;
}


#pragma mark - Lazily Load

- (CCWebScrollPanelTopView *)topView
{
    if (!_topView) {
        _topView = [[CCWebScrollPanelTopView alloc] init];
    }
    
    return _topView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (UIView *)backgroundGrayMaskView
{
    if (!_backgroundGrayMaskView) {
        _backgroundGrayMaskView = [[UIView alloc] init];
        _backgroundGrayMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.24];
        _backgroundGrayMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundGrayMaskView;
}

- (UIVisualEffectView *)backgroundGaussianMaskView
{
    if (!_backgroundGaussianMaskView) {
        _backgroundGaussianMaskView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _backgroundGaussianMaskView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundGaussianMaskView;
}

- (UIPanGestureRecognizer *)topBarPanGesture
{
    if (!_topBarPanGesture) {
        _topBarPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopViewPan:)];
    }
    return _topBarPanGesture;
}

- (UITapGestureRecognizer *)backgroundTapGesture
{
    if (!_backgroundTapGesture) {
        _backgroundTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDismiss:)];
    }
    return _backgroundTapGesture;
}

- (UIPanGestureRecognizer *)syncWebPanGesture
{
    if (!_syncWebPanGesture) {
        _syncWebPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(webViewScrollDidScroll:)];
        _syncWebPanGesture.delegate = self;
    }
    return _syncWebPanGesture;
}


@end
