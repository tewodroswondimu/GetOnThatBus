//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import "BusStopDetailsViewController.h"
#import "BusStop.h"
#import "BusStopAnnotation.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray *busStops;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Zoom into chicaca map when app first launches
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.87808499, -87.6329);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];

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
            if ([resultBusStopDictionary objectForKey:@"inter_modal"]) {
                busStop.inter_modal = resultBusStopDictionary[@"inter_modal"];
            }
            busStop.coordinate = CLLocationCoordinate2DMake([resultBusStopDictionary[@"latitude"] doubleValue], [resultBusStopDictionary[@"longitude"] doubleValue]);

            // Add the comment to the member array
            [self.busStops addObject:busStop];
        }

        // Make an annotation for every bus stop
        for (BusStop *busStop in self.busStops) {
            BusStopAnnotation *annotation = [BusStopAnnotation new];
            annotation.coordinate = busStop.coordinate;
            annotation.title = busStop.busStopName;
            annotation.subtitle = busStop.routes;
            annotation.busStop = busStop;

            [self.mapView addAnnotation:annotation];

        }
    }];
}

#pragma mark MKMapView

// Show callout when pin annotation is tapped
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    BusStopAnnotation *annotationBusStop = annotation;
    if (annotationBusStop.busStop.inter_modal != nil) {
        NSString *innerModal = annotationBusStop.busStop.inter_modal;
        if ([innerModal isEqualToString:@"Pace"]) {
            pin.pinColor = MKPinAnnotationColorGreen;
        }
        else if ([innerModal isEqualToString:@"Metra"])
        {
            pin.pinColor = MKPinAnnotationColorPurple;
        }
    }
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.animatesDrop = YES;
    return pin;
}

// When the accesory button is tapped push to a new view controller
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"BusStopDetailsSegue" sender:view.annotation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(BusStopAnnotation *)sender
{
    BusStopDetailsViewController *busStopDetailsVC = segue.destinationViewController;
    busStopDetailsVC.busStop = sender.busStop;
}


@end
