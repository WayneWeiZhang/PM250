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
    for (MapLocationModel *model in self.destinations)
    {
        CLLocationCoordinate2D startCoor = self.userLocation.location.coordinate;
        CLLocationCoordinate2D endCoor = model.location.coordinate;
        CLLocationCoordinate2D coors[2] = {startCoor, endCoor};
        BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:2];
        [self.mapView addOverlay:line];
    }
}

- (void)addPointAnnotation
{
    for (MapLocationModel *model in self.destinations)
    {
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor = model.location.coordinate;
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
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
		return polylineView;
    }
	
	return nil;
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"PM25MARK";
    BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    return annotationView;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

@end
