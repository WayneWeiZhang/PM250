//
//  FriendModel.h
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface FriendModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) CityModel *cityModel;

@end
