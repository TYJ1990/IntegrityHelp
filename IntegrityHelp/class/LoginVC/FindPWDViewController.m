//
//  FindPWDViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/24.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FindPWDViewController.h"

@interface FindPWDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet XFCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *PWDTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF2;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FindPWDViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}


- (void)initnavi{
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    [self initNav:@"找回密码" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)setUI{
    _phone.borderStyle = UITextBorderStyleNone;
    _codeTF.borderStyle = UITextBorderStyleNone;
    _PWDTF.borderStyle = UITextBorderStyleNone;
    _pwdTF2.borderStyle = UITextBorderStyleNone;
    _getCodeBtn.layer.cornerRadius = 3;
    _getCodeBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 10;
    _sureBtn.layer.masksToBounds = YES;
    _getCodeBtn.interval = 1;
    _getCodeBtn.countDown = 59;
    _getCodeBtn.themeStr = @"获取验证码";
    [_getCodeBtn setDisableBackgroundColour:[UIColor colorWithHex:0x999999 alpha:1.0f]];
}



- (IBAction)sendCode:(id)sender {
    [_getCodeBtn startCountDownTimer];
    
}


- (IBAction)sureClick:(id)sender {
    
}

@end
