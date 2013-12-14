//
//  FakeDataGenerator.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "FakeDataGenerator.h"

@implementation FakeDataGenerator

+ (NSArray *)getFriends
{
//name: "北京",
//ename: "beijing",
//lat: "39.90403",
//lng: "116.407526"
//    
//name: "成都",
//ename: "chengdu",
//lat: "30.572269",
//lng: "104.066541"
//    
//name: "广州",
//ename: "guangzhou",
//lat: "23.129163",
//lng: "113.264435"
//    
//name: "青岛",
//ename: "qingdao",
//lat: "36.067082",
//lng: "120.38264"
    
    NSArray *cityNames = @[@"北京", @"成都", @"广州", @"青岛"];
    NSArray *cityENames = @[@"beijing", @"chengdu", @"guangzhou", @"qingdao"];
    NSArray *lats = @[@(39.90403), @(30.572269), @(23.129163), @(36.067082)];
    NSArray *lngs = @[@(116.407526), @(104.066541), @(113.264435), @(120.38264)];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < [cityENames count]; ++i)
    {
        CityModel *cityModel = [[CityModel alloc] init];
        cityModel.name = cityNames[i];
        cityModel.ename = cityENames[i];
        cityModel.lat = lats[i];
        cityModel.lng = lngs[i];
        
        FriendModel *friendModel = [[FriendModel alloc] init];
        friendModel.cityModel = cityModel;
        friendModel.name = [NSString stringWithFormat:@"%d", i];
        friendModel.imageUrl = [NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.gif"];
        
        [tmpArray addObject:friendModel];
    }
    
    return tmpArray;
}

@end
