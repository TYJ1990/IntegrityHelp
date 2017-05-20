//
//  OwnerQdViewController.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerQdViewController.h"
#import <JTCalendar/JTCalendar.h>

@interface OwnerQdViewController ()<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet JTVerticalCalendarView *calendarContentView;
@property(nonatomic,strong) NSMutableDictionary *eventsByDate;
@property(nonatomic,strong) NSDate *dateSelected;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *yearLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgheight;
@property(nonatomic,strong) NSMutableArray *dateArray;
@property (weak, nonatomic) IBOutlet UILabel *signedCount;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation OwnerQdViewController

- (void)viewWillAppear:(BOOL)animated{
    [self initnavi];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self loadData];
}



- (void)initnavi{
    [self initNav:@"签到" color:[UIColor clearColor] imgName:@"back_white"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:kWhite,NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName, nil];
    self.navigationController.navigationBar.translucent = YES;
}


- (void)setUI{
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    [self createRandomEvents];
    _signBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _signBtn.layer.borderWidth = 1;
    _calendarContentView.scrollEnabled = NO;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    
    _bgheight.constant = ScreenH;
    _dateArray = [NSMutableArray array];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"1 .一个月内签到20天可获得100分"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 9)];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(254, 160, 60) range:NSMakeRange(9, 2)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(11, 4)];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(254, 160, 60) range:NSMakeRange(15, 3)];
    _tipLabel.attributedText = string;
}



- (void)loadData{
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/signMonth" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]}    success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:NO showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            if (response[@"data"] != [NSNull null]) {
                _dateArray = [response[@"data"] mutableCopy];
            }
            [_calendarManager reload];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}






#pragma mark - CalendarManager delegate
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if ([_dateArray isKindOfClass:[NSArray class]]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已经签到%ld天",_dateArray.count]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 4)];
        [string addAttribute:NSForegroundColorAttributeName value:RGB(254, 160, 60) range:NSMakeRange(4, string.length - 5)];
        _signedCount.attributedText = string;
    }else{
        _signedCount.text = @"已经签到0天";
        _dateArray = [NSMutableArray array];
    }
    
    dayView.hidden = NO;
    NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    for (NSString *value in _dateArray) {
        NSString *keyStr = [self TransformTimestampWith:value dateDormate:@"dd-MM-yyyy"];
        if ([keyStr isEqualToString:key]) {
             dayView.circleView.hidden = NO;
        }
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    
}

#pragma mark - Fake data
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}



- (NSString *)TransformTimestampWith:(NSString *)dateString dateDormate:(NSString *)formate
{
    NSTimeInterval interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:formate];
    NSString *timestr =  [objDateformat stringFromDate: date];
    return timestr;
}




- (IBAction)signIn:(id)sender {
    [self.view loadingOnAnyView];
    [HYBNetworking getWithUrl:@"IosIndex/sign" refreshCache:NO params:@{@"u_id":[Utils getValueForKey:@"u_id"]}    success:^(id response) {
        SESSIONSTATE state = [Utils getStatus:response View:self showSuccessMsg:YES showErrorMsg:YES];
        if (state == SESSIONSUCCESS) {
            NSString *key = [NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]];
            [_dateArray addObject:key];
            [_calendarManager reload];
        }
    } fail:^(NSError *error) {
        [self.view removeAnyView];
    }];
}

@end
