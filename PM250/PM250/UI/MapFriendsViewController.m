//
//  MapFriendsViewController.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "MapFriendsViewController.h"
#import "FriendModel.h"
#import "FakeDataGenerator.h"
#import "GLobalDataManager.h"

@interface MapFriendsViewController ()

@property (strong, nonatomic) NSMutableArray *friendsOverlays;

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
    
    self.type = MapFriendsViewControllerTypeCity;
    [self refresh];
    
//    self.friends = [FakeDataGenerator getFriends];
//    NSMutableArray *tmpCitys = [NSMutableArray array];
//    for (FriendModel *model in self.friends)
//    {
//        if (model.cityModel)
//        {
//            [tmpCitys addObject:model.cityModel];
//        }
//    }
//    self.destinations = tmpCitys;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    self.mapView.delegate = nil;
    
    self.destinations = nil;
    self.friends = nil;
    NSArray *tmpAnnotations = [NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:tmpAnnotations];
    NSArray *tmpOverlays = [NSArray arrayWithArray:self.mapView.overlays];
    [self.mapView removeOverlays:tmpOverlays];
    
    
    if (self.type == MapFriendsViewControllerTypeCity)
    {
        self.destinations = [GLobalDataManager sharedInstance].cityList;
        
        [self addCircles];
        
        
    }
    else
    {
        self.friends = [FakeDataGenerator getFriends];
        NSMutableArray *tmpCitys = [NSMutableArray array];
        for (FriendModel *model in self.friends)
        {
            if (model.cityModel)
            {
                [tmpCitys addObject:model.cityModel];
            }
        }
        self.destinations = tmpCitys;
        
        [self addCircles];
        [self addAnnotation];
    }
    
    self.mapView.delegate = self;
}

- (void)addAnnotation
{
    self.friendsOverlays = [NSMutableArray array];
    
    for (FriendModel *model in self.friends)
    {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.cityModel.lat doubleValue];
        coor.longitude = [model.cityModel.lng doubleValue];
        annotation.coordinate = coor;
        //        pointAnnotation.title = @"test";
        //        pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [self.mapView addAnnotation:annotation];
        [self.friendsOverlays addObject:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString *FriendsAnnotationID = @"FriendsAnnotation";
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:FriendsAnnotationID];
    if (annotationView == nil)
    {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:FriendsAnnotationID];
        
    }
    
    if (self.friendsOverlays.count)
    {
        NSUInteger index = [self.friendsOverlays indexOfObject:annotation];
        if (index < self.friends.count)
        {
            FriendModel *friendModel = self.friends[index];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                NSData *data = [NSData dataWithContentsOfURL:friendModel.imageUrl];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    annotationView.image = [UIImage imageWithData:data];
                });
            });
        }
        
    }
    
    
    
	return annotationView;
}

@end
