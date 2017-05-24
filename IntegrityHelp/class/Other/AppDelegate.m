//
//  AppDelegate.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SDLaunchViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CloudPushSDK/CloudPushSDK.h>

@interface AppDelegate ()
@property(nonatomic,strong)LoginViewController *rootViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    _rootViewController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
            SDLaunchViewController *vc = [[SDLaunchViewController alloc]initWithMainVC:nav viewControllerType:GreenhandLaunchViewController];
        vc.imageNameArray = @[@"lead_1",@"lead_2",@"lead_3",@"lead_4",@"lead_5"];
        self.window.rootViewController = vc;
    }else{
        SDLaunchViewController *vc = [[SDLaunchViewController alloc]initWithMainVC:nav viewControllerType:ADLaunchViewController];
        vc.imageURL = @"http://pic.qiantucdn.com/58pic/17/80/57/94s58PICA7j_1024.jpg";
        vc.adURL = @"http://www.jianshu.com/users/e39da354ce50/latest_articles";
        self.window.rootViewController = vc;
    }
    
    
    [self.window makeKeyAndVisible];
    
    //高德地图
    [AMapServices sharedServices].apiKey = APIKey;
    
    //网络请求
    [HYBNetworking updateBaseUrl:@"http://101.37.38.41:8090/"];
//    [HYBNetworking updateBaseUrl:@"http://192.168.199.199/"];
    [HYBNetworking cacheGetRequest:NO shoulCachePost:NO];
    [HYBNetworking enableInterfaceDebug:YES];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.enableAutoToolbar = YES;
    
    [self initCloudPush];
    [self registerAPNS:application];
    
    return YES;
}



- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"23858904" appSecret:@"ff538a1fee8b42da938d2bd261da2d6d" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            BOOL isSuccess = [resultDic[@"resultStatus"] integerValue] == 9000;
            NSString *msg = resultDic[@"memo"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:isSuccess?@"支付成功":msg message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
