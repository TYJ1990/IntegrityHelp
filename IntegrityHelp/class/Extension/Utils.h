//
//  Utils.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/26.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  会话状态
 */
typedef NS_ENUM(NSUInteger,SESSIONSTATE) {
    /**
     *  会话成功
     */
    SESSIONSUCCESS,
    /**
     *  会话无效
     */
    SESSIONINVALID,
    /**
     *  会话错误
     */
    SESSIONERROR,
    /**
     *  未知异常
     */
    SESSIONNONE,
};

@interface Utils : NSObject

/**
 *  获取数据返回状态
 *
 *  @param responDic 数据请求返回的字典
 *  @param msg       显示提示内容
 *
 *  @return 数据请求状态
 */
+ (SESSIONSTATE) getStatus:(NSDictionary *)responDic View:(UIViewController *)alterView showSuccessMsg:(BOOL)ShowSuccess showErrorMsg:(BOOL)showError;

+(void)setValue:(id)value key:(NSString *)key;
+(id)getValueForKey:(NSString *)key;
+ (void)removeAllValue;

+ (void)conserveInfo:(NSString *)info key:(NSString *)key number:(NSInteger )number;
+ (NSMutableArray *)getInfoWithKey:(NSString *)key;

+ (NSString *)TransformTimestampWith:(NSString *)dateString dateDormate:(NSString *)formate;

+(NSString *)getStatus:(NSInteger )number;

+ (NSString *)getStatusImg:(NSInteger)number;

+ (NSData *)resetSizeOfImageData:(UIImage *)image maxSize:(NSInteger )size;



@end
