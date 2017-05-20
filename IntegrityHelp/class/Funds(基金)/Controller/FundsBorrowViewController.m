//
//  FundsBorrowViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/18.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "FundsBorrowViewController.h"
#import "FundPeriodViewController.h"
#import "FundCardViewController.h"

@interface FundsBorrowViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adHeigh;
@property (weak, nonatomic) IBOutlet UITextField *borrowTF;
@property (weak, nonatomic) IBOutlet UILabel *time_one;
@property (weak, nonatomic) IBOutlet UILabel *time_two;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *distrubuteTextView;
@property (weak, nonatomic) IBOutlet UIButton *image_one;
@property (weak, nonatomic) IBOutlet UIButton *image_two;
@property (weak, nonatomic) IBOutlet UIButton *image_three;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextTopHeight;
@property (weak, nonatomic) IBOutlet UILabel *title_placeholder;
@property (weak, nonatomic) IBOutlet UILabel *distrubution_placeholder;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn1;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn3;
@property (strong,nonatomic) SelectOnePicture *OnePicture;
@property (nonatomic,strong) NSString *base64imageString1;
@property (nonatomic,strong) NSString *base64imageString2;
@property (nonatomic,strong) NSString *base64imageString3;

@end

@implementation FundsBorrowViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}


- (void)initnavi{
    [self initNav:@"我要借款" color:[UIColor whiteColor] imgName:@"back_black"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)setUI{
    _borrowTF.borderStyle = UITextBorderStyleNone;
    _borrowTF.keyboardType = UIKeyboardTypeNumberPad;
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
}




- (IBAction)closeAD:(id)sender {
    _adHeigh.constant = 0;
    _nextTopHeight.constant += 40;
}

- (IBAction)selectTime:(id)sender {
    WS(weakSelf)
    [_borrowTF resignFirstResponder];
    [_titleTextView resignFirstResponder];
    [_distrubuteTextView resignFirstResponder];
    FundPeriodViewController *periodVC = [[FundPeriodViewController alloc] init];
    periodVC.callBack = ^(NSString *name){
        weakSelf.time_one.text = name;
        [weakSelf getEnabled];
    };
    [self.navigationController pushViewController:periodVC animated:YES];
}

- (IBAction)selectTime_two:(id)sender {
    WS(weakSelf)
    [_borrowTF resignFirstResponder];
    [_titleTextView resignFirstResponder];
    [_distrubuteTextView resignFirstResponder];
    FundPeriodViewController *periodVC = [[FundPeriodViewController alloc] init];
    periodVC.callBack = ^(NSString *name){
        weakSelf.time_two.text = name;
        [weakSelf getEnabled];
    };
    [self.navigationController pushViewController:periodVC animated:YES];
}

- (IBAction)addImage:(id)sender {
    UIButton *btn = sender;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {  // 没权限，提醒用户开启权限
        BaseAlertControler *base = [[BaseAlertControler alloc]init];
        UIAlertController *alert = [base alertmessage:@"前往设置" Title:@"请先允许信扶访问你的相册及相机功能，前往设置？" andBlock:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // 调用相册
    if (!_OnePicture) {
        _OnePicture = [[SelectOnePicture alloc]initWithFrame:CGRectZero];
        _OnePicture.ratioOfWidthAndHeight = 1;
        _OnePicture.enableCutImg  =YES;
        _OnePicture.superController = self;
    }
    // 点击相册的回调
    [_OnePicture toSelectImage:^(NSData *imageData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post_disappear"  object:nil];
        NSData *data = [Utils resetSizeOfImageData:[UIImage imageWithData:imageData] maxSize:10];
        [btn setImage:[UIImage imageWithData:data] forState:(UIControlStateNormal)];
        if (btn.tag == 1) {
            _base64imageString1 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            _deleteBtn1.hidden = NO;
        }else if (btn.tag == 2){
            _base64imageString2 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            _deleteBtn2.hidden = NO;
        }else{
            _base64imageString3 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            _deleteBtn3.hidden = NO;
        }
    }];
}

- (IBAction)deleteImg:(id)sender {
    UIButton *btn = sender;
    btn.hidden = YES;
    if (btn.tag == 1000) {
        [_image_one setImage:[UIImage imageNamed:@"fund_add"] forState:(UIControlStateNormal)];
        _base64imageString1 = @"";
    }else if (btn.tag == 2000){
        [_image_two setImage:[UIImage imageNamed:@"fund_add"] forState:(UIControlStateNormal)];
        _base64imageString2 = @"";
    }else{
        [_image_three setImage:[UIImage imageNamed:@"fund_add"] forState:(UIControlStateNormal)];
        _base64imageString3 = @"";
    }
}


- (IBAction)nextClick:(id)sender {
    NSMutableDictionary *parDic = [@{@"u_id":[Utils getInfoWithKey:@"u_id"],@"month":_time_one.text,@"rmonth":_time_two.text,@"num":_borrowTF.text,@"title":_titleTextView.text,@"content":_distrubuteTextView.text,@"pic1":_base64imageString1.length>0?_base64imageString1:@"",@"pic2":_base64imageString2.length>0?_base64imageString2:@"",@"pic3":_base64imageString3.length>0?_base64imageString3:@""} mutableCopy];
    FundCardViewController *cardVC = [[FundCardViewController alloc] init];
    cardVC.dic = parDic;
    [self.navigationController pushViewController:cardVC animated:YES];
}

- (void)getEnabled{
    if (_borrowTF.text.length > 0 && _time_one.text.length > 0 && _time_two.text.length > 0 && _titleTextView.text.length > 0 && _distrubuteTextView.text.length > 0) {
        _nextBtn.enabled = YES;
        _nextBtn.backgroundColor = kMainColor;
    }else{
        _nextBtn.enabled = NO;
        _nextBtn.backgroundColor = kGrayBtn;
    }
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.tag == 100) {
        _title_placeholder.hidden = YES;
    }else{
        _distrubution_placeholder.hidden = YES;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_titleTextView.text.length == 0) {
        _title_placeholder.hidden = NO;
    }
    if(_distrubuteTextView.text.length == 0){
        _distrubution_placeholder.hidden = NO;
    }
    [self getEnabled];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.tag == 100) {
        if (textView.text.length <= 60) {
            _count.text = [NSString stringWithFormat:@"%ld/60",textView.text.length];
        }else{
            textView.text = [textView.text substringToIndex:60];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self getEnabled];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_borrowTF resignFirstResponder];
    [_titleTextView resignFirstResponder];
    [_distrubuteTextView resignFirstResponder];
}

@end
