//
//  MapEscapeViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapEscapeViewController.h"
#import "RouteAnnotation.h"
#import "UIImage+AHRotated.h"

@interface MapEscapeViewController () <BMKSearchDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) BMKSearch *mapSearch;

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
    
//    CLLocation *l = [[CLLocation alloc] initWithLatitude:39.90403 longitude:116.407526];
//    
//    MapLocationModel *model = [[MapLocationModel alloc] init];
//    model.location = l;
//    self.destinations = @[model];
    
    self.mapSearch = [[BMKSearch alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapSearch.delegate = self;
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.name = @"上海";
	BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"北京";
    
	BOOL flag = [self.mapSearch drivingSearch:@"上海" startNode:start endCity:@"北京" endNode:end];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        NSLog(@"search failed!");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.mapSearch.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        CLLocationCoordinate2D startCoor = self.currentLocation.coordinate;
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
    
//    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
//    CLLocationCoordinate2D coor = self.currentLocation.coordinate;
//    pointAnnotation.coordinate = coor;
//    //        pointAnnotation.title = @"test";
//    //        pointAnnotation.subtitle = @"此Annotation可拖拽!";
//    [self.mapView addAnnotation:pointAnnotation];
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        self.currentLocation = userLocation.location;
        
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self addPointAnnotation];
        [self addEscapeLines];
    });
}

//- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
//{
//	if ([overlay isKindOfClass:[BMKCircle class]])
//    {
//        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
//        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
//        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        circleView.lineWidth = 5.0;
//		return circleView;
//    }
//    
//    if ([overlay isKindOfClass:[BMKPolyline class]])
//    {
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
//        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
//        polylineView.lineWidth = 3.0;
//		return polylineView;
//    }
//	
//	return nil;
//}
//
//// 根据anntation生成对应的View
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    NSString *AnnotationViewID = @"PM25MARK";
//    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//    if (annotationView == nil)
//    {
//        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//        // 设置颜色
//        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//        // 从天上掉下效果
//        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
//    }
//    
//    return annotationView;
//    
//}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

- (void)onGetDrivingRouteResult:(BMKPlanResult *)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
        [self.mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:self.mapView.overlays];
        [self.mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [self.mapView addAnnotation:item];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint points[index];
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [self.mapView addAnnotation:item];
                }
                
            }
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [self.mapView addAnnotation:item];
            
            // 添加途经点
//            if (result.wayNodes) {
//                for (BMKPlanNode* tempNode in result.wayNodes) {
//                    item = [[RouteAnnotation alloc]init];
//                    item.coordinate = tempNode.pt;
//                    item.type = 5;
//                    item.title = tempNode.name;
//                    [self.mapView addAnnotation:item];
//                }
//            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [self.mapView addOverlay:polyLine];
            
//            [self.mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageNamed:@"icon_nav_start"];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageNamed:@"icon_nav_end"];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
//			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
//			if (view == nil) {
//				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
//				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
//				view.canShowCallout = TRUE;
//			}
//			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
//			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
//			if (view == nil) {
//				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
//				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
//				view.canShowCallout = TRUE;
//			}
//			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageNamed:@"icon_direction.png"];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
//            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
//			if (view == nil) {
//				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
//				view.canShowCallout = TRUE;
//			} else {
//				[view setNeedsDisplay];
//			}
//			
//			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
//			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
//			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}


@end
