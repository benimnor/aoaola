//
//  UIImage+Additions.m
//  vvebo
//
//  Created by Johnil on 13-7-28.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIImage+Additions.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (Additions)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    
//    // draw original image
//    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0f];
//    
//    // tint image (loosing alpha).
//    // kCGBlendModeOverlay is the closest I was able to match the
//    // actual process used by apple in navigation bar
//    CGContextSetBlendMode(context, kCGBlendModeOverlay);
//    [tintColor setFill];
//    CGContextFillRect(context, rect);
//    
//    // mask by alpha values of original image
//    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];

	CGContextSetTextMatrix(context,CGAffineTransformIdentity);
	CGContextTranslateCTM(context,0, self.size.height);
	CGContextScaleCTM(context,1.0,-1.0);
	[tintColor set];
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

- (UIImage *)vImageScaledImageWithSize:(CGSize)destSize {
    UIImage *destImage = nil;

    // Convert UIImage to array of bytes in ARGB8888 pixel format
    CGImageRef sourceRef = [self CGImage];
    NSUInteger sourceWidth = CGImageGetWidth(sourceRef);
    NSUInteger sourceHeight = CGImageGetHeight(sourceRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *sourceData = (unsigned char*)calloc(sourceHeight * sourceWidth * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger sourceBytesPerRow = bytesPerPixel * sourceWidth;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(sourceData, sourceWidth, sourceHeight,
                                                 bitsPerComponent, sourceBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, sourceWidth, sourceHeight), sourceRef);
    CGContextRelease(context);

    NSUInteger destWidth = (NSUInteger)destSize.width;
    NSUInteger destHeight = (NSUInteger)destSize.height;
    NSUInteger destBytesPerRow = bytesPerPixel * destWidth;
    unsigned char *destData = (unsigned char*)calloc(destHeight * destWidth * 4, sizeof(unsigned char));

    // Create vImage_Buffers for both arrays
    vImage_Buffer src = {
        .data = sourceData,
        .height = sourceHeight,
        .width = sourceWidth,
        .rowBytes = sourceBytesPerRow
    };

    vImage_Buffer dest = {
        .data = destData,
        .height = destHeight,
        .width = destWidth,
        .rowBytes = destBytesPerRow
    };

    // Resize image
    vImage_Error err = vImageScale_ARGB8888(&src, &dest, NULL, kvImageHighQualityResampling);

    free(sourceData);

    // Create UIImage from resized image data
    CGContextRef destContext = CGBitmapContextCreate(destData, destWidth, destHeight,
                                                     bitsPerComponent, destBytesPerRow, colorSpace,
                                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGImageRef destRef = CGBitmapContextCreateImage(destContext);

    destImage = [UIImage imageWithCGImage:destRef];

    CGImageRelease(destRef);

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(destContext);

    free(destData);

    // Error handling
    if (err != kvImageNoError) {
        NSString *errorReason = [NSString stringWithFormat:@"vImageScale returned error code %zd", err];
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self, @"sourceImage",
                                   [NSValue valueWithCGSize:destSize], @"destSize",
                                   nil];

        NSException *exception = [NSException exceptionWithName:@"HighQualityImageScalingFailureException" reason:errorReason userInfo:errorInfo];

        @throw exception;
    }

    return destImage;
}

- (UIImage *)cropToSize:(CGSize)size{
	float scale = [UIPasteboard generalPasteboard].image.size.width/75;
	CGSize tempSize = CGSizeMake(75, [UIPasteboard generalPasteboard].image.size.height/scale);
	if ([UIPasteboard generalPasteboard].image.size.width>[UIPasteboard generalPasteboard].image.size.height) {
		scale = [UIPasteboard generalPasteboard].image.size.height/75;
		tempSize = CGSizeMake([UIPasteboard generalPasteboard].image.size.width/scale, 75);
	}
	UIGraphicsBeginImageContextWithOptions(tempSize, NO, 0);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, tempSize.width, tempSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 绘制改变大小的图片
    [scaledImage drawInRect:CGRectMake((size.width-scaledImage.size.width)/2, (size.height-scaledImage.size.height)/2, scaledImage.size.width, scaledImage.size.height)];
    // 从当前context中创建一个改变大小后的图片
    scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)scaleToSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *) imageWithTintColorTransBg:(UIColor *)tintColor{
    UIImage *temp = [self scaleToSize:CGSizeMake((int)self.size.width, (int)self.size.height)];
	UIGraphicsBeginImageContextWithOptions(temp.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, temp.size.width, temp.size.height);
    UIRectFill(bounds);
    //Draw the tinted image in context
    [temp drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return tintedImage;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeLighten alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	return tintedImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
+(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end
