//
//  CheckingDetailTableViewCell.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDetailModel.h"


@interface CheckingDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

- (void)cellConfigureModel:(HelpDetailModel *)model;

@end
