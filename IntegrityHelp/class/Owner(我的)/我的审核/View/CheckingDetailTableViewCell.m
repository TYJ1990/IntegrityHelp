//
//  CheckingDetailTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "CheckingDetailTableViewCell.h"

@interface CheckingDetailTableViewCell()

@end

@implementation CheckingDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _icon.layer.cornerRadius = 25;
    _icon.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    _bgView.layer.borderWidth = 1;
}

- (void)cellConfigureModel:(HelpDetailModel *)model{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer new];
    [path moveToPoint:CGPointMake(50, 32)];
    [path addLineToPoint:CGPointMake(42, 40)];
    [path addLineToPoint:CGPointMake(50, 48)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    [self.layer addSublayer:layer];
}

- (void)layoutSubviews{
    
}




@end
