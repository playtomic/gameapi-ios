//
//  PlayerCountry.h
//  Playtomic iOS API
//
//  Created by Ben Lowry on 4/30/13.
//  Copyright (c) 2013 Ben Lowry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerCountry : NSObject
@property (strong) NSString* name;
@property (strong) NSString* code;

- (id)initWithName:(NSString*)countryName andCode:(NSString*)countryCode;

@end