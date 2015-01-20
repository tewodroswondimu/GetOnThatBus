//
//  Parser.h
//  GetOnThatBus
//
//  Created by Tewodros Wondimu on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Parser <NSObject>

- (void)fetchBusStopFromJSON:(NSString *)url;

@end

@interface Parser : NSObject

@property (nonatomic, weak) id <Parser> delegate;

@end
