//
//  IntegralView.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS-Echarts.h"

@interface IntegralView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSorce;
@property (weak, nonatomic) IBOutlet PYEchartsView *kEchartView;


- (void)getChartsWithValueArray:(NSArray *)valueArr nameArray:(NSArray *)nameArr;



@end
