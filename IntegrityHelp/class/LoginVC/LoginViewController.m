//
//  LoginViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "OwnerInfoModel.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "FindPWDViewController.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneNumber.text = [Utils getValueForKey:@"phone"];
    _pwd.text = [Utils getValueForKey:@"pwd"];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    [UIApplication sharedApplication].statusBarHidden = NO;
}




- (IBAction)login:(id)sender {
//    if (_phoneNumber.text.length != 11) {
//        [self.view Message:@"请输入正确的手机号码" HiddenAfterDelay:1];
//        return;
//    }else if (_pwd.text.length < 6 || _pwd.text.length > 16){
//        [self.view Message:@"请输入6-16位登陆密码！" HiddenAfterDelay:1];
//        return;
//    }

    [Utils setValue:_phoneNumber.text key:@"phone"];
    
    [self.view Loading:@"登录中..."];
    [HYBNetworking postWithUrl:@"IosIndex/login" refreshCache:NO params:@{@"phone":_phoneNumber.text,@"pwd":_pwd.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            OwnerInfoModel *model = [[OwnerInfoModel alloc] initWithDictionary:response[@"data"] error:&error];
            [Utils setValue:_pwd.text key:@"pwd"];
            [Utils setValue:model.u_pwd key:@"pwdMd5"];
            [Utils setValue:model.u_id key:@"u_id"];
            [Utils setValue:model.u_name key:@"name"];
            [Utils setValue:model.f_id_name?model.f_id_name:@"" key:@"f_id_name"];
            [Utils setValue:model.ff_id_name?model.ff_id_name:@"" key:@"ff_id_name"];
            [Utils setValue:model.u_regtime ? model.u_regtime:@"" key:@"u_regtime"];
            
            [CloudPushSDK bindAccount:_phoneNumber.text withCallback:^(CloudPushCallbackResult *res) {
                NSLog(@"绑定成功");
            }];
            RootViewController *hvc = [[RootViewController alloc] init];
            self.view.window.rootViewController = hvc;
        }
    } fail:^(NSError *error) {
        [self.view Hidden];
    }];
}

- (IBAction)regist:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)forgetPWD:(id)sender {
    FindPWDViewController *findVC = [[FindPWDViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
