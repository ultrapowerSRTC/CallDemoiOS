//
//  UIImage+Extension.h
//  SRTClibDemo
//
//  Created by feinno on 2019/11/21.
//  Copyright © 2019 wanghaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/** 生成渐变色图片 */
+ (UIImage *)imageWithStartColor:( UIColor * _Nonnull)startColor endColor:(UIColor * _Nonnull)endColor;
/** 生成纯颜色图 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 自动缩放到指定大小，生成缩略图 */
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

/** 保持原来长宽比，生成缩略图 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

/** 压缩图片 */
+ (NSData *)compressImage:(UIImage *)image maxSize:(NSUInteger)maxSize;

/** 添加文字水印 */
+ (UIImage *)markText:(NSString *)text image:(UIImage *)image;

/** 高斯模糊 毛玻璃效果 */
+ (UIImage *)gsImage:(UIImage *)image withGsNumber:(CGFloat)blur;

/** 缩放图片 */
+ (UIImage*)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;

/** 裁剪图片 */
+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect;

/** 图片剪裁 取部分以适应pubSize */
+ (UIImage *)cutImage:(UIImage *)image size:(CGSize)pubSize;

/** 纠正相机拍照获取到的图片方向 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/** 修改图片颜色，但不保留透明度 */
- (UIImage *)updateWithTintColor:(UIColor *)tintColor;
/** 修改图片颜色 同时保留透明度 */
- (UIImage *)updateWithGradientTintColor:(UIColor *)tintColor;
/** 根据修改类型修改图片颜色 */
- (UIImage *)updateWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end

NS_ASSUME_NONNULL_END
