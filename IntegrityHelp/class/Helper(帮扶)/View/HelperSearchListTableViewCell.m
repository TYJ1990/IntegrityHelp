//
//  HelperSearchListTableViewCell.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperSearchListTableViewCell.h"
#import "HelperModel.h"

@interface HelperSearchListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *addTime;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;


@end

@implementation HelperSearchListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _helpBtn.layer.borderColor = kMainColor.CGColor;
    _helpBtn.layer.borderWidth = 1;
    _helpBtn.layer.cornerRadius = 3;
    _helpBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)cellConfigureModle:(HelperListModel *)model{
    _title.text = model.Title;
    _username.text = model.U_name;
    _type.text = model.T_name;
    _addTime.text = [Utils TransformTimestampWith:[model.Addtime stringValue] dateDormate:@"yyyy-MM-dd"];
    _status.text = [Utils getStatus:[model.Status integerValue]];
}



@end
