//
//  RegisterViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/25.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegistProtocolViewController.h"
#import "QQLBXScanViewController.h"
#import "StyleDIY.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *pwdRepet;
@property (weak, nonatomic) IBOutlet UITextField *inviteCode;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property(nonatomic,assign) BOOL agree;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav:@"注册" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    
}

- (IBAction)scanQRCode:(id)sender {
    QQLBXScanViewController *scanVC = [[QQLBXScanViewController alloc] init];
    scanVC.style = [StyleDIY qqStyle];
    //镜头拉远拉近功能
    scanVC.isVideoZoom = YES;
    WS(weakSelf)
    scanVC.callBack = ^(NSString *qrStr){
        _inviteCode.text = qrStr;
        [weakSelf returnBtnStatus];
    };
    [self.navigationController pushViewController:scanVC animated:YES];
}


- (IBAction)agreeProtocol:(id)sender {
    if (_agree) {
        [_agreeBtn setImage:[UIImage imageNamed:@"icon_agree"] forState:(UIControlStateNormal)];
        
        _registBtn.enabled = YES;
        _registBtn.backgroundColor = kMainColor;
    }else{
        [_agreeBtn setImage:[UIImage imageNamed:@"icon_disagree"] forState:(UIControlStateNormal)];
        _registBtn.enabled = NO;
        _registBtn.backgroundColor = RGB(212,213,214);
    }
    _agree = !_agree;
}

- (IBAction)registProtocol:(id)sender {
    
    RegistProtocolViewController *registpVC = [[RegistProtocolViewController alloc] init];
    [self.navigationController pushViewController:registpVC animated:YES];
}

- (IBAction)registerAction:(id)sender {
    if (_username.text.length < 1) {
        return [self.view Message:@"请输入姓名" HiddenAfterDelay:1];
    }else if (_phoneNumber.text.length != 11){
        return [self.view Message:@"请输入11位手机号码" HiddenAfterDelay:1];
    }else if (_pwd.text.length < 6){
        return [self.view Message:@"请输入密码最少6位哦" HiddenAfterDelay:1];
    }else if (_pwdRepet.text.length < 6){
        return [self.view Message:@"请输入密码最少6位哦" HiddenAfterDelay:1];
    }else if (![_pwd.text isEqualToString:_pwdRepet.text]){
        return [self.view Message:@"您两次密码输入不一致！" HiddenAfterDelay:1];
    }else if (_inviteCode.text.length < 1){
        return [self.view Message:@"请输入邀请码" HiddenAfterDelay:1];
    }else if (_agree){
        return [self.view Message:@"您还没有同意注册服务协议哦" HiddenAfterDelay:1];
    }
    
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/reg" refreshCache:NO params:@{@"pwd":_pwd.text,@"phone":_phoneNumber.text,@"code":_inviteCode.text,@"name":_username.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self returnBtnStatus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self returnBtnStatus];
}

- (void)returnBtnStatus{
    NSInteger name    = _username.text.length;
    NSInteger phone   = _phoneNumber.text.length;
    NSInteger pwd     = _pwd.text.length;
    NSInteger pwdSure = _pwdRepet.text.length;
    NSInteger invite  = _inviteCode.text.length;
    
    if ((name > 0) && (phone == 11) && (pwd >= 6) && (pwdSure >= 6) && (invite > 0) ){
        _registBtn.enabled = YES;
        _registBtn.backgroundColor = kMainColor;
    } else {
        _registBtn.enabled = NO;
        _registBtn.backgroundColor = RGB(212,213,214);
    }
}


@end
