//
//  LocationHelper.h
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

- (double)getDistanceBetween:(CLLocationCoordinate2D)startLocation and:(CLLocationCoordinate2D)endLocation;

@end
