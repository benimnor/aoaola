//
//  AALRequest.m
//  aoaola
//
//  Created by Johnil on 15/6/1.
//  Copyright (c) 2015年 Johnil. All rights reserved.
//

#import "AALRequest.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworkActivityIndicatorManager.h"
//#define SERVER_URL @"http://localhost:8080/aoaola-web/ws/"

#define SERVER_URL @"http://app.aoaola.com:8080/aoaola-web/ws/"
//#define SERVER_URL @"http://123.57.237.110:8080/aoaola-web/ws/"
//#define SERVER_URL @"http://10.0.1.26:8080/aoaola-web/ws/"
static AALRequest *sSharedInstance;

@implementation AALRequest {
    NSString *productNotificationsPath;
    NSString *newsNotificationsPath;
    NSString *activitedNotificationsPath;
}

+ (AALRequest *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[AALRequest alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
    });
    return sSharedInstance;
}

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        _userId = @"5";

        NSDictionary *temp = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
        if (temp) {
            _userInfo = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]];
            if (_userInfo) {
                _integral = [_userInfo[@"currIntegral"] integerValue];;
                _userId = [_userInfo[@"id"] stringValue];
            }
            
            productNotificationsPath = [[AALRequest applicationDocumentsDirectory] stringByAppendingPathComponent:@"productNotifications"];
            newsNotificationsPath = [[AALRequest applicationDocumentsDirectory] stringByAppendingPathComponent:@"newsNotificationsPath"];
            activitedNotificationsPath = [[AALRequest applicationDocumentsDirectory] stringByAppendingPathComponent:@"activitedNotificationsPath"];
            
            _productNotifications = [[NSMutableArray alloc] init];
            [_productNotifications addObjectsFromArray:[NSArray arrayWithContentsOfFile:productNotificationsPath]];
            _newsNotifications = [[NSMutableArray alloc] init];
            [_newsNotifications addObjectsFromArray:[NSArray arrayWithContentsOfFile:newsNotificationsPath]];
            _activitedNotifications = [[NSMutableArray alloc] init];
            [_activitedNotifications addObjectsFromArray:[NSArray arrayWithContentsOfFile:activitedNotificationsPath]];
        }
    }
    return self;
}

- (AFHTTPRequestOperation *)requestAPI:(NSString *)api type:(NSString *)type postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:datas];
    if (_userId) {
        if (![datas valueForKey:@"id"]) {
            dict[@"id"] = _userId;
        }
        if (![datas valueForKey:@"userId"]) {
            dict[@"userId"] = _userId;
        }
    } else {
        if (![api isEqualToString:@"user/login"]
            &&![api isEqualToString:@"sms/getValidNo"]
            &&![api isEqualToString:@"user/register"]
            &&![api isEqualToString:@"user/updatePassword"]
            ) {
            return nil;
        }
    }
    NSMutableURLRequest *request = [self requestFromURL:self.baseURL api:api postData:dict method:type];
    [request setTimeoutInterval:20];
    NSLog(@"%@ %@", request, dict);
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *errorMsg = [responseObject valueForKey:@"msg"];
        if ((NSNull *)errorMsg!=[NSNull null]&&errorMsg&&errorMsg.length>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showText:errorMsg AddedTo:[UIApplication appDelegate].window animated:YES];
                //                [CSNotificationView showInViewController:[UIApplication visibleViewController] style:CSNotificationViewStyleError message:errorMsg];
            });
            if (failed) {
                failed(errorMsg, nil);
            }
        } else {
            if (responseObject[@"result"]&&[responseObject[@"result"] isKindOfClass:[NSString class]]&&[responseObject[@"result"] isEqualToString:@"error"]) {
                failed(errorMsg, nil);
            } else {
                if (success) {
                    success(responseObject);
                }
            }            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
        NSString *errorMsg = [operation.responseObject valueForKey:@"msg"];
        if (errorMsg&&errorMsg.length>0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showText:errorMsg AddedTo:[UIApplication appDelegate].window animated:YES];
            });
            if (failed) {
                failed(errorMsg, nil);
            }
        } else {
            if (failed) {
                failed(operation.responseString, error);
            }
        }
    }];
    [self.operationQueue addOperation:operation];
    return operation;
}

- (NSMutableURLRequest *)requestFromURL:(NSURL *)url api:(NSString *)api postData:(NSDictionary *)datas method:(NSString *)method{
    NSString *path = [NSString stringWithFormat:@"%@%@", url, api];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:path parameters:datas error:nil];
    return request;
}

- (AFHTTPRequestOperation *)requestPOSTAPI:(NSString *)api postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    return [self requestAPI:api type:@"POST" postData:datas success:success failed:failed];
}

- (AFHTTPRequestOperation *)requestGETAPI:(NSString *)api postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    return [self requestAPI:api type:@"GET" postData:datas success:success failed:failed];
}

- (UIImage *)uploadImage:(UIImage *)image{
    UIImage *temp = image;
    float max = 960;
    if (image.size.width*image.scale>max) {
        float width = max;
        float scale = image.size.width/max;
        CGSize size = CGSizeMake((int)width, (int)(image.size.height/scale));
        //        UIGraphicsBeginImageContextWithOptions(size, NO, 1);
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        temp = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    } else {
        return image;
    }
    return temp;
}

- (void)uploadImage:(UIImage *)image
           progress:(void (^)(float progress))progress1
            success:(void (^)(id result))success
             failed:(void (^)(id result, NSError *error))failed{
    [self requestPOSTAPI:@"qiniu/getToken" postData:nil success:^(id result) {
        NSString *token = result[@"obj"];
        if (token&&token.length>0) {
            NSString *name = [NSString stringWithFormat:@"%ld%u", (long)([[NSDate date] timeIntervalSince1970]*1000L), arc4random()%1000];
            NSLog(@"%@", name);
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://upload.qiniu.com/" parameters:@{@"token": token, @"key": name} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                UIImage *temp = [self uploadImage:image];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(temp, 1) name:@"file" fileName:name mimeType:@"image/jpeg"];
            } error:nil];
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSProgress *progress;
            NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    failed(responseObject, error);
                } else {
                    success(responseObject);
                }
            }];
            [progress setUserInfoObject:progress1 forKey:@"block"];
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
            [uploadTask resume];
            
        } else {
            failed(result, nil);
        }
    } failed:^(id result, NSError *error) {
        failed(result,error);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        float progress = [change[@"new"] floatValue];
        void(^progressBlock)(float progress) = [object userInfo][@"block"];
        if (progressBlock) {
            progressBlock(progress);
        }
    }
}

- (void)setUserInfo:(NSDictionary *)userInfo{
    if (userInfo) {
        [_userInfo removeAllObjects];
        _userInfo = nil;
        _userInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
        if (_userInfo) {
            _integral = [_userInfo[@"currIntegral"] integerValue];;
            _userId = [_userInfo[@"id"] stringValue];
        }
    } else {
        _userInfo = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveNotificationDatas{
    [_productNotifications writeToFile:productNotificationsPath atomically:YES];
    [_activitedNotifications writeToFile:activitedNotificationsPath atomically:YES];
    [_newsNotifications writeToFile:newsNotificationsPath atomically:YES];
}

- (void)saveData{
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)imageUrlWithName:(NSString *)name{
    return [NSString stringWithFormat:@"%@/%@", @"http://7xjesu.com2.z0.glb.qiniucdn.com", name];
}

- (void)setProductNotifications:(NSMutableArray *)productNotifications{
    _productNotifications = [productNotifications mutableCopy];
    [_productNotifications writeToFile:productNotificationsPath atomically:YES];
}

- (void)setActivitedNotifications:(NSMutableArray *)activitedNotifications{
    _activitedNotifications = [activitedNotifications mutableCopy];
    [_activitedNotifications writeToFile:activitedNotificationsPath atomically:YES];
}

- (void)setNewsNotifications:(NSMutableArray *)newsNotifications{
    _newsNotifications = [newsNotifications mutableCopy];
    [_newsNotifications writeToFile:newsNotificationsPath atomically:YES];
}

@end
