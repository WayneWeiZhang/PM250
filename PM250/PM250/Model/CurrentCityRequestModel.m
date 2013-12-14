//
//  CurrentCityRequestModel.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "CurrentCityRequestModel.h"

@implementation CurrentCityRequestModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        if (dictionary)
        {
            self.aqi = [dictionary objectForKey:@"aqi"];
            self.so2 = [dictionary objectForKey:@"so2"];
            self.so2_24h = [dictionary objectForKey:@"so2_24h"];
            self.no2 = [dictionary objectForKey:@"no2"];
            self.no2_24h = [dictionary objectForKey:@"no2_24h"];
            self.pm10 = [dictionary objectForKey:@"pm10"];
            self.pm10_24h = [dictionary objectForKey:@"pm10_24h"];
            self.co = [dictionary objectForKey:@"co"];
            self.co_24h = [dictionary objectForKey:@"co_24h"];
            self.o3 = [dictionary objectForKey:@"o3"];
            self.o3_8h = [dictionary objectForKey:@"o3_8h"];
            self.o3_24h = [dictionary objectForKey:@"o3_24h"];
            self.o3_8h_24h = [dictionary objectForKey:@"o3_8h_24h"];
            self.pm2_5 = [dictionary objectForKey:@"pm2_5"];
            self.pm2_5_24h = [dictionary objectForKey:@"pm2_5_24h"];
            self.primary_pollutant = [dictionary objectForKey:@"primary_pollutant"];
            self.quality = [dictionary objectForKey:@"quality"];
            self.time_point = [dictionary objectForKey:@"time_point"];
        }
    }
    return self;
}

@end
