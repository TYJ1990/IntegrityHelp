//
//  BaseViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)initNav:(NSString *)title;
- (void)initNav:(NSString *)title color:(UIColor *)color imgName:(NSString *)imgName;
- (void)leftImg:(NSString *)imgName;
- (void)leftImgAction;
- (void)rightTitle:(NSString *)title;
- (void)rightImage:(NSString *)imgName;
- (void)rightAction;


@end
