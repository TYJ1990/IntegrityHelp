//
//  HelperTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperTableViewCell.h"
#import "HelperModel.h"


@interface HelperTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *help;

@end

@implementation HelperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _help.layer.borderColor = kMainColor.CGColor;
    _help.layer.borderWidth = 1;
    [_help setCornerRadius:3];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


- (void)cellConfigureModel:(HelperListModel *)model{
    _title.text = model.Title;
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageUrl(model.Pic1)] placeholderImage:[UIImage imageNamed:@"help_banner02"]];
    _content.text = model.Content;
    _username.text = model.U_name;
    _type.text = model.T_name;
    _time.text = [self TransformTimestampWith:[model.Addtime stringValue] dateDormate:@"yyyy-MM-dd"];
}


- (NSString *)TransformTimestampWith:(NSString *)dateString dateDormate:(NSString *)formate
{
    NSTimeInterval interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:formate];
    NSString *timestr =  [objDateformat stringFromDate: date];
    return timestr;
}




@end
