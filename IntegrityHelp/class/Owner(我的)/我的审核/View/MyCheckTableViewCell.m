//
//  MyCheckTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "MyCheckTableViewCell.h"
#import "OwnerCheckingModel.h"

@interface MyCheckTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation MyCheckTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellConfigureModle:(OwnerCheckingListModel *)model{
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(model.Pic)] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
    _title.text = model.Title;
    _content.text = model.Content;
    _type.text = [NSString stringWithFormat:@"项目类别：%@",model.T_name];
    _time.text = model.time;
}

@end
