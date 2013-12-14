//
//  ImageHelper.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *) glToUIImage {
    NSInteger myDataLength = 640 * 1136 * 4;  //1024-width，768-height
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, 640, 1136, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <1136; y++)
    {
        for(int x = 0; x <640 * 4; x++)
        {
            buffer2[(1135 - y) * 640 * 4 + x] = buffer[y * 4 * 640 + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * 640;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(640, 1136, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

//合并图片
+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = firstImage.size;
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

//- (UIImage*)snapshot:(UIView*)eaglview
//{
//    GLint backingWidth, backingHeight;
//    
//    // Bind the color renderbuffer used to render the OpenGL ES view
//    // If your application only creates a single color renderbuffer which is already bound at this point,
//    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
//    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
//    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderbuffer);
//    
//    // Get the size of the backing CAEAGLLayer
//    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
//    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
//    
//    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
//    NSInteger dataLength = width * height * 4;
//    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
//    
//    // Read pixel data from the framebuffer
//    glPixelStorei(GL_PACK_ALIGNMENT, 4);
//    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
//    
//    // Create a CGImage with the pixel data
//    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
//    // otherwise, use kCGImageAlphaPremultipliedLast
//    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
//                                    ref, NULL, true, kCGRenderingIntentDefault);
//    
//    // OpenGL ES measures data in PIXELS
//    // Create a graphics context with the target size measured in POINTS
//    NSInteger widthInPoints, heightInPoints;
//    if (NULL != UIGraphicsBeginImageContextWithOptions) {
//        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
//        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
//        // so that you get a high-resolution snapshot when its value is greater than 1.0
//        CGFloat scale = eaglview.contentScaleFactor;
//        widthInPoints = width / scale;
//        heightInPoints = height / scale;
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
//    }
//    else {
//        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
//        widthInPoints = width;
//        heightInPoints = height;
//        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
//    }
//    
//    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
//    
//    // UIKit coordinate system is upside down to GL/Quartz coordinate system
//    // Flip the CGImage by rendering it to the flipped bitmap context
//    // The size of the destination area is measured in POINTS
//    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
//    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
//    
//    // Retrieve the UIImage from the current context
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    // Clean up
//    free(data);
//    CFRelease(ref);
//    CFRelease(colorspace);
//    CGImageRelease(iref);
//    
//    return image;
//}

@end
