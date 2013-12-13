//
//  MapEscapeViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapEscapeViewController.h"

@interface MapEscapeViewController ()

@end

@implementation MapEscapeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addEscapeLines
{
    for (CLLocation *location in self.destinationLocations)
    {
        CLLocationCoordinate2D startCoor = self.userLocation.location.coordinate;
        CLLocationCoordinate2D endCoor = location.coordinate;
        CLLocationCoordinate2D coors[2] = {startCoor, endCoor};
        BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:2];
        [self.mapView addOverlay:line];
    }
}

- (void)addPointAnnotation
{
    for (CLLocation *location in self.destinationLocations)
    {
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor = location.coordinate;
        pointAnnotation.coordinate = coor;
//        pointAnnotation.title = @"test";
//        pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor = self.userLocation.location.coordinate;
    pointAnnotation.coordinate = coor;
    //        pointAnnotation.title = @"test";
    //        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)viewDidGetLocatingUser:(CLLocationCoordinate2D)userLoc
{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self addPointAnnotation];
    [self addEscapeLines];
}

@end
