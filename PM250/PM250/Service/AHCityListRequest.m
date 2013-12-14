//
//  AHCityListRequest.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "AHCityListRequest.h"

@implementation AHCityListRequest

- (id)ParseData:(id)responseObject
{
    NSData *data = (NSData *)responseObject;
    NSError *error = nil;
    NSArray *cityArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error)
    {
        NSLog(@"service error in %@: %@", NSStringFromClass([self class]), error);
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in cityArray)
    {
        CityModel *model = [[CityModel alloc] initWithDictionary:dic];
        [resultArray addObject:model];
    }
    
    CityListRequestModel *model = [[CityListRequestModel alloc] init];
    model.cityList = resultArray;
    
    return model;
}

- (NSString *)setRoute
{
    return [NSString stringWithFormat:@"%@", KAHServiceUrlCityList];
}

@end
