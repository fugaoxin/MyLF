//
//  AFNetworkingTool.m
//
//
//  Created by KevinSoon on 15/11/13.
//  Copyright © 2015年 KevinSoon. All rights reserved.
//

#import "AFNetworkingTool.h"
#import "AFHTTPSessionManager.h"

@implementation AFNetworkingTool

+ (void)GETwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *有时候做Server那邊的人沒把head內的 meta的content格式指定好，需要加上这个
     *
     **/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript",nil];
    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *有时候做Server那邊的人沒把head內的 meta的content格式指定好，需要加上这个
     *
     **/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript",nil];
//    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)POSTJsonWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**
     *有时候做Server那邊的人沒把head內的 meta的content格式指定好，需要加上这个
     *
     **/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript",nil];
//    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)pushPOSTwithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *有时候做Server那邊的人沒把head內的 meta的content格式指定好，需要加上这个
     *
     **/
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript",nil];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
