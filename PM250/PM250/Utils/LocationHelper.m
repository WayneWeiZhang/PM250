//
//  LocationHelper.m
//  PM250
//
//  Created by Richie Liu on 13-12-13.
//  Copyright (c) 2013年 CaoNiMei. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

- (double)getDistanceBetween:(CLLocationCoordinate2D)startLocation and:(CLLocationCoordinate2D)endLocation
{
    double er = 6378137; // 6378700.0f;
	//ave. radius = 6371.315 (someone said more accurate is 6366.707)
	//equatorial radius = 6378.388
	//nautical mile = 1.15078
    double lat1 = startLocation.latitude;
    double lon1 = startLocation.longitude;
    double lat2 = endLocation.latitude;
    double lon2 = endLocation.longitude;
    
	double radlat1 = M_PI*lat1/180.0f;
	double radlat2 = M_PI*lat2/180.0f;
	//now long.
	double radlong1 = M_PI*lon1/180.0f;
	double radlong2 = M_PI*lon2/180.0f;
	if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
	if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
	if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);
	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);
	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double dist  = theta*er;
	return dist;
}

@end
