//
//  FundPeriodViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CallBack)(NSString *);

@interface FundPeriodViewController : BaseViewController

@property(nonatomic,copy) CallBack callBack;

@end
