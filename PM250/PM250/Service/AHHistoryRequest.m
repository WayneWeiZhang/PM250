//
//  AHHistoryRequest.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "AHHistoryRequest.h"

@implementation AHHistoryRequest

- (id)ParseData:(id)responseObject
{
    NSData *data = (NSData *)responseObject;
    NSError *error = nil;
    NSArray *historyArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error)
    {
        NSLog(@"service error in %@: %@", NSStringFromClass([self class]), error);
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in historyArray)
    {
        CurrentCityRequestModel *model = [[CurrentCityRequestModel alloc] initWithDictionary:dic];
        [resultArray addObject:model];
    }
    
    HistoryRequestModel *model = [[HistoryRequestModel alloc] init];
    model.historyList = resultArray;
    
    return model;
}

- (NSString *)setRoute
{
    return [NSString stringWithFormat:@"%@", KAHServiceUrlHistory];
}

@end
