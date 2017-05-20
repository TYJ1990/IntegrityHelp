//
//  HelperPruductViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CallBack)();

@interface HelperPruductViewController : BaseViewController

@property(nonatomic,copy) CallBack callBack;

@end
