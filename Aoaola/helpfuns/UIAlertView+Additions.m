//
//  UIAlertView+Additions.m
//  Lottery
//
//  Created by Johnil on 14/12/5.
//  Copyright (c) 2014年 Johnil. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <objc/runtime.h>

@interface UIAlertView() <UIAlertViewDelegate>
@property (nonatomic, copy) void (^completionBlock)(id alertView, NSInteger selectedButtonIndex);
@property (nonatomic, copy) void (^cancelBlock)();
@end

@implementation UIAlertView (Additions)

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock;{
    return [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:titles needInput:NO completionBlock:completionBlock cancelBlock:cancelBlock];
}

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
                needInput:(BOOL)need
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock {
    return [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:titles needInput:need completionBlock:completionBlock cancelBlock:cancelBlock];
}

+ (id)alertViewWithTitle:(NSString *)title
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSArray*) titles
                userName:(NSString *)userName
         completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
             cancelBlock:(void (^)()) cancelBlock{
    return [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:titles userName:userName completionBlock:completionBlock cancelBlock:cancelBlock];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSArray*) titles
           userName:(NSString *)userName
    completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
        cancelBlock:(void (^)()) cancelBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        self.completionBlock = completionBlock;
        self.cancelBlock = cancelBlock;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (cancelButtonTitle.length>0) {
            [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        if (self.cancelBlock) {
                                                            self.cancelBlock();
                                                        }
                                                    }]];
        }
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = userName;
            textField.placeholder = @"请输入用户名";
        }];
        __block UITextField *temp = nil;
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.secureTextEntry = YES;
            textField.placeholder = @"请输入密码";
            temp = textField;
        }];
        NSInteger index = 0;
        for (NSString *other in titles) {
            [alert addAction:[UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (self.completionBlock) {
                    self.completionBlock(alert, index);
                }
            }]];
            index++;
        }
        [[UIApplication presentedViewController] presentViewController:alert animated:YES completion:^{
            [temp becomeFirstResponder];
        }];
        return (id)alert;
    } else {
        if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) {
            for (NSString* otherButtonTitle in titles)
                [self addButtonWithTitle:otherButtonTitle];
            self.completionBlock = completionBlock;
            self.cancelBlock = cancelBlock;
        }
        self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [self textFieldAtIndex:0].placeholder = @"请输入用户名";
        [self textFieldAtIndex:1].placeholder = @"请输入密码";
        [self textFieldAtIndex:0].text = userName;
        [[self textFieldAtIndex:1] becomeFirstResponder];
        [self show];
        return self;
    }
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSArray*) titles
          needInput:(BOOL)need
    completionBlock:(void (^)(id alertView, NSInteger selectedButtonIndex)) completionBlock
        cancelBlock:(void (^)()) cancelBlock {
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        self.completionBlock = completionBlock;
        self.cancelBlock = cancelBlock;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (cancelButtonTitle.length>0) {
            [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        if (self.cancelBlock) {
                                                            self.cancelBlock();
                                                        }
                                                    }]];
        }
        if (need) {
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.secureTextEntry = YES;
                if ([message isEqualToString:@"支付"]) {
                    textField.placeholder = @"请输入支付密码";
                } else {
                    textField.placeholder = @"请输入密码";
                }
            }];
        }
        NSInteger index = 0;
        for (NSString *other in titles) {
            [alert addAction:[UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (self.completionBlock) {
                    self.completionBlock(alert, index);
                }
            }]];
            index++;
        }
        [[UIApplication presentedViewController] presentViewController:alert animated:YES completion:nil];
        return (id)alert;
    } else {
        if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) {
            for (NSString* otherButtonTitle in titles)
                [self addButtonWithTitle:otherButtonTitle];
            self.completionBlock = completionBlock;
            self.cancelBlock = cancelBlock;
        }
        if (need) {
            self.alertViewStyle = UIAlertViewStyleSecureTextInput;
        }
        [self show];
        return self;
    }
}

#pragma mark UIAlertViewDelegate

- (void)didPresentAlertView:(UIAlertView *)alertView{
    if (alertView.alertViewStyle==UIAlertViewStyleDefault) {
        return;
    }
    @try {
        UITextField *passwordField = [alertView textFieldAtIndex:1];
        [passwordField becomeFirstResponder];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==alertView.cancelButtonIndex) {
        if (self.cancelBlock) {
            self.cancelBlock();
            self.cancelBlock = nil;
        }
        self.completionBlock = nil;
    } else {
        if (self.completionBlock) {
            self.completionBlock(self, buttonIndex);
            self.completionBlock = nil;
        }
        self.cancelBlock = nil;
    }
}

- (void) alertViewCancel:(UIAlertView *)alertView {
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
    self.completionBlock = nil;
}
#pragma mark - Private

- (void) setCompletionBlock:(void (^)(UIAlertView*, NSInteger))completionBlock {
    objc_setAssociatedObject(self, @"completionBlock", [completionBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(UIAlertView*, NSInteger)) completionBlock {
    return objc_getAssociatedObject(self, @"completionBlock");
}

- (void) setCancelBlock:(void (^)())cancelBlock {
    objc_setAssociatedObject(self, @"cancelBlock", [cancelBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)()) cancelBlock {
    return objc_getAssociatedObject(self, @"cancelBlock");
}


@end
