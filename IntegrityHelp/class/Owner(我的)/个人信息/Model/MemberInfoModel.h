//
//  MemberInfoModel.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/6.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MemberInfoModel : JSONModel

@property (nonatomic ,strong) NSString<Optional> *Borntime;
@property (nonatomic ,strong) NSString<Optional> *Content;
@property (nonatomic ,strong) NSString<Optional> *Email;
@property (nonatomic ,strong) NSString<Optional> *Id;
@property (nonatomic ,strong) NSString<Optional> *Isshow;
@property (nonatomic ,strong) NSString<Optional> *Job;
@property (nonatomic ,strong) NSString<Optional> *Tel;
@property (nonatomic ,strong) NSString<Optional> *Uid;
@property (nonatomic ,strong) NSString<Optional> *Updatetime;
@property (nonatomic ,strong) NSString<Optional> *Vocation;
@property (nonatomic ,strong) NSString<Optional> *Yearpay;
@property (nonatomic ,strong) NSString<Optional> *job_name;
@property (nonatomic ,strong) NSString<Optional> *yearpay_name;
@property (nonatomic ,strong) NSString<Optional> *Idcard;
@property (nonatomic ,strong) NSString<Optional> *name;
@property (nonatomic ,strong) NSString<Optional> *face;

@end
