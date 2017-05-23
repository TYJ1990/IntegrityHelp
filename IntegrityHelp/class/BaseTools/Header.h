//
//  Header.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#ifndef Header_h
#define Header_h




//宏定义颜色
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/// 全局常用属性
#define NavH 64

/// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width

/// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height

/// 屏幕范围
#define ScreenBounds UIScreen.main.bounds

/// 屏幕范围（除去导航栏）
#define ScreenBoundsNotNav CGRect(x  0, y  0, width  ScreenW, height  ScreenH-NavH)

/// iOS8.0以后系统
#define iOS8Later (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0

//适配用
#define IPHONE4S (([[UIScreen mainScreen] bounds].size.width == 320) && ([[UIScreen mainScreen] bounds].size.height == 480))

#define IPHONE5S (([[UIScreen mainScreen] bounds].size.width == 320) && ([[UIScreen mainScreen] bounds].size.height == 568))

#define IPHONE6 (([[UIScreen mainScreen] bounds].size.width == 375) && ([[UIScreen mainScreen] bounds].size.height == 667))

#define IPHONE6P (([[UIScreen mainScreen] bounds].size.width == 414) && ([[UIScreen mainScreen] bounds].size.height == 736))

/// 间距
#define kMargin 10.0
/// 圆角
#define kCornerRadius  5.0
/// 线宽
#define klineWidth 1.0

/// 颜色块
#define kRed       [UIColor redColor]
#define kGray      [UIColor grayColor]
#define kWhite     [UIColor whiteColor]
#define kBlack     [UIColor blackColor]
#define kGreen     [UIColor greenColor]
#define kBlue      [UIColor blueColor]
#define kClear     [UIColor clearColor]
#define kDarkGray  [UIColor darkGrayColor]
#define kDarkText  [UIColor darkTextColor]
#define kLightGray [UIColor lightGrayColor]
#define kLightText [UIColor lightTextColor]
/// 底线的颜色
#define kMainLine  [UIColor colorWithHex:0xc8c8ce]

/// 统一的外观颜色
#define kAppearanceColor  RGB(250,60,67)

/// 偏粉红色颜色（按钮、文字、边框等颜色）
#define kMainColor  RGB(78, 140, 238)

/// 灰色背景颜色 (UITablView、UICollectionView 背景色)
#define kMainGray   RGB(245, 245, 249)

/// 橘黄色
#define kYellow     RGB(255, 140, 0)

/// 帮扶审核灰色按钮
#define kGrayBtn    RGB(216,215,214)


/// 灰色按钮背景
#define kMainBtnGrayColor  [UIColor colorWithHex:0xcccccc]

#define kAppearanceFont    [UIFont systemFontOfSize:20]

//字体大小
#define kFont(a)       [UIFont systemFontOfSize:a]
#define kBlodFont(b)   [UIFont boldSystemFontOfSize:b]
#define imageUrl(url)  [NSString stringWithFormat:@"http://101.37.38.41:8090/%@",url]
#define imageUrl2(url)  [NSString stringWithFormat:@"http://101.37.38.41:8090/%@",url]
#define imageUrl3(url)  [NSString stringWithFormat:@"http://101.37.38.41:8090/data/face/%@",url]
//#define imageUrl(url)  [NSString stringWithFormat:@"http://192.168.199.199%@",url]
//#define imageUrl2(url)  [NSString stringWithFormat:@"http://192.168.199.199/%@",url]
//#define imageUrl3(url)  [NSString stringWithFormat:@"http://192.168.199.199/data/face/%@",url]



// 高德地图appkey
#define  APIKey  @"a5ca47f27b2c220bd98d3d9de7cb7abc"





#define ALERT(msg)    if (![[UIApplication sharedApplication].delegate window].rootViewController.presentedViewController) {UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];UIAlertAction * Sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];[alert addAction:Sure];[[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alert animated:YES completion:nil];}









#endif /* Header_h */
