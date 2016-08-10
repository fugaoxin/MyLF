//
//  AFNetworkingTool.h
//
//
//  Created by KevinSoon on 15/11/13.
//  Copyright © 2015年 KevinSoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) (id responseObject);
typedef void (^FailBlock) (NSError *error);

@class AFHTTPSessionManager;

@interface AFNetworkingTool : NSObject

@property (nonatomic,copy)SuccessBlock success;
@property (nonatomic,copy)FailBlock fail;

//普通GET
+ (void)GETwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//普通POST
+ (void)POSTwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//POST提交JSON数据
+ (void)POSTJsonWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//推送POST
+ (void)pushPOSTwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
