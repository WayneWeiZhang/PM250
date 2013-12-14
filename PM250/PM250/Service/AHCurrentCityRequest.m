//
//  AHCurrentCityRequest.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "AHCurrentCityRequest.h"

@implementation AHCurrentCityRequest

- (id)ParseData:(id)responseObject
{
    NSData *data = (NSData *)responseObject;
    NSError *error = nil;
    NSDictionary *currentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error)
    {
        NSLog(@"service error in %@: %@", NSStringFromClass([self class]), error);
        return nil;
    }
    
    CurrentCityRequestModel *model = [[CurrentCityRequestModel alloc] initWithDictionary:currentDic];
    
    return model;
}

- (NSString *)setRoute
{
    return [NSString stringWithFormat:@"%@", KAHServiceUrlCurrent];
}

@end
