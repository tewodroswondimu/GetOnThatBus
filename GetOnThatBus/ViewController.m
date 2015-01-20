//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "BusStop.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray *busStops;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.busStops = [[NSMutableArray alloc] init];
    [self getBusStopsFromJSONURLString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    
}


- (void)getBusStopsFromJSONURLString:(NSString *)url
{
    [self.busStops removeAllObjects];

    // Create a url from the string
    NSURL *jsonURL = [NSURL URLWithString:url];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:jsonURL];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        // Create a dictionary of the results
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSArray *resultsMembersArray = resultsDictionary[@"row"];

        // Loops through the results array of members
        for (NSDictionary *resultBusStopDictionary in resultsMembersArray) {

            BusStop *busStop = [BusStop new];

            //busStop.address_url = resultBusStopDictionary[@"_address"];
            busStop.routes = resultBusStopDictionary[@"routes"];
            busStop.busStopName = resultBusStopDictionary[@"cta_stop_name"];
            busStop.direction = resultBusStopDictionary[@"direction"];

            busStop.coordinate = CLLocationCoordinate2DMake([resultBusStopDictionary[@"latitude"] doubleValue], [resultBusStopDictionary[@"longitude"] doubleValue]);

            // Add the comment to the member array
            [self.busStops addObject:busStop];
        }

        // Make an annotation for every bus stop
        for (BusStop *busStop in self.busStops) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = busStop.coordinate;
            [self.mapView addAnnotation:annotation];

        }
    }];
}

#pragma mark MKMapView



@end
