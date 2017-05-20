//
//  MemberSystem.h
//  IntegrityHelp
//
//  Created by 小凡 on 2017/5/2.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MemberSystem_first,MemberSystem_second,MemberSystem_my;

@protocol MemberSystem_first

@end

@protocol MemberSystem_second

@end

@protocol MemberSystem_my

@end



@interface MemberSystem : JSONModel

@property(nonatomic,strong) NSArray<Optional,MemberSystem_first> *data;
@property(nonatomic,strong) MemberSystem_my<Optional> *my;

@end

@interface MemberSystem_first : JSONModel

@property(nonatomic,strong) NSString<Optional> *Face;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Name;
@property(nonatomic,strong) NSString<Optional> *Pid;
@property(nonatomic,strong) NSArray<MemberSystem_second,Optional> *son;

@end

@interface MemberSystem_second : JSONModel

@property(nonatomic,strong) NSString<Optional> *Face;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Name;
@property(nonatomic,strong) NSString<Optional> *Pid;

@end


@interface MemberSystem_my : JSONModel

@property(nonatomic,strong) NSString<Optional> *Addtime;
@property(nonatomic,strong) NSString<Optional> *Face;
@property(nonatomic,strong) NSString<Optional> *Id;
@property(nonatomic,strong) NSString<Optional> *Isshow;
@property(nonatomic,strong) NSString<Optional> *Name;
@property(nonatomic,strong) NSString<Optional> *Phone;
@property(nonatomic,strong) NSString<Optional> *Pid;
@property(nonatomic,strong) NSString<Optional> *Pwd;
@property(nonatomic,strong) NSString<Optional> *Qrcode;
@property(nonatomic,strong) NSString<Optional> *Sex;
@property(nonatomic,strong) NSString<Optional> *Tel;
@property(nonatomic,strong) NSString<Optional> *Ty;
@property(nonatomic,strong) NSString<Optional> *Updatetime;
@property(nonatomic,strong) NSString<Optional> *Userno;

@end
