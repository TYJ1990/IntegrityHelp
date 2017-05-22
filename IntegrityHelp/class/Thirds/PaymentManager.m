//
//  PaymentManager.m
//  UJTravel
//
//  Created by YueYu on 16/11/28.
//  Copyright © 2016年 Chen. All rights reserved.
//

/*********************************支付宝参数*************************************/

#define AlipayAppID         @"2016053101464403"
#define AlipaySellerID      @"2088021224664188"
#define AlipayNotifyUrl     @"http://106.14.20.174/Api/Main/zfb_pay_success_return"
#define AlipayAppScheme     @"com.ujet.chenpeiwei"

#define AlipayPrivateKey    @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALCU/fccYJWjoxlAu8c/Qu1ZPXoeBWAU+Zi97BXH0e9OuhCsqCR6cqdWUbmGUXicjRQLUPcBptAYDx56hscJ/gzUR8HHWHyJH265xfM15OW169mGtRDOk44GnUhh/x7vjlJq8PoNP1LtIGnkRHekSF+2KYuBjy9wGp7FsUuwgwAjAgMBAAECgYACFeBh+L3TRpl4hOEy2zZpIzKsrIoXtme0PBn7r9502xMrez6JH8EW5NgWPtXbfM3VvMR6BlT4BDC5hWzuENolO5uEu0vfIhaRUNbR9Qw0Q4o3zqu28xvGX1WWn8pmGxnzTMFaBVL3Vg6MMRSuBYJl4F8laCgg6ZNc9PrxEcY24QJBAOStBRFbOH25t65H2a3W0w7gm6hbidLF00FBmiJyBGaQica3QWMbHG98XQy0NJXZQKGEpEVgEzR6S5spHq4xr4sCQQDFrnhOmJNwC0lurCQovuu1cAFg0rUEKdl+lzqw/Ze5QxvBxwZ/eqabclsFlIcg0TnykcsFbuwKlZCSa7cGhgTJAkB11uNBqmxV/Zo16Ti3aHiitgQAogtH3kGa4x92mKLD57/X8x9y3smseb3JiiN/BNFVanDsfzHmXQ8RCgORaHE5AkBombdDL2zknrROgXvoq42hxhCUoSnzeAmD+JWvzaAZAa+QS7XegpHiMxKC02LlNJDLD+Yzi8wOlbGYKLMCGqwxAkBkzlsh6awn/DrrpGvKj1NhGh+1LGeuc/v8zkKPHCnsjteWrryk9kTc+k+5WEX9i/fg2c8BDMvc0AVeFb+baSRr"


/*********************************************************************************/

#import "PaymentManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
//#import "DataSigner.h"

//#import "WXApi.h"

static PaymentManager *singleManager = nil;

@implementation PaymentManager

+ (PaymentManager *)shareManager
{
    if (!singleManager) {
        singleManager = [[PaymentManager alloc]init];
        singleManager.paymentResult = ^ (BOOL result, NSString *str) {
            
        };
    }
    
    return singleManager;
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleManager) {
            singleManager = [super init];
        }
    });
    
    return singleManager;
}

//- (void)unionPayingWithOrderNum:(NSString *)orderNum ViewController:(UIViewController *)vc Failure:(NetWorkingErrorBlock)failure
//{
//    [UJNetWorking PaymentGetUnionPayTNWithOrderNum:orderNum Success:^(id jsonResult, NSString *msg) {
//        
//        NSString *tn = jsonResult;
//        BOOL isUnionPayStart = [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"ujet.unionpay" mode:@"01" viewController:vc];
//        if (!isUnionPayStart) {
//            failure([NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:nil], 0, @"调起银联支付失败");
//        }
//        
//    } Failure:failure];
//}
//
//- (void)ucardPayingWithOrderNum:(NSString *)orderNum PayPassword:(NSString *)payPassword
//{
//    [UJNetWorking PaymentUcardPayWithOrderNum:orderNum Password:payPassword Success:^(id jsonResult, NSString *msg) {
//        self.paymentResult(YES, @"支付成功");
//    } Failure:^(NSError *error, NSInteger resultCode, NSString *msg) {
//        self.paymentResult(NO, msg);
//    }];
//}
//
//- (void)wechatPayingWithOrderNum:(NSString *)orderNum
//{
//    [UJNetWorking PaymentWechatPayWithOrderNum:orderNum Success:^(id jsonResult, NSString *msg) {
//                
//        PayReq *req = [[PayReq alloc]init];
//        req.openID = jsonResult[@"appid"];
//        req.partnerId = jsonResult[@"partnerid"];
//        req.prepayId = jsonResult[@"prepayid"];
//        req.nonceStr = jsonResult[@"noncestr"];
//        req.timeStamp = (UInt32)[jsonResult[@"timestamp"] integerValue];
//        req.package = jsonResult[@"packages"];
//        req.sign = jsonResult[@"sign"];
//        
//        [WXApi sendReq:req];
//        
//    } Failure:^(NSError *error, NSInteger resultCode, NSString *msg) {
//        self.paymentResult(NO, msg);
//    }];
//}

- (void)aliPayingWithOrderNum:(NSString *)orderNum GoodName:(NSString *)goodName Price:(NSString *)price
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = AlipayAppID;
    
    order.notify_url = AlipayNotifyUrl;
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.subject = goodName;
    order.biz_content.out_trade_no = orderNum; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"10m"; //超时时间设置
    order.biz_content.total_amount = price; //商品价格
    order.biz_content.seller_id = AlipaySellerID;
    
    order.biz_content.product_code = @"QUICK_MSECURITY_PAY";
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(AlipayPrivateKey);
//    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
//        
//        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayAppScheme callback:^(NSDictionary *resultDic) {
//            BOOL isSuccess = [resultDic[@"resultStatus"] integerValue] == 9000;
//            NSString *msg = resultDic[@"memo"];
//            [PaymentManager shareManager].paymentResult(isSuccess, isSuccess ? @"支付成功" : msg);
//        }];
//    }
}

@end
