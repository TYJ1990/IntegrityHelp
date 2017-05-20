//
//  ItemModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/6.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class ItemModelList;
@protocol ItemModelList

@end

@interface ItemModel : JSONModel

@property(nonatomic,strong) NSArray<ItemModelList,Optional> *data;

@end


@interface ItemModelList : JSONModel

@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Name;

@end
