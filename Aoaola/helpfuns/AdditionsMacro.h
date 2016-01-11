//
//  AdditionsMacro.h
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIScreen+additions.h"
#import "UIView+Additions.h"
#import "UIDevice+Additions.h"
#import "UIColor+Additions.h"
#import "UIImage+Additions.h"
#import "UIApplication+Additions.h"
#import "UIButton+Additions.h"
#import "UIAlertView+Additions.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"
//#import "MBProgressHUD.h"
#import "UIImage+StackBlur.h"
//#import "AALActionSheet.h"
//#import "JFImagePickerController.h"
#import "NSObject+Additions.h"
//#import "AALHelper.h"
//#import "AALRequest.h"
//#import "MGNavigationController.h"
//#import "NSDate+TimeAgo.h"


#define DATA_PATH [DOCUMENT_DIR stringByAppendingPathComponent:@"localData"]
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define kScaleSize (SCREEN_WIDTH/1920)
#define STATUSBARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define LOCALIMAGE(filename) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:nil]]
#define ImageNamed(filename) [UIImage imageNamed:[UIUtil imageName:filename]]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//NSUserDefaults
#define SAVE_INTEGER(numkey,num)     [[NSUserDefaults standardUserDefaults] setInteger:num forKey:numkey]
#define LOAD_INTEGER(numkey)         [[NSUserDefaults standardUserDefaults] integerForKey:numkey]
#define SAVE_BOOL(boolkey,boolvalue) [[NSUserDefaults standardUserDefaults] setBool:boolvalue forKey:boolkey]
#define LOAD_BOOL(boolkey)           [[NSUserDefaults standardUserDefaults] boolForKey:boolkey]
#define SAVE_VALUE(idkey,idvalue)    [[NSUserDefaults standardUserDefaults] setValue:idvalue forKey:idkey]
#define LOAD_VALUE(idkey)            [[NSUserDefaults standardUserDefaults] valueForKey:idkey];

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NAVIGATIONBAR_HEIGHT (self.navigationController.navigationBar.height)
#define CELL_HEIGHT 44
#define COLOR(r,g,b,a) [UIColor colorWithFullRed:r green:g blue:b alpha:a]
#define APP_COLOR [UIColor colorWithFullRed:8 green:199 blue:180 alpha:1]
#define PINK_COLOR [UIColor colorWithFullRed:244 green:71 blue:136 alpha:1]
#define RED_COLOR [UIColor colorWithFullRed:234 green:102 blue:68 alpha:1]
#define GRAY_COLOR [UIColor colorWithFullRed:194 green:194 blue:194 alpha:1]
#define GRAY_BG_COLOR [UIColor colorWithFullRed:240 green:240 blue:240 alpha:1]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_APP_GREEN [UIColor getColor:@"08C7B4"]
#define COLOR_APP_RED [UIColor getColor:@"ED3D3D"]
#define COLOR_APP_YELLOW [UIColor getColor:@"FFA845"]
#define COLOR_APP_PINK [UIColor getColor:@"FCB0C9"]
#define COLOR_APP_WHITE [UIColor getColor:@"F7F7F7"]
#define COLOR_APP_GRAY [UIColor getColor:@"8F8F8F"]
#define COLOR_APP_LIGHTGRAY [UIColor getColor:@"C6C6C6"]

#define kRefrushCompareNum @"comparNumDidChanged"