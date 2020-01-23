//
//  CCViewController.m
//  CCWebScrollView
//
//  Created by duzhixia on 01/23/2020.
//  Copyright (c) 2020 duzhixia. All rights reserved.
//

#import "CCViewController.h"

#import <CCWebScrollPanel/CCWebScrollPanelViewController.h>
#import <CCWebScrollPanel/UIWebView+CCWebView.h>
#import <CCWebScrollPanel/WKWebView+CCWebView.h>

@interface CCViewController ()<CCWebViewScrollPanelActionDelegate>

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setTitle:@"UIWebView" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(tapUIWebView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setTitle:@"WKWebView" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(tapWKWebView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    
    button1.frame = CGRectMake(100, 100, 200, 80);
    button2.frame = CGRectMake(100, 200, 200, 80);
}

- (void)tapUIWebView
{
    WKWebView *webView = [[WKWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/s?wd=UIWebview"]]];
    
    CCWebScrollPanelViewController *viewController = [[CCWebScrollPanelViewController alloc] initWithWebView:webView delegate:self];
    [viewController setPanelTitle:@"打开UIWebView(固定高)"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)tapWKWebView
{
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/s?wd=WKWebview"]]];
    
    CCWebScrollPanelViewController *viewController = [[CCWebScrollPanelViewController alloc] initWithWebView:webView delegate:self];
    viewController.heightIncreaseMode = YES;
    [viewController setPanelTitle:@"打开WKWebView(可增高)"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)webViewScrollPanelShouldClose:(CCWebScrollPanelViewController * __unused)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
