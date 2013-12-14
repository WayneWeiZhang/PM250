//
//  MapAllCityViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-14.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapAllCityViewController.h"
#import "CityModel.h"
#import "GLobalDataManager.h"

@interface MapAllCityViewController ()

@end

@implementation MapAllCityViewController

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
//    self.destinations = [GLobalDataManager sharedInstance].cityList;
//    [self addCircles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircles
{
    for (CityModel *model in self.destinations) {
        CLLocationCoordinate2D coor;
        coor.latitude = [model.lat doubleValue];
        coor.longitude = [model.lng doubleValue];
        BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:50000];
        circle.title = [NSString stringWithFormat:@"%d", [self.destinations indexOfObject:model]];
        [self.mapView addOverlay:circle];
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        
        //  todo: change colors
        NSUInteger index = [[(BMKCircle *)overlay title] integerValue];
        CityModel *cityModel = self.destinations[index];
        NSInteger pm2_5 = [cityModel.pm2_5 integerValue];
        UIColor *fillColor = nil;
        if (pm2_5 <= 100) {
            fillColor = [UIColor colorWithRed:0x2b / 255.f green:0xb4 / 255.f blue:0x2a / 255.f alpha:0.5];
        }
        else if (pm2_5 > 100 && pm2_5 <= 200) {
            fillColor = [UIColor colorWithRed:0xf5 / 255.f green:0xcd / 255.f blue:0x00 / 255.f alpha:0.5];
//            fillColor = UIColorFromRGB(0xF5CD00);
        }
        else {
            fillColor = [UIColor colorWithRed:0xf5 / 255.f green:0x2d / 255.f blue:0x00 / 255.f alpha:0.5];
//            fillColor = UIColorFromRGB(0xF52D00);
        }
        
        circleView.fillColor = fillColor;
        //        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        //        circleView.lineWidth = 5.0;
		return circleView;
    }
	
	return nil;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        self.mapView.showsUserLocation = NO;
        [self.mapView setRegion: BMKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 800000.0f, 800000.0f)
                       animated: YES];
        
        //        [self.mapView removeOverlays:self.mapView.overlays];
        //        [self.mapView removeAnnotations:self.mapView.annotations];
        //        [self addPointAnnotation];
        //        [self addEscapeLines];
    });
}

@end
