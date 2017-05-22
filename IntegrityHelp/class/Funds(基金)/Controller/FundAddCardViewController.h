//
//  FundAddCardViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/20.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^CallBack)();


@interface FundAddCardViewController : BaseViewController
@property(nonatomic,assign) CallBack callBack;

@end
