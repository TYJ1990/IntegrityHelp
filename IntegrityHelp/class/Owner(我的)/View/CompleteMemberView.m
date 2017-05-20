//
//  CompleteMemberView.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/6.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "CompleteMemberView.h"

@implementation CompleteMemberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _completeBtn.layer.cornerRadius = 5;
        _completeBtn.layer.masksToBounds = YES;
    }
    return self;
}

@end
