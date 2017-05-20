//
//  OwnerMoreMemberViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/17.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerMoreMemberViewController.h"

@interface OwnerMoreMemberViewController ()

@end

@implementation OwnerMoreMemberViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)initnavi{
    [self initNav:@"会员体系" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

@end
