//
//  CityListRequestModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHBaseModel.h"
#import "CityModel.h"

@interface CityListRequestModel : AHBaseModel

@property (strong, nonatomic) NSArray *cityList;

@end
