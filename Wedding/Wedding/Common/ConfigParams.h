//
//  NSObject_ConfigParams.h
//  Wedding
//
//  Created by lgqyhm on 13-7-8.
//  Copyright (c) 2013年 lgqyhm. All rights reserved.
//  参数配置文件

//可以在项目中，定义任意的单例对象
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}

#define isJsonDictionaryHasKeyForString(jsonDic, key)   ([jsonDic jsonObjectForKey:key] && [[jsonDic jsonObjectForKey:key] isKindOfClass:[NSString class]] && [(NSString *)[jsonDic jsonObjectForKey:key] length] > 0)
#define isJsonDictionaryHasKeyForDictionary(jsonDic, key)   ([jsonDic jsonObjectForKey:key] && [[jsonDic jsonObjectForKey:key] isKindOfClass:[NSDictionary class]])
#define isJsonDictionaryHasKeyForArray(jsonDic, key)   ([jsonDic jsonObjectForKey:key] && [[jsonDic jsonObjectForKey:key] isKindOfClass:[NSArray class]])


//======================全局数据===============================

#define KFontDefault @"HelveticaNeue"
#define KNotSuppor  @"该设备不支持此功能"
#define KMsgDefault @"温馨提示"

#define KVersion    @"1.0"  //版本号
#define KMan        @"1"    //男
#define KWoman      @"0"    //女
#define KRomanticURL   @"http://42.96.170.168:8080/iRomantic/" //@"http://192.168.1.104:8080/iRomantic/"//
#define KUerID  @"userID"
#define KWeddingID   @"weddingID"

#define KWeddingData    @"Weddingdata"
#define kWedding        @"Wedding"
#define KPictures       @"Pictures"
#define KEnterprise     @"Enterprise"
#define KHotel          @"Hotel"
#define KInvitation     @"Invitation"

#define KEnduringLoginData      @"EnduringLoginData"
#define kLoginData              @"loginData"

#define KIsLogin                @"login"
#define KIsFirst                @"first"

#ifndef __OPTIMIZE__
#   define DLog(fmt, ...) {NSLog((@"\n%s [Line %d]\n " fmt @"\n\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

//======================通知===============================

#define Guider  @"guider" //引导图
#define KCancelWedding   @"CancelWedding"

