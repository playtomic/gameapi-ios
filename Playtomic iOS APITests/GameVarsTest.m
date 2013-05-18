#import "GameVarsTest.h"
#import "Playtomic.h"
#import "PResponse.h"

@implementation GameVarsTest

- (void) testAll
{
    NSString *section = @"gamevars.all";
    __block BOOL done = NO;

    [[Playtomic GameVars] load:^(NSDictionary* gamevars, PResponse* r){
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([gamevars objectForKey:@"testvar1"] != Nil, [NSString stringWithFormat:@"[%@] Has known testvar1", section]);
        STAssertTrue([gamevars objectForKey:@"testvar2"] != Nil, [NSString stringWithFormat:@"[%@] Has known testvar2", section]);
        STAssertTrue([gamevars objectForKey:@"testvar3"] != Nil, [NSString stringWithFormat:@"[%@] Has known testvar3", section]);
        NSString *value1 = [gamevars objectForKey:@"testvar1"];
        NSString *value2 = [gamevars objectForKey:@"testvar2"];
        NSString *value3 = [gamevars objectForKey:@"testvar3"];
        NSString *expected1 = @"testvalue1";
        NSString *expected2 = @"testvalue2";
        NSString *expected3 = @"testvalue3 and the final gamevar";
        STAssertTrue([value1 isEqual:expected1], [NSString stringWithFormat:@"[%@] Has known testvar1 value", section]);
        STAssertTrue([value2 isEqual:expected2], [NSString stringWithFormat:@"[%@] Has known testvar2 value", section]);
        STAssertTrue([value3 isEqual:expected3], [NSString stringWithFormat:@"[%@] Has known testvar3 value", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) testSingle
{
    NSString *section = @"gamevars.single";
    __block int done=0;

    [[Playtomic GameVars] loadWithName:@"testvar1" andHandler:^(NSDictionary* gamevars, PResponse* r){
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([gamevars objectForKey:@"testvar1"] != Nil, [NSString stringWithFormat:@"[%@] Has known testvar1", section]);
        STAssertTrue([gamevars objectForKey:@"testvar2"] == Nil, [NSString stringWithFormat:@"[%@] Does not have testvar2", section]);
        STAssertTrue([gamevars objectForKey:@"testvar3"] == Nil, [NSString stringWithFormat:@"[%@] Does not have testvar3", section]);
        NSString *value1 = [gamevars objectForKey:@"testvar1"];
        STAssertTrue([value1 isEqual:@"testvalue1"], [NSString stringWithFormat:@"[%@] Has known testvar1 value", section]);
        done = 1;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(1000);
        
    }
}

@end
