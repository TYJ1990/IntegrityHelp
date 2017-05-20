//
//  OwnerHistoryTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/12.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerHistoryTableViewCell.h"
#import "OwnerHistoryModel.h"

@interface OwnerHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *addTime;


@end

@implementation OwnerHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer new];
    [path moveToPoint:CGPointMake(65, 30)];
    [path addLineToPoint:CGPointMake(55, 37)];
    [path addLineToPoint:CGPointMake(65, 44)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor colorWithHex:0xA5C6F9].CGColor;
    layer.strokeColor = [UIColor colorWithHex:0xA5C6F9].CGColor;
    [self.layer addSublayer:layer];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


- (void)cellConfigureModel:(OwnerHistoryListModel *)model{
    _content.text = model.Content;
    _addTime.text = [Utils TransformTimestampWith:model.Addtime dateDormate:@"yyyy-MM-dd HH:mm"];
}



@end
