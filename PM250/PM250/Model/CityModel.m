//
//  CityModel.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.name = [dictionary objectForKey:@"name"];
        self.ename = [dictionary objectForKey:@"ename"];
        self.lat = [dictionary objectForKey:@"lat"];
        self.lng = [dictionary objectForKey:@"lng"];
    }
    
    return self;
}

@end
