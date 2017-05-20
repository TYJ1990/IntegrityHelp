//
//  OwnerPointTableViewCell.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OwnerPointListModel;

@interface OwnerPointTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *support;


- (void)cellConfigureModel:(OwnerPointListModel *)model index:(NSInteger)index;

@end
