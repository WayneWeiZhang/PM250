//
//  CurrentCityRequestModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHBaseModel.h"

@interface CurrentCityRequestModel : AHBaseModel

@property (strong, nonatomic) NSNumber *aqi;
@property (strong, nonatomic) NSNumber *so2;
@property (strong, nonatomic) NSNumber *so2_24h;
@property (strong, nonatomic) NSNumber *no2;
@property (strong, nonatomic) NSNumber *no2_24h;
@property (strong, nonatomic) NSNumber *pm10;
@property (strong, nonatomic) NSNumber *pm10_24h;
@property (strong, nonatomic) NSNumber *co;
@property (strong, nonatomic) NSNumber *co_24h;
@property (strong, nonatomic) NSNumber *o3;
@property (strong, nonatomic) NSNumber *o3_8h;
@property (strong, nonatomic) NSNumber *o3_24h;
@property (strong, nonatomic) NSNumber *o3_8h_24h;
@property (strong, nonatomic) NSNumber *pm2_5;
@property (strong, nonatomic) NSNumber *pm2_5_24h;
@property (strong, nonatomic) NSString *primary_pollutant;
@property (strong, nonatomic) NSString *quality;
@property (strong, nonatomic) NSString *time_point;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
