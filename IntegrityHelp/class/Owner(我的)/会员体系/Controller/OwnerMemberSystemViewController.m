//
//  OwnerMemberSystemViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/30.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerMemberSystemViewController.h"
#import "MemberSystem.h"
#import "memberInfo.h"
#import "OwnerMoreMemberViewController.h"
#import "OnerInfoViewController.h"

@interface OwnerMemberSystemViewController ()

@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) MemberSystem *memberSystemModel;
@property(nonatomic,strong) UIView *grayView;

@end

@implementation OwnerMemberSystemViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initnavi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setIntroduce];
    [self downloadDataFromServer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"detailDismiss" object:nil];;
}


- (void)initnavi{
    [self initNav:@"会员体系" color:kMainColor imgName:@"back_white"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
}

- (void)rightAction{
    OwnerMoreMemberViewController *moreVC = [[OwnerMoreMemberViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}


- (void)downloadDataFromServer{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/memberTree" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]} success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSError *error;
            _memberSystemModel = [[MemberSystem alloc] initWithDictionary:response error:&error];
            if (!error) {
                [self setUI];
            }
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}


- (void)setIntroduce{
    NSArray *corlorArr = @[kMainColor,RGB(251, 170, 104),RGB(83, 192, 85)];
    NSArray *nameArr = @[@"我",@"我的推荐人",@"推荐人的推荐人"];
    for (int i = 0; i < 3; i ++) {
        [self.view addSubview:({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, i * 30 + 40, 15, 15)];
            view.backgroundColor = corlorArr[i];
            view;
        })];
        
        [self.view addSubview:({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, i * 30 + 38, 150, 20)];
            label.textColor = [UIColor colorWithHex:0x333333];
            label.text = nameArr[i];
            label;
        })];
    }
}



- (void)setUI{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        double rA = 80;
        double size = 30;
        double startXA = self.view.center.x;
        double startYA = self.view.center.y;
        
        double r = 3 *rA / 4;
        double startX = [self judgeCirclePointX:startXA r:size + 3*rA/4 range:270.0];
        double startY = [self judgeCirclePointY:startYA r:size + 3*rA/4 range:90.0];
    
        //2级
        if (_memberSystemModel.data.count > 0) {
            _type = @"2";
            if ([_memberSystemModel.data[0] son].count > 0) {
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:270], [self judgeCirclePointY:startY r:size + 3*r/4 range:90]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[0] son][0] Face]) tag:5];
            }
            if ([_memberSystemModel.data[0] son].count > 1){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:190], [self judgeCirclePointY:startY r:size + 3*r/4 range:10]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[0] son][1] Face]) tag:6];
            }
            if ([_memberSystemModel.data[0] son].count > 2){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:-10], [self judgeCirclePointY:startY r:size + 3*r/4 range:10]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[0] son][2] Face]) tag:7];
            }
            _type = @"1";
            //1级
            [self createCircle:CGRectMake(0, 0, 3*rA/4, 3*rA/4) point:CGPointMake([self judgeCirclePointX:startXA r:size + 3*rA/4 range:270], [self judgeCirclePointY:startYA r:size + 3*rA/4 range:90]) ponintC:CGPointMake(startXA, startYA) imgName:imageUrl3([_memberSystemModel.data[0] Face]) tag:2];
        }
        if (_memberSystemModel.data.count > 1){
            //2级
            _type = @"2";
            startX = [self judgeCirclePointX:startXA r:size + 3*rA/4 range:150];
            startY = [self judgeCirclePointY:startYA r:size + 3*rA/4 range:-30];
            if ([_memberSystemModel.data[1] son].count > 0) {
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:230], [self judgeCirclePointY:startY r:size + 3*r/4 range:50]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[1] son][0] Face]) tag:8];
            }
            if ([_memberSystemModel.data[1] son].count > 1){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:150], [self judgeCirclePointY:startY r:size + 3*r/4 range:-30]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[1] son][1] Face]) tag:9];
            }
            if ([_memberSystemModel.data[1] son].count > 2){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:70], [self judgeCirclePointY:startY r:size + 3*r/4 range:-110]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[1] son][2] Face]) tag:10];
            }
            _type = @"1";
            [self createCircle:CGRectMake(0, 0, 3*rA/4, 3*rA/4) point:CGPointMake([self judgeCirclePointX:startXA r:size + 3*rA/4 range:150], [self judgeCirclePointY:startYA r:size + 3*rA/4 range:-30]) ponintC:CGPointMake(startXA, startYA) imgName:imageUrl3([_memberSystemModel.data[1] Face]) tag:3];
        }
        if (_memberSystemModel.data.count > 2){
            //2级
            _type = @"2";
            startX = [self judgeCirclePointX:startXA r:size + 3*rA/4 range:30];
            startY = [self judgeCirclePointY:startYA r:size + 3*rA/4 range:210];
            if ([_memberSystemModel.data[2] son].count > 0) {
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:310], [self judgeCirclePointY:startY r:size + 3*r/4 range:130]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[2] son][0] Face]) tag:11];
            }
            if ([_memberSystemModel.data[2] son].count > 1){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:110], [self judgeCirclePointY:startY r:size + 3*r/4 range:-70]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[1] son][1] Face]) tag:12];
            }
            if ([_memberSystemModel.data[2] son].count > 2){
                [self createCircle:CGRectMake(0, 0, 3*r/4, 3*r/4) point:CGPointMake([self judgeCirclePointX:startX r:size + 3*r/4 range:30], [self judgeCirclePointY:startY r:size + 3*r/4 range:210]) ponintC:CGPointMake(startX, startY) imgName:imageUrl3([[_memberSystemModel.data[1] son][2] Face]) tag:13];
            }
            _type = @"1";
            [self createCircle:CGRectMake(0, 0, 3*rA/4, 3*rA/4) point:CGPointMake([self judgeCirclePointX:startXA r:size + 3*rA/4 range:30], [self judgeCirclePointY:startYA r:size + 3*rA/4 range:210]) ponintC:CGPointMake(startXA, startYA) imgName:imageUrl3([_memberSystemModel.data[2] Face]) tag:4];
        }
        
        _type = @"0";
        [self createCircle:CGRectMake(0, 0, rA, rA) point:CGPointMake(startXA,startYA) ponintC:CGPointMake(startXA, startYA) imgName:imageUrl3(_memberSystemModel.my.Face) tag:1];
    });
    
    if (!_grayView) {
        [self.view addSubview:({
            _grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _grayView.backgroundColor = [UIColor blackColor];
            _grayView.alpha = 0;
            _grayView;
        })];
    }

}




// 计算坐标X
- (double )judgeCirclePointX:(double )x r:(double)r range:(double)range{
    double result = x + r * cos((range * M_PI)/180);
    return result;
}

// 计算坐标Y
- (double )judgeCirclePointY:(double )y r:(double)r range:(double)range{
    double result = y + r * sin((range * M_PI)/180);
    return result;
}




// 画圆
- (void)createCircle:(CGRect )rect point:(CGPoint )point ponintC:(CGPoint )ponintC imgName:(NSString *)imgName tag:(NSInteger )tag{
    [self creatLine:ponintC point:point];
    [self.view addSubview:({
        UIImageView *circleFavicon = [[UIImageView alloc] initWithFrame:rect];
        [circleFavicon sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"placeholder_person"]];
        circleFavicon.tag = 1000 + tag;
        circleFavicon.center = point;
        [self circleFaviconFromCALayer:circleFavicon];
        circleFavicon;
    })];
    
    [self.view addSubview:({
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = rect;
        btn.center = point;
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = tag;
        [btn addTarget:self action:@selector(shouDetailInfo:) forControlEvents:(UIControlEventTouchUpInside)];
        btn;
    })];
}




- (void)creatLine:(CGPoint)pointS point:(CGPoint)pointE{
    //创建路径
    UIBezierPath *linePath = [UIBezierPath new];
    
    //起点
    [linePath moveToPoint:CGPointMake(pointS.x, pointS.y)];
    
    //添加其他点
    [linePath addLineToPoint:CGPointMake(pointE.x, pointE.y)];
    
    //设施路径画布
    CAShapeLayer *lineShape = [CAShapeLayer new];
//    lineShape.frame = self.view.frame;
    
    //宽度
    lineShape.lineWidth = 2;
//    
//    //线条之间点的样式
//    lineShape.lineJoin = kCALineJoinMiter;
//    
//    //线条结尾的样式
//    lineShape.lineCap = kCALineCapSquare;
//    
    //路径颜色
    lineShape.strokeColor = [UIColor redColor].CGColor;
    
    //获取贝塞尔曲线的路径
    lineShape.path = linePath.CGPath;
    
    //填充色
    lineShape.fillColor = [UIColor clearColor].CGColor;

    
    
    //把绘制的图放到layer上
    [self.view.layer addSublayer:lineShape];
}


- (void)circleFaviconFromCALayer:(UIImageView *)imageView{
    
    imageView.layer.masksToBounds = YES;
    
    imageView.layer.cornerRadius = imageView.bounds.size.width * 0.5;
    
    imageView.layer.borderWidth = 2;
    
    if ([_type isEqualToString:@"0"]) {
        
        imageView.layer.borderColor = kMainColor.CGColor;
        
    }else if ([_type isEqualToString:@"1"]){
        
        imageView.layer.borderColor = RGB(251, 170, 104).CGColor;
    }else{
        imageView.layer.borderColor = RGB(83, 192, 85).CGColor;
    }
}



- (void)shouDetailInfo:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
//            [self loadMemberInfo:_memberSystemModel.my.Name icon:imageUrl3(_memberSystemModel.my.Face) telphone:_memberSystemModel.my.Tel gener:_memberSystemModel.my.Id age:@"18岁" type:@"计算机"];
        }
            break;
        case 2:{
            [self loadMemberInfo:[_memberSystemModel.data[0] Name] icon:imageUrl3([_memberSystemModel.data[0] Face]) telphone:_memberSystemModel.my.Tel gener:[_memberSystemModel.data[0] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 3:{
            [self loadMemberInfo:[_memberSystemModel.data[1] Name] icon:imageUrl3([_memberSystemModel.data[1] Face]) telphone:_memberSystemModel.my.Tel gener:[_memberSystemModel.data[1] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 4:{
            [self loadMemberInfo:[_memberSystemModel.data[2] Name] icon:imageUrl3([_memberSystemModel.data[2] Face]) telphone:_memberSystemModel.my.Tel gener:[_memberSystemModel.data[2] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 5:{
            [self loadMemberInfo:[[_memberSystemModel.data[0] son][0] Name] icon:imageUrl3([[_memberSystemModel.data[0] son][0] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[0] son][0] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 6:{
            [self loadMemberInfo:[[_memberSystemModel.data[0] son][1] Name] icon:imageUrl3([[_memberSystemModel.data[0] son][1] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[0] son][1] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 7:{
            [self loadMemberInfo:[[_memberSystemModel.data[0] son][2] Name] icon:imageUrl3([[_memberSystemModel.data[0] son][2] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[0] son][2] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 8:{
            [self loadMemberInfo:[[_memberSystemModel.data[1] son][0] Name] icon:imageUrl3([[_memberSystemModel.data[1] son][0] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[1] son][0] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 9:{
            [self loadMemberInfo:[[_memberSystemModel.data[1] son][1] Name] icon:imageUrl3([[_memberSystemModel.data[1] son][1] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[1] son][1] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 10:{
           [self loadMemberInfo:[[_memberSystemModel.data[1] son][2] Name] icon:imageUrl3([[_memberSystemModel.data[1] son][2] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[1] son][2] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 11:{
            [self loadMemberInfo:[[_memberSystemModel.data[2] son][0] Name] icon:imageUrl3([[_memberSystemModel.data[2] son][0] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[2] son][0] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 12:{
            [self loadMemberInfo:[[_memberSystemModel.data[2] son][1] Name] icon:imageUrl3([[_memberSystemModel.data[2] son][1] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[2] son][1] Id] age:@"18岁" type:@"计算机"];
        }
            break;
        case 13:{
            [self loadMemberInfo:[[_memberSystemModel.data[2] son][2] Name] icon:imageUrl3([[_memberSystemModel.data[2] son][2] Face]) telphone:_memberSystemModel.my.Tel gener:[[_memberSystemModel.data[2] son][2] Id] age:@"18岁" type:@"计算机"];
            }
            break;
        default:
            break;
    }
}

- (void)loadMemberInfo:(NSString *)name icon:(NSString *)icon telphone:(NSString *)telphone gener:(NSString *)gender age:(NSString *)age type:(NSString *)type{
//    memberInfo *memberView;
//    [self.view addSubview:({
//        memberView = [[[NSBundle mainBundle] loadNibNamed:@"memberInfo" owner:nil options:nil] firstObject];
//        [memberView configureWithName:name icon:icon telphone:telphone gener:gender age:age type:type];
//        
//        memberView.frame = CGRectMake(0, 0, ScreenW * 0.8, 300);
//        memberView.center = CGPointMake(ScreenW/2, -ScreenH/2);
//        memberView.alpha = 0;
//        memberView.tag = 200;
//        memberView;
//    })];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        memberView.center = CGPointMake(ScreenW/2, ScreenH/2 -30);
//        _grayView.alpha = 0.6;
//        memberView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            memberView.center = CGPointMake(ScreenW/2, ScreenH/2 - 90);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                memberView.center = CGPointMake(ScreenW/2, ScreenH/2 - 60);
//            } completion:nil];
//        }];
//    }];
    OnerInfoViewController *infoVC = [[OnerInfoViewController alloc] init];
    infoVC.oid = gender;
    [self.navigationController pushViewController:infoVC animated:YES];
}


- (void)dismiss{
    UIView *view = [self.view viewWithTag:200];
    [UIView animateWithDuration:0.3 animations:^{
        view.center = CGPointMake(ScreenW/2, -ScreenH/2);
        view.alpha = 0;
        _grayView.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"detailDismiss"];
}

@end
