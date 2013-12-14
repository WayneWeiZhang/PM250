//
//  MapFriendsViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapFriendsViewController.h"
#import "FriendModel.h"

@interface MapFriendsViewController ()

@end

@implementation MapFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *tmpCitys = [NSMutableArray array];
    for (FriendModel *model in self.friends)
    {
//        model.cityModel =
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)addFriends

//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
//		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
//	}
//	return nil;
//}

@end
