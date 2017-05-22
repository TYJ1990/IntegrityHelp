//
//  THWCountDownButton.h
//  customer
//
//  Created by 秦慕乔 on 16/6/30.
//  Copyright © 2016年 tiaohuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimeOut)();
typedef void(^TimeCount)(NSUInteger num);
@interface XFCountDownButton : UIButton

@property (strong,nonatomic) NSString *themeStr;
@property (assign,nonatomic) NSInteger countDown; //定时量
@property (assign,nonatomic) NSInteger interval; //定时间隔
@property (strong,nonatomic) UIColor *disableBackgroundColour; //disable的背景颜色
@property (copy,nonatomic) TimeOut THWTimeOut;//定时器结束回调函数
@property (copy,nonatomic) TimeCount THWGetTimeCount;
//开始计时
-(void) startCountDownTimer;
//结束倒计时,设置正常状态
-(void)setNormalState;
@end
