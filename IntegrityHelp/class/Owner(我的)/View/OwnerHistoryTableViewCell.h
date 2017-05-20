//
//  OwnerHistoryTableViewCell.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/12.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OwnerHistoryListModel;

@interface OwnerHistoryTableViewCell : UITableViewCell

- (void)cellConfigureModel:(OwnerHistoryListModel *)model;

@end
