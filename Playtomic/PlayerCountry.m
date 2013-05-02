//
//  PlayerCountry.m
//  Playtomic iOS API
//
//  Created by Ben Lowry on 4/30/13.
//  Copyright (c) 2013 Ben Lowry. All rights reserved.
//

#import "PlayerCountry.h"

@implementation PlayerCountry

- (id)initWithName:(NSString*) countryname andCode:(NSString*) countrycode
{
    self.name = countryname;
    self.code = countrycode;
    return self;
}

@end
