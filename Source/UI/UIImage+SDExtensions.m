//
//  UIImage+SDExtensions.m
//  SetDirection
//
//  Created by Brandon Sneed on 10/5/11.
//  Copyright (c) 2011 SetDirection. All rights reserved.
//

#import "UIImage+SDExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (SDExtensions)

+ (UIImage *)imageFromView:(UIView *)view
{
    UIImage *result = nil;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    for (CALayer *layer in view.layer.sublayers)
    {
        [layer renderInContext:ctx];
    }
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)nonJaggyImage
{
    // mostly copied from Joel Bernstein's NonJaggyWebImageView...
    CGFloat contentScaleFactor = [[UIScreen mainScreen] scale];
    CGSize newSize = CGSizeMake(self.size.width * self.scale + contentScaleFactor * 2, self.size.height * self.scale + contentScaleFactor * 2);

    UIGraphicsBeginImageContext(newSize);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(contentScaleFactor, contentScaleFactor, self.size.width * self.scale, self.size.height * self.scale), self.CGImage);
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);

    UIGraphicsEndImageContext();

    UIImage *retImage = [UIImage imageWithCGImage:newImageRef scale:contentScaleFactor orientation:self.imageOrientation];
	CGImageRelease(newImageRef);

    return retImage;
}

- (UIColor*) averageColor
{
    CGSize size = CGSizeMake( 1.0f, 1.0f );
    
    UIGraphicsBeginImageContext( size );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality( context, kCGInterpolationMedium );
    
    [self drawInRect: CGRectMake( 0.0f, 0.0f, size.width, size.height )
           blendMode: kCGBlendModeCopy
               alpha: 1.0f];
    
    uint8_t* data = CGBitmapContextGetData( context );
    UIColor* color = [UIColor colorWithRed: data[2] / 255.0f
                                     green: data[1] / 255.0f
                                      blue: data[0] / 255.0f
                                     alpha: 1.0f];
    UIGraphicsEndImageContext();
    
    return color;
}

@end
