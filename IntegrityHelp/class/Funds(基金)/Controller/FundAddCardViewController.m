//
//  FundAddCardViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/20.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundAddCardViewController.h"

@interface FundAddCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet XFCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UILabel *cardName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *IDcard;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@end

@implementation FundAddCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)initnavi{
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    [self initNav:@"绑定银行卡" color:kMainColor imgName:@"back_white"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}




- (IBAction)sendCode:(id)sender {
    //发送验证码
    if (_phone.text.length != 11) {
        return [self.view Message:@"请输入正确的手机号码" HiddenAfterDelay:0.8];
    }
    
    
    [_getCodeBtn startCountDownTimer];
}



- (void)setUI{
    _cardNumber.borderStyle = UITextBorderStyleNone;
    _userName.borderStyle = UITextBorderStyleNone;
    _IDcard.borderStyle = UITextBorderStyleNone;
    _phone.borderStyle = UITextBorderStyleNone;
    _code.borderStyle = UITextBorderStyleNone;
    
    _bindBtn.layer.cornerRadius = 5;
    _bindBtn.layer.masksToBounds = YES;
    _getCodeBtn.layer.masksToBounds = YES;
    _getCodeBtn.layer.cornerRadius = 3;
    
    _getCodeBtn.interval = 1;
    _getCodeBtn.countDown = 59;
    _getCodeBtn.themeStr = @"获取验证码";
    [_getCodeBtn setDisableBackgroundColour:[UIColor colorWithHex:0x999999 alpha:1.0f]];
}


- (IBAction)bindClick:(id)sender {
    
    if (![TXUtilsString checkCardNo:_cardNumber.text]) {
        return [self.view Message:@"请输入正确的银行卡号" HiddenAfterDelay:0.8];
    }
    if ([TXUtilsString isBlankString:_cardNumber.text]) {
        return [self.view Message:@"请输入银行卡号" HiddenAfterDelay:0.8];
    }
    if ([TXUtilsString isBlankString:_userName.text]) {
        return [self.view Message:@"请输入姓名" HiddenAfterDelay:0.8];
    }
    if (![TXUtilsString validateIdentityCard:_IDcard.text]) {
        return [self.view Message:@"请输入正确的身份证号" HiddenAfterDelay:0.8];
    }
    if (_phone.text.length != 11) {
        return [self.view Message:@"请输入正确的手机号码" HiddenAfterDelay:0.8];
    }
    
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosBorrow/bindingCard" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],@"uname":_userName.text,@"card_no":_cardNumber.text,@"phone":_phone.text,@"id_no":_IDcard.text,@"name":_cardName.text} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _callBack();
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 10 && textField.text.length > 0) {
        [self.view loadingOnAnyView];
        [HYBNetworking postWithUrl:@"IosBorrow/getCardName" refreshCache:NO params:@{@"card_no":textField.text} success:^(id response) {
            SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
            if (state == SESSIONSUCCESS) {
                _cardName.text = response[@"data"];
            }
        } fail:^(NSError *error) {
            [self.view removeAnyView];
        }];
    }
    return YES;
}


@end
