//
//  OwnerPointModel.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "OwnerPointModel.h"

@implementation OwnerPointModel

@end


@implementation OwnerPointListModel
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"face":@"faceKey"}];
}

@end

