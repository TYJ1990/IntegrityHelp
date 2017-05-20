//
//  Utils.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "Utils.h"

/**
 *  <#Description#>
 */
#define MSGKey @"message"
#define MSGType @"type"
#define MSGContent @"content"
#define SUCCESS @"success"
#define ERROR @"error"
#define INVALID @"session.invaild"

@implementation Utils



/**
 *  获取数据返回状态
 *
 *  @param responDic 数据请求返回的字典
 *
 *  @return 数据请求状态
 */
+ (SESSIONSTATE) getStatus:(NSDictionary *)responDic View:(UIViewController *)alterView showSuccessMsg:(BOOL)ShowSuccess showErrorMsg:(BOOL)showError
{
    [alterView.view removeAnyView];
    SESSIONSTATE state;
    NSString *msg = responDic[@"msg"];
    NSString *result =[responDic[@"result"] stringValue];
    if ([result isEqualToString:@"1"]) {
        state =  SESSIONSUCCESS;
        if (ShowSuccess) {
            [alterView.view Message:msg HiddenAfterDelay:1.0f];
        }
    }else{
        state =  SESSIONERROR;
        if (showError) {
            [alterView.view Message:msg HiddenAfterDelay:1.0f];
        }
    }
    return state;
}

+(void)setValue:(id)value key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

+ (id)getValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)removeAllValue{
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    }
}

/*存储*/
+ (void)conserveInfo:(NSString *)info key:(NSString *)key number:(NSInteger )number{
    NSMutableArray *searchHArr = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!searchHArr) {
        searchHArr = [NSMutableArray array];
    }
    
    NSMutableArray *newSearchArr = [NSMutableArray arrayWithArray:searchHArr];
    if ([newSearchArr containsObject:info]) {
        return;
    }
    [newSearchArr insertObject:info atIndex:0];
    
    if (searchHArr.count >= number) {
        [newSearchArr removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:newSearchArr forKey:key];
}

/*获取存储记录*/
+ (NSMutableArray *)getInfoWithKey:(NSString *)key{
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return array;
}



//将时间戳转换成字符串
+ (NSString *)TransformTimestampWith:(NSString *)dateString dateDormate:(NSString *)formate
{
    NSTimeInterval interval=[dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:formate];
    NSString *timestr =  [objDateformat stringFromDate: date];
    return timestr;
}

+ (NSString *)getStatus:(NSInteger)number{
    NSString *status = @"";
    switch (number) {
        case 0:
            return status = @"未审核";
            break;
        case 1:
            return status = @"审核中";
            break;
        case 2:
            return status = @"审核通过";
            break;
        case 3:
            return status = @"合作中";
            break;
        case 4:
            return status = @"合作完成";
            break;
        default:
            break;
    }
    return status;
}

+ (NSString *)getStatusImg:(NSInteger)number{
    NSString *status = @"";
    switch (number) {
        case 0:
            return status = @"help_status2";
            break;
        case 1:
            return status = @"help_status3";
            break;
        case 2:
            return status = @"help_status1";
            break;
        case 3:
            return status = @"help_status4";
            break;
        case 4:
            return status = @"help_status5";
            break;
        default:
            break;
    }
    return status;
}

+ (NSData *)resetSizeOfImageData:(UIImage *)image maxSize:(NSInteger )size{
    
    NSData *finallImageData = UIImageJPEGRepresentation(image, 0.5);
    NSInteger sizeOrigin = finallImageData.length;
    NSInteger sizeOriginKB = sizeOrigin / 1024;
    CGFloat num = 1;
    while (sizeOriginKB >= size) {
        num = num - 0.02;
        if (num < 0) {
            break;
        }
        finallImageData = UIImageJPEGRepresentation(image, num);
    }
    return finallImageData;
}



@end
