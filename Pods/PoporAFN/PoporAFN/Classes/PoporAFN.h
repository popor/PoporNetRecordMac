//
//  PoporAFN.h
//  PoporAFN
//
//  Created by popor on 17/4/28.
//  Copyright © 2017年 popor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoporAFNConfig.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

#define PoporAFNTool [PoporAFN new]

@interface PoporAFN : NSObject

#pragma mark - NEW
- (void)title:(NSString *_Nullable)title
          url:(NSString *_Nullable)urlString
       method:(PoporMethod)method
   parameters:(NSDictionary *_Nullable)parameters
      success:(PoporAFNFinishBlock _Nullable)success
      failure:(PoporAFNFailureBlock _Nullable)failure;

- (void)title:(NSString *_Nullable)title
          url:(NSString *_Nullable)urlString
       method:(PoporMethod)method
   parameters:(NSDictionary *_Nullable)parameters
   afnManager:(AFHTTPSessionManager *_Nullable)manager
       header:(NSDictionary *_Nullable)header
      success:(PoporAFNFinishBlock _Nullable)success
      failure:(PoporAFNFailureBlock _Nullable)failure;

- (void)title:(NSString *_Nullable)title
          url:(NSString *_Nullable)urlString
       method:(PoporMethod)method
   parameters:(NSDictionary *_Nullable)parameters
   afnManager:(AFHTTPSessionManager *_Nullable)manager
       header:(NSDictionary *_Nullable)header
     progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
      success:(PoporAFNFinishBlock _Nullable)success
      failure:(PoporAFNFailureBlock _Nullable)failure;

#pragma mark - 下载
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;

// PoporAFN 需要持久化,否则无法下载
- (void)downloadUrl:(NSURL * _Nonnull)downloadUrl
        destination:(NSURL * _Nullable)destinationUrl
           progress:(nullable void (^)(float progress, NSProgress * _Nonnull downloadProgress))progressBlock
             finish:(nullable void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))finishBlock;

@end

NS_ASSUME_NONNULL_END


//#pragma mark - OLD
//// 使用默认 AFHTTPSessionManager
//- (void)postUrl:(NSString *_Nullable)urlString
//     parameters:(NSDictionary * _Nullable)parameters
//        success:(PoporAFNFinishBlock _Nullable)success
//        failure:(PoporAFNFailureBlock _Nullable)failure;
//
//// 使用自定义 AFHTTPSessionManager,title
//- (void)postUrl:(NSString *_Nullable)urlString
//          title:(NSString *_Nullable)title
//     parameters:(NSDictionary * _Nullable)parameters
//     afnManager:(AFHTTPSessionManager * _Nullable)manager
//        success:(PoporAFNFinishBlock _Nullable)success
//        failure:(PoporAFNFailureBlock _Nullable)failure;
//
//// 使用默认 AFHTTPSessionManager
//- (void)getUrl:(NSString *_Nullable)urlString
//    parameters:(NSDictionary * _Nullable)parameters
//       success:(PoporAFNFinishBlock _Nullable)success
//       failure:(PoporAFNFailureBlock _Nullable)failure;
//
//// 使用自定义 AFHTTPSessionManager,title
//- (void)getUrl:(NSString *_Nullable)urlString
//         title:(NSString *_Nullable)title
//    parameters:(NSDictionary * _Nullable)parameters
//    afnManager:(AFHTTPSessionManager * _Nullable)manager
//       success:(PoporAFNFinishBlock _Nullable)success
//       failure:(PoporAFNFailureBlock _Nullable)failure;
