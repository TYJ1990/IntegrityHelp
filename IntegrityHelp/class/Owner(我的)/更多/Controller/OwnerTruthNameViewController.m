//
//  OwnerTruthNameViewController.m
//  
//
//  Created by 小凡 on 2017/4/28.
//
//

#import "OwnerTruthNameViewController.h"

@interface OwnerTruthNameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *realNameImg1;
@property (weak, nonatomic) IBOutlet UIImageView *realNameImg2;
@property (weak, nonatomic) IBOutlet UIButton *sureUploadBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgview2;
@property (strong, nonatomic) SelectOnePicture *OnePicture;
@property(nonatomic,strong) NSString *imgDataBase64_front;
@property(nonatomic,strong) NSString *imgDataBase64_verso;
@property(nonatomic,strong)UITapGestureRecognizer *tap1;
@property(nonatomic,strong)UITapGestureRecognizer *tap2;
@property (weak, nonatomic) IBOutlet UILabel *checkingType;

@end

@implementation OwnerTruthNameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf9f9f9];
    
    [self loadData];
    [self addGest];
}


- (void)initnavi{
    [self initNav:@"证件上传" color:[UIColor whiteColor] imgName:@"back_black"];
//    [self rightTitle:@"···"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请上传%@的身份证正反面照片",_name]];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(78, 140, 238) range:NSMakeRange(3, string.length - 12)];
    _tipLabel.attributedText = string;
    _bgview2.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
    _bgView1.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
}

- (void)addGest{
    _realNameImg1.userInteractionEnabled = YES;
    _realNameImg2.userInteractionEnabled = YES;
    _tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFrontImg:)];
    _tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFrontImg:)];
    [_realNameImg1 addGestureRecognizer:_tap1];
    [_realNameImg2 addGestureRecognizer:_tap2];
}




- (void)loadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/realNamePic" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:NO];
        if (state == SESSIONSUCCESS) {
            if (response[@"data"]) {
                if ([response[@"data"][@"Isshow"] integerValue] == 1) {
                    _checkingType.text = @"审核通过";
                    _sureUploadBtn.enabled = NO;
                    _sureUploadBtn.backgroundColor = RGB(212,213,214);
                    [_realNameImg1 removeGestureRecognizer:_tap1];
                    [_realNameImg2 removeGestureRecognizer:_tap2];
                    [_realNameImg1 sd_setImageWithURL:[NSURL URLWithString:imageUrl(response[@"data"][@"Pic1"])]];
                    [_realNameImg2 sd_setImageWithURL:[NSURL URLWithString:imageUrl(response[@"data"][@"Pic2"])]];
                }else if([response[@"data"][@"Isshow"] integerValue] == 2){
                     _checkingType.text = [NSString stringWithFormat:@"审核不通过：%@,请重新上传",response[@"data"][@"Content"]];
                }else{
                    _checkingType.text = @"审核中...";
                    [_realNameImg1 sd_setImageWithURL:[NSURL URLWithString:imageUrl(response[@"data"][@"Pic1"])]];
                    [_realNameImg2 sd_setImageWithURL:[NSURL URLWithString:imageUrl(response[@"data"][@"Pic2"])]];
                }
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}




- (void)addFrontImg:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
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
        _OnePicture.ratioOfWidthAndHeight = 490.0/275;
        _OnePicture.enableCutImg  =YES;
        _OnePicture.superController = self;
    }
    // 点击相册的回调
    [_OnePicture toSelectImage:^(NSData *imageData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post_disappear"  object:nil];
        NSData *data = [self resetSizeOfImageData:[UIImage imageWithData:imageData] maxSize:200];
        img.image = [UIImage imageWithData:data];
        if (img.tag == 10) {
            _imgDataBase64_front = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }else{
            _imgDataBase64_verso = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
    }];
}


- (IBAction)upLoadImg:(id)sender {
    
    if (!_imgDataBase64_front || !_imgDataBase64_verso) {
        [self.view Message:@"请添加照片" HiddenAfterDelay:1];
        return;
    }
    
    [self.view loadingOnAnyView];
    [HYBNetworking postWithUrl:@"IosIndex/realName" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"pic1":_imgDataBase64_front,@"pic2":_imgDataBase64_verso} success:^(id response) {
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






- (NSData *)resetSizeOfImageData:(UIImage *)image maxSize:(NSInteger )size{
    
    NSData *finallImageData = UIImageJPEGRepresentation(image, 1);
    NSInteger sizeOrigin = finallImageData.length;
    NSInteger sizeOriginKB = sizeOrigin / 1024;
    CGFloat num = 1;
    while (sizeOriginKB <= size) {
        num = num - 0.1;
        NSLog(@"%lf",num);
        if (num < 0) {
            break;
        }
        finallImageData = UIImageJPEGRepresentation(image, num);
    }
    return finallImageData;
}


@end
