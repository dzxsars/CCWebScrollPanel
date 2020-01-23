//
//  CCWebScrollPanelTopView.h
//  CCWebScrollView
//
//  Created by DuZhixia on 2020/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWebScrollPanelTopView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

NS_ASSUME_NONNULL_END
