//
//  MapFriendsViewController.h
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapBaseViewController.h"
#import "MapAllCityViewController.h"

typedef NS_ENUM(NSInteger, MapFriendsViewControllerType)
{
    MapFriendsViewControllerTypeCity        =   0,
    MapFriendsViewControllerTypeFriends
};

@interface MapFriendsViewController : MapAllCityViewController

@property (assign, nonatomic) MapFriendsViewControllerType type;
@property (strong, nonatomic) NSArray *friends;

- (void)refresh;

@end
