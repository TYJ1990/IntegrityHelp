//
//  HelperDetailView.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/4.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelpDetailModel;

@interface Helper_DetailV : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;

- (void)initWithModel:(HelpDetailModel *)model;



@end
