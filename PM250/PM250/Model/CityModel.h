//
//  CityModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHBaseModel.h"

@interface CityModel : AHBaseModel

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *ename;
@property (copy, nonatomic) NSNumber *lat;
@property (copy, nonatomic) NSNumber *lng;
@property (copy, nonatomic) NSNumber *pm2_5;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
