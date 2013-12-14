//
//  MapFriendsViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapFriendsViewController.h"

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
    [self addCircles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircles
{
    for (MapLocationModel *model in self.destinations) {
        CLLocationCoordinate2D coor = model.location.coordinate;
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
        [self.mapView addOverlay:circle];
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
		return circleView;
    }
	
	return nil;
}

@end
