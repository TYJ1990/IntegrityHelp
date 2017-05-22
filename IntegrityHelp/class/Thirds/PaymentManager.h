//
//  PaymentManager.h
//  UJTravel
//
//  Created by YueYu on 16/11/28.
//  Copyright © 2016年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentManager : NSObject

+ (PaymentManager *)shareManager;

@property (copy, nonatomic) void (^paymentResult)(BOOL isSuccess, NSString *errorStr); /**< 支付后的回调 返回是否成功 以及失败情况下的错误信息*/

- (void)wechatPayingWithOrderNum:(NSString *)orderNum;

//- (void)unionPayingWithOrderNum:(NSString *)orderNum ViewController:(UIViewController *)vc Failure:(NetWorkingErrorBlock)failure;

- (void)ucardPayingWithOrderNum:(NSString *)orderNum PayPassword:(NSString *)payPassword;

- (void)aliPayingWithOrderNum:(NSString *)orderNum GoodName:(NSString *)goodName Price:(NSString *)price;

@end

