//
//  CCWebScrollPanelViewController.h
//  CCWebScrollView
//
//  Created by DuZhixia on 2020/1/23.
//

#import <UIKit/UIKit.h>

#import "CCWebViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCWebScrollPanelBackgroundMaskType) {
    CCWebScrollPanelBackgroundMaskTypeNone, // default
    CCWebScrollPanelBackgroundMaskTypeGray,
    CCWebScrollPanelBackgroundMaskTypeGaussian,
};

@class CCWebScrollPanelViewController;

@protocol CCWebViewScrollPanelActionDelegate <NSObject>

@optional

/// 内部建议关闭容器
- (void)webViewScrollPanelShouldClose:(CCWebScrollPanelViewController *)controller;

@end

@interface CCWebScrollPanelViewController : UIViewController

@property (nonatomic, assign) BOOL heightIncreaseMode;

- (instancetype)initWithWebView:(UIView<CCWebView> *)webView;
- (instancetype)initWithWebView:(UIView<CCWebView> *)webView delegate:(nullable id<CCWebViewScrollPanelActionDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)setPanelTitle:(NSString *)title;
- (void)setBackgroundMaskType:(CCWebScrollPanelBackgroundMaskType)maskType;

@end

NS_ASSUME_NONNULL_END
