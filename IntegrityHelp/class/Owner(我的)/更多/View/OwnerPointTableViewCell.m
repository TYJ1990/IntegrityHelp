//
//  OwnerPointTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerPointTableViewCell.h"
#import "OwnerPointModel.h"

@interface OwnerPointTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation OwnerPointTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _support.layer.borderColor = kMainColor.CGColor;
    _support.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


- (void)cellConfigureModel:(OwnerPointListModel *)model index:(NSInteger)index{
    _numberLabel.text = [NSString stringWithFormat:@"%ld",index + 1];
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(model.u_face)] placeholderImage:[UIImage imageNamed:@"owner_header"]];
    _name.text = model.Name;
    
}

@end
