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
