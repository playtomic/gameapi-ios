#import "PlayerLevelsTest.h"
#import "Playtomic.h"
#import "PlayerLevel.h"

@interface PlayerLevelsTest ()
@property (nonatomic, readwrite) int rnd;
@end

@implementation PlayerLevelsTest
@synthesize rnd;

- (void) setUp
{
    self.rnd = [PlayerLevelsTest rnd];
}

+ (int) rnd
{
    static int random = 0;
    
    if (random == 0)
    {
        random = arc4random() % 123456;
    }
    
    return random;
}

- (void) testCreate
{
    NSString *section = @"playerlevels.create";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerLevel *level = [[PlayerLevel alloc] init];
    level.name = [NSString stringWithFormat: @"create%d", rnd];
    level.playername = [NSString stringWithFormat: @"ben%d", rnd];
    level.playerid = @"0";
    level.data = @"this is the level data";
    level.fields = fields;
    
    [[Playtomic PlayerLevels] save:level andHandler:^(PlayerLevel *l, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#2 No errorcode", section]);
        STAssertTrue(l != Nil, [NSString stringWithFormat:@"[%@]#2 Level is not null", section]);
        STAssertTrue(l.levelid != Nil, [NSString stringWithFormat:@"[%@]#2 Level has levelid", section]);
        STAssertTrue([l.name isEqualToString:level.name], [NSString stringWithFormat:@"[%@] Level names match", section]);
        
        [[Playtomic PlayerLevels] save:level andHandler:^(PlayerLevel *l2, PResponse *r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 405, [NSString stringWithFormat:@"[%@]#2 Duplicate level errorcode", section]);
            done = YES;
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) testLoad
{
    NSString *section = @"playerlevels.load";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerLevel *level = [[PlayerLevel alloc] init];
    level.name = [NSString stringWithFormat: @"sample loading level%d", rnd];
    level.playername = [NSString stringWithFormat: @"ben%d", rnd];
    level.playerid = [NSString stringWithFormat: @"%d", rnd];
    level.data = @"this is the level data";
    level.fields = fields;
    
    [[Playtomic PlayerLevels] save:level andHandler:^(PlayerLevel *l, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        STAssertTrue(l != Nil, [NSString stringWithFormat:@"[%@]#1 Level is not null", section]);
        STAssertTrue(l.levelid != Nil, [NSString stringWithFormat:@"[%@]#1 Level has levelid", section]);
        STAssertTrue([l.name isEqualToString:level.name], [NSString stringWithFormat:@"[%@]#1 Level names match", section]);
        
        [[Playtomic PlayerLevels] load:l.levelid andHandler:^(PlayerLevel *l2, PResponse *r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 0, [NSString stringWithFormat:@"[%@]#2 No errorcode", section]);
            STAssertTrue([l.name isEqualToString:l2.name], [NSString stringWithFormat:@"[%@]#2 Level name is correct", section]);
            STAssertTrue([l.data isEqualToString:l2.data], [NSString stringWithFormat:@"[%@]#2 Level data is correct", section]);
            done = YES;
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) testList
{
    NSString *section = @"playerlevels.list";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
   
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSNumber numberWithInt:10] forKey:@"perpage"];
    [list setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [list setObject:[NSNumber numberWithBool:NO] forKey:@"data"];
    [list setObject:filters forKey:@"filters"];
        
    [[Playtomic PlayerLevels] list:list andHandler:^(NSArray *levels, int numlevels, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        STAssertTrue([levels count] > 0, [NSString stringWithFormat:@"[%@]#1 Received levels", section]);
        STAssertTrue(numlevels > 0, [NSString stringWithFormat:@"[%@]#1 Received numlevels", section]);
        
        if([levels count] > 0) {
            PlayerLevel *level1 = levels[0];
            STAssertTrue(level1.data == Nil, [NSString stringWithFormat:@"[%@]#1 First level has no data", section]);
        } else {
            STAssertTrue(false, [NSString stringWithFormat:@"[%@]#1 First level has no data forced failure", section]);
        }
        
        [list setObject:[NSNumber numberWithBool:YES] forKey:@"data"];
        
        [[Playtomic PlayerLevels] list:list andHandler:^(NSArray *levels2, int numlevels2, PResponse *r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 0, [NSString stringWithFormat:@"[%@]#2 No errorcode", section]);
            STAssertTrue([levels2 count] > 0, [NSString stringWithFormat:@"[%@]#2 Received levels", section]);
            STAssertTrue(numlevels2 > 0, [NSString stringWithFormat:@"[%@]#2 Received numlevels", section]);
            
            if([levels2 count] > 0) {
                PlayerLevel *level2 = levels[0];
                STAssertTrue(level2.data != Nil, [NSString stringWithFormat:@"[%@]#2 First level has data", section]);
            } else {
                STAssertTrue(false, [NSString stringWithFormat:@"[%@]#2 First level has data forced failure", section]);
            }
        }];
        
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) testRate
{
    NSString *section = @"playerlevels.rate";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerLevel *level = [[PlayerLevel alloc] init];
    level.name = [NSString stringWithFormat: @"rate%d", rnd];
    level.playername = [NSString stringWithFormat: @"ben%d", rnd];
    level.playerid = [NSString stringWithFormat: @"%d", rnd];
    level.data = @"this is the level data";
    level.fields = fields;
    
    [[Playtomic PlayerLevels] save:level andHandler:^(PlayerLevel *l, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        STAssertTrue(l != Nil, [NSString stringWithFormat:@"[%@]#1 Level is not null", section]);
        STAssertTrue(l.levelid != Nil, [NSString stringWithFormat:@"[%@]#1 Level has levelid", section]);
        
        [[Playtomic PlayerLevels] rate:l.levelid andRating:70 andHandler:^(PResponse *r2) {
            STAssertFalse(r2.success, [NSString stringWithFormat:@"[%@]#2 Request failed", section]);
            STAssertTrue(r2.errorcode == 401, [NSString stringWithFormat:@"[%@]#2 Invalid rating errorcode", section]);
            
            [[Playtomic PlayerLevels] rate:l.levelid andRating:7 andHandler:^(PResponse *r3) {
                STAssertTrue(r3.success, [NSString stringWithFormat:@"[%@]#3 Request succeeded", section]);
                STAssertTrue(r3.errorcode == 0, [NSString stringWithFormat:@"[%@]#3 No errorcode", section]);
                
                [[Playtomic PlayerLevels] rate:l.levelid andRating:7 andHandler:^(PResponse *r4) {
                    STAssertFalse(r4.success, [NSString stringWithFormat:@"[%@]#4 Request failed", section]);
                    STAssertTrue(r4.errorcode == 402, [NSString stringWithFormat:@"[%@]#4 Already rated errorcode", section]);
                    done = YES;
                }];
            }];
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

@end


