//
//  FundCardTableViewCell.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;

@end
