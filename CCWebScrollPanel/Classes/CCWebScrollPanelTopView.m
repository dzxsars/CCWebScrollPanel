//
//  CCWebScrollPanelTopView.m
//  CCWebScrollView
//
//  Created by DuZhixia on 2020/1/23.
//

#import "CCWebScrollPanelTopView.h"

@implementation CCWebScrollPanelTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self __setupViews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)].CGPath;
}

- (void)__setupViews
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    
    self.layer.mask = self.maskLayer;
    self.layer.masksToBounds = YES;
    
    NSLayoutConstraint *titleCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *titleCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *titleTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeLeading multiplier:1 constant:-5];

    [self addConstraint:titleCenterXConstraint];
    [self addConstraint:titleCenterYConstraint];
    [self addConstraint:titleTrailingConstraint];
    
    NSLayoutConstraint *closeTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-8];
    NSLayoutConstraint *closeCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *closeWidthConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:32];
    NSLayoutConstraint *closeHeightConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:32];
    [self addConstraint:closeTrailingConstraint];
    [self addConstraint:closeCenterYConstraint];
    [self.closeButton addConstraint:closeWidthConstraint];
    [self.closeButton addConstraint:closeHeightConstraint];
}

#pragma mark - Lazily Load

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _closeButton;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
    }
    
    return _maskLayer;
}

@end


