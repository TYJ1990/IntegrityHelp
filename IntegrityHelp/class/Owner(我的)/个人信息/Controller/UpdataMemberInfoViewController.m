//
//  UpdataMemberInfoViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/5.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "UpdataMemberInfoViewController.h"

@interface UpdataMemberInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *updata_type;
@property (weak, nonatomic) IBOutlet UITextField *updataTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UILabel *oldPwd;

@end

@implementation UpdataMemberInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)initnavi{
    [self initNav:_type color:[UIColor whiteColor] imgName:@"back_black"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)setUI{
    _updataTF.borderStyle = UITextBorderStyleNone;
    _updataTF.text = _content;
    _pwdTF.borderStyle = UITextBorderStyleNone;
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    
    _updata_type.text = _type;
    _updataTF.placeholder = [NSString stringWithFormat:@"请输入%@",_type];
    
    if ([_type isEqualToString:@"证件信息"]){
        _hiddenView.hidden = NO;
        _updataTF.placeholder = @"请输入身份证号码";
    }else if ([_type isEqualToString:@"个性签名"]){
        _hiddenView.hidden = NO;
    }else if ([_type isEqualToString:@"邮箱地址"]){
        _hiddenView.hidden = NO;
    }else if ([_type isEqualToString:@"岗位"]){
        _hiddenView.hidden = NO;
    }
    if ([_type isEqualToString:@"联系方式"]){
        _updataTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    if([_type isEqualToString:@"修改密码"]){
        _oldPwd.text = @"旧密码";
        _updata_type.text = @"新密码";
    }
}




- (IBAction)submit:(id)sender {
    [_updataTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
    NSString *url = @"IosIndex/saveInfo";
    NSString *key;
    NSDictionary *dic;
    if ([_type isEqualToString:@"姓名"]) {
        url = @"IosIndex/setName";
        key = @"name";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":_pwdTF.text ? _pwdTF.text : @"",key:_updataTF.text};
    }else if ([_type isEqualToString:@"联系方式"]){
        url = @"IosIndex/setPhone";
        key = @"phone";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":_pwdTF.text ? _pwdTF.text : @"",key:_updataTF.text};
    }else if ([_type isEqualToString:@"证件信息"]){
        if (![TXUtilsString validateIdentityCard:_updataTF.text]) {
            return [self.view Message:@"请输入正确的身份证号码" HiddenAfterDelay:1];
        }
        key = @"Idcard";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],key:_updataTF.text};
    }else if ([_type isEqualToString:@"个性签名"]){
        url = @"IosIndex/sendContent";
        key = @"content";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],key:_updataTF.text};
    }else if ([_type isEqualToString:@"邮箱地址"]){
        if (![TXUtilsString isValidateEmail:_updataTF.text]) {
            return [self.view Message:@"请输入正确的邮箱地址" HiddenAfterDelay:1];
        }
        key = @"email";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],key:_updataTF.text};
    }else if ([_type isEqualToString:@"岗位"]){
        key = @"vocation";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],key:_updataTF.text};
    }else if ([_type isEqualToString:@"修改密码"]){
        url = @"IosIndex/setPwd";
        dic = @{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":_pwdTF.text,@"pwd":_updataTF.text};
    }
    if (_updataTF.text.length < 1) {
        [self.view Message:[NSString stringWithFormat:@"请输入%@",_type] HiddenAfterDelay:1];
        return;
    }
    
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:url refreshCache:NO params:dic success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_type isEqualToString:@"修改密码"]) {
                    [Utils setValue:response[@"data"] key:@"pwdMd5"];
                    [Utils setValue:_updataTF.text key:@"pwd"];
                    _callBack(@"");
                }else{
                    _callBack(_updataTF.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];

    
}

@end
