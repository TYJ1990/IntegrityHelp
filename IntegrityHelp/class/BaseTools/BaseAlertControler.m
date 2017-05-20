//
//  QMQAlertControler.m
//  helper
//
//  Created by 秦慕乔 on 16/1/15.
//  Copyright © 2016年 com.tiaohuo. All rights reserved.
//

#import "BaseAlertControler.h"


@implementation BaseAlertControler:UIView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIAlertController *)alertmessage:(NSString *)Message Title:(NSString *)title  andBlock:(AlertBlcok)block;
{
    UIAlertController *AlertControler = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction * Sure = [UIAlertAction actionWithTitle:Message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    [AlertControler addAction:Cancel];
    [AlertControler addAction:Sure];
    return AlertControler;
}
@end
