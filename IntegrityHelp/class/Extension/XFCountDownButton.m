//
//  THWCountDownButton.m
//  customer
//
//  Created by 秦慕乔 on 16/6/30.
//  Copyright © 2016年 tiaohuo. All rights reserved.
//

#import "XFCountDownButton.h"

@interface XFCountDownButton ()

@property (strong,nonatomic) NSTimer *countDownTimer;
@property (strong,nonatomic) UIColor *enableBackgroundColour;
@property (assign,nonatomic) NSUInteger timeCount;
@end

@implementation XFCountDownButton


-(void)startCountDownTimer
{
    _timeCount = _countDown;
    _themeStr = self.titleLabel.text;
    _enableBackgroundColour=self.backgroundColor;
    [self setBackgroundColor:_disableBackgroundColour];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%lds",_countDown] forState:UIControlStateNormal];
    
}

-(void)countDownAction
{
    _countDown-=1;
    if(!_countDown)
    {
        [self setNormalState];
    }
    else
    {
        if(_THWGetTimeCount)
            _THWGetTimeCount(_countDown);
        [self setTitle:[NSString stringWithFormat:@"%lds",_countDown] forState:UIControlStateNormal];
    }
}



/**
 * 销毁定时器
 */
-(void)setNormalState
{
    /*销毁定时器*/
    [_countDownTimer invalidate];
    _countDownTimer = nil;

    /*定时结束启用的回调函数*/
    if(_THWTimeOut)
        _THWTimeOut();
    /*重新设置title和背景色*/
    [self setTitle:_themeStr forState:UIControlStateNormal];
    [self setBackgroundColor:_enableBackgroundColour];
    _countDown=_timeCount;
    /*使能控件*/
    self.enabled = YES;
}


@end
