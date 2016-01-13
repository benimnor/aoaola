//
//  AALRequest.h
//  aoaola
//
//  Created by Johnil on 15/6/1.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

#define DOCUMENT_DIR [AALRequest applicationDocumentsDirectory]
#define ALRequest    [AALRequest sharedInstance]
#define PAGESIZE 20
@class AFHTTPRequestOperation;

@interface AALRequest : AFHTTPRequestOperationManager

+ (AALRequest *)sharedInstance;
+ (NSString *)applicationDocumentsDirectory;
- (AFHTTPRequestOperation *)requestAPI:(NSString *)api type:(NSString *)type postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed;
- (AFHTTPRequestOperation *)requestPOSTAPI:(NSString *)api postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed;
- (AFHTTPRequestOperation *)requestGETAPI:(NSString *)api
                                 postData:(NSDictionary *)datas
                                  success:(void (^)(id result))success
                                   failed:(void (^)(id result, NSError *error))failed;
- (void)uploadImage:(UIImage *)image
            progress:(void (^)(float progress))progress
            success:(void (^)(id result))success
             failed:(void (^)(id result, NSError *error))failed;
@property (nonatomic) NSInteger integral;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSMutableArray *productNotifications;
@property (nonatomic, strong) NSMutableArray *newsNotifications;
@property (nonatomic, strong) NSMutableArray *activitedNotifications;
- (void)saveData;
- (void)saveNotificationDatas;

- (NSString *)imageUrlWithName:(NSString *)name;


@end
