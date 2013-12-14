//
//  MapLocationModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapLocationModel : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *PM25;

@end
