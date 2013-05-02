//
//  PlayerLevelsTest.h
//  Playtomic iOS API
//
//  Created by Ben Lowry on 5/2/13.
//  Copyright (c) 2013 Ben Lowry. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface PlayerLevelsTest : SenTestCase {
int rnd;
}

+ (int) rnd;
- (void) testCreate;
- (void) testList;
- (void) testRate;
- (void) testLoad;

@end
