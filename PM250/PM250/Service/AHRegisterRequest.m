//
//  AHRegisterRequest.m
//  PM250
//
//  Created by Chuan Li on 12/17/13.
//  Copyright (c) 2013 CaoNiMei. All rights reserved.
//

#import "AHRegisterRequest.h"

@implementation AHRegisterRequest

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
    
    return cityArray;
}

- (NSString *)setRoute
{
    return [NSString stringWithFormat:@"%@", kAHServiceRegister];
}

@end
