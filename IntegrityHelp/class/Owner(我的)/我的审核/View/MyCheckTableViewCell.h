//
//  MyCheckTableViewCell.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/3.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OwnerCheckingListModel;

@interface MyCheckTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

- (void)cellConfigureModle:(OwnerCheckingListModel *)model;

@end
