//
//  ImageHelper.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage *) glToUIImage;
+ (UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage;

@end
