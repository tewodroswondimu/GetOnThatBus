//
//  BusStopAnnotation.h
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BusStop.h"

@interface BusStopAnnotation : MKPointAnnotation

@property BusStop *busStop; 

@end
