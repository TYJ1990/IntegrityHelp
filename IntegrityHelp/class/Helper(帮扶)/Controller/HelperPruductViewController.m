//
//  HelperPruductViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/27.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "HelperPruductViewController.h"
#import "HelpTypeModel.h"
#import "SelectPictureView.h"

@interface HelperPruductViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UIButton *type;
@property (weak, nonatomic) IBOutlet UILabel *approver;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (strong, nonatomic) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *grayView;
@property (strong, nonatomic) SelectOnePicture *OnePicture;
@property(nonatomic,strong) NSString *imgDataBase64;
@property(nonatomic,strong) HelpTypeModel *typeModel;
@property(nonatomic,strong) NSString *typeID;
@property(nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopHeight;
@property(nonatomic,strong) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet SelectPictureView *pictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHeight;

@end

@implementation HelperPruductViewController

-(void)viewWillAppear:(BOOL)animated{
    [self initnavi];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadData];
}



- (void)initnavi{
    [self initNav:@"发布需求" color:kWhite imgName:@"back_black"];
//    [self rightTitle:@"邀请帮扶"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kDarkText,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:(UIControlStateNormal)];
}


- (void)setUI{
    _approver.text = [NSString stringWithFormat:@"%@ %@",[Utils getValueForKey:@"f_id_name"],[Utils getValueForKey:@"ff_id_name"]];
    _pictureView.getImageBlock = ^(NSMutableArray *imageArray){
        if (imageArray.count == 0) {
            _picViewHeight.constant = 0;
            _btnTopHeight.constant = 135;
        }else if (imageArray.count < 4){
            _picViewHeight.constant = ScreenW/4/1.33333;
            _btnTopHeight.constant = 135 - ScreenW/4/1.33333;
        }else{
            _picViewHeight.constant = ScreenW/2/1.33333 ;
            _btnTopHeight.constant = 50;
        }
        _photos = imageArray;
    };
    _pictureView.ratioOfWidthAndHeight = 1.33333;
    _pictureView.maxImageCount = 8;
}

- (void)loadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosProject/projectType" refreshCache:NO params:nil success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _typeModel = [[HelpTypeModel alloc] initWithDictionary:response error:&error];
            if (!error) {
                [_pickerView reloadAllComponents];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}



- (IBAction)selectType:(id)sender {
    [_textView resignFirstResponder];
    [_titleTF resignFirstResponder];
    [self.view addSubview:({
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH/2 - 32)];
        _grayView.backgroundColor = [UIColor blackColor];
        _grayView.alpha = 0;
        _grayView;
    })];
    
    [self.view addSubview:({
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenH/2 - 32 + ScreenH ,ScreenW , ScreenH/2 - 32)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = kWhite;
        [_pickerView selectRow:2 inComponent:0 animated:YES];
        _pickerView;
    })];
    
    UIButton *btn;
    [self.view addSubview:({
        btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"确定" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(selelctClick) forControlEvents:(UIControlEventTouchUpInside)];
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32 + ScreenH, 40, 30);
        btn.tag = 1000;
        btn.alpha = 0 ;
        btn;
    })];
    
    UIButton *btn2;
    [self.view addSubview:({
        btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn2 setTitle:@"取消" forState:(UIControlStateNormal)];
        [btn2 setTitleColor:[UIColor colorWithHex:0x333333] forState:(UIControlStateNormal)];
        btn2.frame = CGRectMake(15, ScreenH/2 - 32 + ScreenH, 40, 30);
        [btn2 addTarget:self action:@selector(cancelSelect) forControlEvents:(UIControlEventTouchUpInside)];
        btn2.tag = 2000;
        btn.alpha = 0 ;
        btn2;
    })];
    
    [UIView animateWithDuration:0.3 animations:^{
        _grayView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _pickerView.frame = CGRectMake(0, ScreenH/2 - 32 ,ScreenW , ScreenH/2 - 32);
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32, 40, 30);
        btn2.frame = CGRectMake(15, ScreenH/2 - 32, 40, 30);
        _grayView.alpha = 0.5;
        _pickerView.alpha = 1;
        btn.alpha = 1;
        btn2.alpha = 1;
    }];
}



- (void)cancelSelect{
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *btn = [self.view viewWithTag:1000];
        UIButton *btn2 = [self.view viewWithTag:1000];
        _grayView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
        _pickerView.frame = CGRectMake(0, ScreenH/2 - 32 + ScreenH,ScreenW , ScreenH/2 - 32);
        btn.frame = CGRectMake(ScreenW - 55, ScreenH/2 - 32 + ScreenH, 40, 30);
        btn2.frame = CGRectMake(15, ScreenH/2 - 32 + ScreenH, 40, 30);
        _grayView.alpha = 0;
        _pickerView.alpha = 0;
        btn.alpha = 0;
        btn2.alpha = 0;
    } completion:^(BOOL finished) {
        [_grayView removeFromSuperview];
        [_pickerView removeFromSuperview];
        UIButton *btn = [self.view viewWithTag:1000];
        [btn removeFromSuperview];
        UIButton *btn2 = [self.view viewWithTag:2000];
        [btn2 removeFromSuperview];
    }];
}

- (void)selelctClick{
    [self cancelSelect];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _typeModel.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_typeModel.data[row] Name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _index = row;
    [_type setTitle:[_typeModel.data[row] Name] forState:(UIControlStateNormal)];
    _typeID = [_typeModel.data[row] Id];
}




- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _placeHolder.hidden = YES;
    }else{
        _placeHolder.hidden = NO;
    }
}




- (IBAction)selectPic:(id)sender {
    _picViewHeight.constant = ScreenW/4/1.33333;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelSelect];
}

- (IBAction)submitInfo:(id)sender {
    if (_titleTF.text.length < 1) {
        [self.view Message:@"请输入主题名称" HiddenAfterDelay:1];
        return;
    }else if ([_type.titleLabel.text isEqualToString:@"项目合作"]){
        [self.view Message:@"请选择项目类型" HiddenAfterDelay:1];
        return;
    }else if (_textView.text.length < 1){
        [self.view Message:@"请输入项目描述" HiddenAfterDelay:1];
        return;
    }
    
    [self.view loadingOnAnyView];
    NSMutableDictionary *partDic = [@{@"u_id":[Utils getValueForKey:@"u_id"],@"typeselect":_typeID,@"title":_titleTF.text,@"content":_textView.text} mutableCopy];
    [partDic setValuesForKeysWithDictionary:[self getPicName]];
    
    [HYBNetworking postWithUrl:@"IosProject/create" refreshCache:NO params:partDic success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                _callBack();
            });
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


- (NSDictionary *)getPicName{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < _photos.count; i++) {
        NSString *key = [NSString stringWithFormat:@"pic%d",i+1];
        NSData *data = _photos[i][@"image"];
        NSData *imageData = [Utils resetSizeOfImageData:[UIImage imageWithData:data] maxSize:20];
        NSString *imgDataBase64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [dic setValue:imgDataBase64 forKey:key];
    }
    return dic;
}




@end
