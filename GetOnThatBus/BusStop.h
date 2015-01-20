//
//  BusStop.h
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BusStop : NSObject

@property NSString *address_url;
@property NSString *busStopName;
@property NSString *direction;
@property NSString *routes;

@property CLLocationCoordinate2D coordinate;

@end
