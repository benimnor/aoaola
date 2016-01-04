//
//  UIAlertView+Additions.h
//  Lottery
//
//  Created by Johnil on 14/12/5.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIApplication+Additions.h"

@interface UIAlertView (Additions)

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
               needInput:(BOOL)need
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock;

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
                userName:(NSString *)userName
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock;

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSArray*) titles
          needInput:(BOOL)need
    completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
        cancelBlock:(void (^)()) cancelBlock;

@end
