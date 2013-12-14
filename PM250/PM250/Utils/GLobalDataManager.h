//
//  GLobalDataManager.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLobalDataManager : NSObject

@property (strong, nonatomic) NSArray *cityList;

+ (GLobalDataManager *)sharedInstance;

@end
