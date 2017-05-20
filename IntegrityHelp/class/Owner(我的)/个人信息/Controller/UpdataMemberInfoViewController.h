//
//  UpdataMemberInfoViewController.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CallBack)(NSString *);

@interface UpdataMemberInfoViewController : BaseViewController

@property(nonatomic,strong) NSString *type;
@property(nonatomic,copy) CallBack callBack;
@property(nonatomic,strong) NSString *content;

@end
