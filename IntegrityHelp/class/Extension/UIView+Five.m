//
//  UIView+Five.m
//  WXMedia
//
//  Created by User on 14-8-5.
//  Copyright (c) 2014年 User. All rights reserved.
//

#import "UIView+Five.h"
#import <objc/runtime.h>

static char HUDKEY_BE;

@implementation UIView (Five)

#pragma 信息提示 Setter Getter
@dynamic hud;
-(void)setHud:(MBProgressHUD *)newValue{
	objc_setAssociatedObject(self.superview, &HUDKEY_BE, newValue, OBJC_ASSOCIATION_RETAIN);
}
-(MBProgressHUD *)hud{
	MBProgressHUD * hud_0314 = [MBProgressHUD HUDForView:self];

	if(hud_0314 == nil){
		hud_0314 = [MBProgressHUD showHUDAddedTo:self animated:YES];
		[self addSubview:hud_0314];
	}
	
	return hud_0314;
}
//每个都能用
- (void)MessageOnAnyViewWith:(NSString *)message HiddenAfterDelay:(NSTimeInterval)delay
{
    if ([message isEqualToString:@""]) {
        return;
    }
    UIView * messageView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH / 2 - 30, ScreenW, 60)];
//    View(0, HEIGHT /2 -30, WIDTH, 60);
    if ([self viewWithTag:98766543210]) {
        [[self viewWithTag:98766543210] removeFromSuperview];
    }
    messageView.tag = 98766543210;
    [self addSubview:messageView];
    [messageView Message:message HiddenAfterDelay:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [messageView removeFromSuperview];
    });
    
}
//每个都能用
- (void)loadingOnAnyView
{
    if ([self viewWithTag:98766543210]) {
        [[self viewWithTag:98766543210] removeFromSuperview];
    }
    UIView * messgeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0  , ScreenW, ScreenH)];
    messgeView.tag = 1234567890;
    [self addSubview:messgeView];
    [messgeView Loading_0314];
}
//隐藏
- (void)removeAnyView
{
    UIView *vie = [self viewWithTag:1234567890];
    [vie removeFromSuperview];
}

#pragma 显示
/**提示信息,延迟两秒*/
- (void)Message:(NSString *)message{
	[self Message:message HiddenAfterDelay:2.0];
}

/**提示信息，N秒后关闭*/
- (void)Message:(NSString *)message HiddenAfterDelay:(NSTimeInterval)delay{
	[self Message:message YOffset:0.0 HiddenAfterDelay:delay];
}

/**自定义提示框位置*/
- (void)Message:(NSString *)message YOffset:(float)yoffset HiddenAfterDelay:(NSTimeInterval)delay{
	
	MBProgressHUD * hud_0314 = self.hud;

	hud_0314.yOffset = yoffset;
	hud_0314.mode = MBProgressHUDModeText;
	hud_0314.labelText = message;
	[hud_0314  show:true];
	
	[hud_0314  hide:true afterDelay:delay];

}

/**展示Loading标示*/
- (void)Loading:(NSString *)message{
	MBProgressHUD * hud_0314 = self.hud;
	hud_0314.yOffset = 0.0;
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	hud_0314.labelText = message;
	[hud_0314  show:true];
}


/**
 <#Description#>

 @param message <#message description#>
 @param yoffset <#yoffset description#>
 */
-(void) Loading:(NSString *)message YOffset:(float)yoffset
{
    MBProgressHUD * hud_0314 = self.hud;
    hud_0314.yOffset = yoffset;
    hud_0314.mode = MBProgressHUDModeIndeterminate;
    hud_0314.labelText = message;
    [hud_0314  show:true];
}

/**隐藏*/
- (void)HiddenAfterDelay:(NSTimeInterval)delay{
	[self.hud  hide:true afterDelay:delay];
}

/**隐藏*/
- (void)Hidden{
	[self.hud hide:YES];
}

- (void)Loading_0314{
	[self touchesEnded:nil withEvent:nil];

	MBProgressHUD * hud_0314 = self.hud;
	
	hud_0314.mode = MBProgressHUDModeIndeterminate;
	[hud_0314  show:true];
}

/*是否Loading中*/
- (BOOL)IsLoading{
	MBProgressHUD * hud_0314 = self.hud;
	
	if((hud_0314.mode == MBProgressHUDModeIndeterminate || hud_0314.mode == MBProgressHUDModeIndeterminate) &&
	   !hud_0314.isHidden){
		return YES;
	}
	else{
		return NO;
	}
}
@end
