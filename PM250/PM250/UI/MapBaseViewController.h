//
//  MapBaseViewController.h
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MapLocationModel.h"

@interface MapBaseViewController : UIViewController <BMKMapViewDelegate>

@property (strong, nonatomic) BMKUserLocation *userLocation;
@property (strong, nonatomic) BMKMapView *mapView;

@end
