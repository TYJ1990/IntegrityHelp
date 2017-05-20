//
//  FundTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundTableViewCell.h"
#import "FundModel.h"

@interface FundTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation FundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kMainGray;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellConfigureModel:(FundListModel *)model{
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(model.Pic1)] placeholderImage:[UIImage imageNamed:@"help_banner02"]];
    _title.text = model.Title;
    _content.text = model.Content;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"项目周期%ld月",[model.Rmonth integerValue]]];
    [string addAttribute:NSForegroundColorAttributeName value:kGray range:NSMakeRange(0, 4)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xff6d06] range:NSMakeRange(4, string.length - 5)];
    [string addAttribute:NSForegroundColorAttributeName value:kGray range:NSMakeRange(string.length - 1, 1)];
    _time.attributedText = string;
}



@end
