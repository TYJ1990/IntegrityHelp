//
//  QMQAlertControler.h
//  helper
//
//  Created by 秦慕乔 on 16/1/15.
//  Copyright © 2016年 com.tiaohuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlcok)();
@interface BaseAlertControler : UIView

- (UIAlertController *)alertmessage:(NSString *)Message   Title:(NSString *)title  andBlock:(AlertBlcok)block;

@end
