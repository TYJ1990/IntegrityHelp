//
//  RegistProtocolViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "RegistProtocolViewController.h"

@interface RegistProtocolViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webview;

@end

@implementation RegistProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initNav:@"注册服务协议" color:kMainColor imgName:@"back_white"];
    [self initWebView];
}


- (void)initWebView{
    [self.view addSubview:({
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _webview.delegate = self;
        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ly560020.com/jijin/agree.html"]]];
        _webview;
    })];
}



- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.title = @"加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = @"注册服务协议";
}

@end
