//
//  HeaderInfoViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HeaderInfoViewController.h"

@interface HeaderInfoViewController ()
@property (strong, nonatomic) SelectOnePicture *OnePicture;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HeaderInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"owner_header"]];
}


- (void)initnavi{
    [self initNav:@"个人头像" color:kWhite imgName:@"back_black"];
    [self rightTitle:@"···"];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}


- (void)rightAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *canclel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    WS(weakSelf)
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"从相册选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf changeHeadImg];
    }];
    UIAlertAction *camera2 = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf changeHeadImg];
    }];
    [alert addAction:canclel];
    [alert addAction:camera];
    [alert addAction:camera2];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)changeHeadImg{
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
    WS(weakSelf)
    [_OnePicture toSelectImage:^(NSData *imageData) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"post_disappear"  object:nil];
        NSData *data = [self resetSizeOfImageData:[UIImage imageWithData:imageData] maxSize:10];
        NSString *imgDataBase64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [weakSelf.view loadingOnAnyView];
        [HYBNetworking postWithUrl:@"IosIndex/setFace" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"],@"u_pwd":[Utils getValueForKey:@"pwdMd5"],@"type":@"jpg",@"face":imgDataBase64} success:^(id response) {
            SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
            if (state == SESSIONSUCCESS) {
                weakSelf.callBack(imageUrl(response[@"data"]));
                [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl(response[@"data"])] placeholderImage:[UIImage imageNamed:@""]];
            }
        } fail:^(NSError *error) {
            [weakSelf.view removeAnyView];
        }];
    }];
}

- (NSData *)resetSizeOfImageData:(UIImage *)image maxSize:(NSInteger )size{
    
    NSData *finallImageData = UIImageJPEGRepresentation(image, 0.35);
    NSInteger sizeOrigin = finallImageData.length;
    NSInteger sizeOriginKB = sizeOrigin / 1024;
    CGFloat num = 0.35;
    while (sizeOriginKB <= size) {
        num = num - 0.1;
        if (num < 0) {
            break;
        }
        finallImageData = UIImageJPEGRepresentation(image, num);
    }
    return finallImageData;
}





@end
