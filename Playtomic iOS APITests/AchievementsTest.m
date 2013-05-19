#import "AchievementsTest.h"
#import "Playtomic.h"
#import "PResponse.h"
#import "PlayerAchievement.h"
#import "PlayerAward.h"

@interface AchievementsTest ()
@property (nonatomic, readwrite) int rnd;
@end

@implementation AchievementsTest
@synthesize rnd;

- (void) setUp
{
    self.rnd = [AchievementsTest rnd];
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

- (void) test0List
{
    NSString *section = @"achievements.list";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerAchievement *achievement1 = [[PlayerAchievement alloc] init];
    achievement1.achievement = @"Super Mega Achievement #1";
    achievement1.achievementkey = @"secretkey";
    achievement1.playerid = @"1";
    achievement1.playername = @"ben";
    achievement1.fields = fields;
    
    PlayerAchievement *achievement2 = [[PlayerAchievement alloc] init];
    achievement2.achievement = @"Super Mega Achievement #1";
    achievement2.achievementkey = @"secretkey";
    achievement2.playerid = @"2";
    achievement2.playername = @"michelle";
    achievement2.fields = fields;
    
    PlayerAchievement *achievement3 = [[PlayerAchievement alloc] init];
    achievement3.achievement = @"Super Mega Achievement #1";
    achievement3.achievementkey = @"secretkey";
    achievement3.playerid = @"3";
    achievement3.playername = @"peter";
    achievement3.fields = fields;
    
    PlayerAchievement *achievement4 = [[PlayerAchievement alloc] init];
    achievement4.achievement = @"Super Mega Achievement #2";
    achievement4.achievementkey = @"secretkey2";
    achievement4.playerid = @"3";
    achievement4.playername = @"peter";
    achievement4.fields = fields;
    
    PlayerAchievement *achievement5 = [[PlayerAchievement alloc] init];
    achievement5.achievement = @"Super Mega Achievement #2";
    achievement5.achievementkey = @"secretkey2";
    achievement5.playerid = @"2";
    achievement5.playername = @"michelle";
    achievement5.fields = fields;
    
    [[Playtomic Achievements] save:achievement1 andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        [NSThread sleepForTimeInterval:2];
        
        [[Playtomic Achievements] save:achievement2 andHandler:^(PResponse* r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 0, [NSString stringWithFormat:@"[%@]#2 No errorcode", section]);
            [NSThread sleepForTimeInterval:2];
            
            [[Playtomic Achievements] save:achievement3 andHandler:^(PResponse* r3) {
                STAssertTrue(r3.success, [NSString stringWithFormat:@"[%@]#3 Request succeeded", section]);
                STAssertTrue(r3.errorcode == 0, [NSString stringWithFormat:@"[%@]#3 No errorcode", section]);
                [NSThread sleepForTimeInterval:2];
                
                [[Playtomic Achievements] save:achievement4 andHandler:^(PResponse* r4) {
                    STAssertTrue(r4.success, [NSString stringWithFormat:@"[%@]#4 Request succeeded", section]);
                    STAssertTrue(r4.errorcode == 0, [NSString stringWithFormat:@"[%@]#4 No errorcode", section]);
                    [NSThread sleepForTimeInterval:2];
                    
                    [[Playtomic Achievements] save:achievement5 andHandler:^(PResponse* r5) {
                        STAssertTrue(r5.success, [NSString stringWithFormat:@"[%@]#5 Request succeeded", section]);
                        STAssertTrue(r5.errorcode == 0, [NSString stringWithFormat:@"[%@]#5 No errorcode", section]);
                        
                        NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
                        [list setObject:fields forKey:@"filters"];
                        
                        [[Playtomic Achievements] list:list andHandler:^(NSArray* achievements, PResponse* r6) {
                            STAssertTrue(r6.success, [NSString stringWithFormat:@"[%@]#6 Request succeeded", section]);
                            STAssertTrue(r6.errorcode == 0, [NSString stringWithFormat:@"[%@]#6 No errorcode", section]);
                            PlayerAchievement *return1 = [achievements objectAtIndex:0];
                            PlayerAchievement *return2 = [achievements objectAtIndex:1];
                            PlayerAchievement *return3 = [achievements objectAtIndex:2];
                            STAssertTrue([return1.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@]#6 Achievement 1 is correct", section]);
                            STAssertTrue([return2.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@]#6 Achievement 2 is correct", section]);
                            STAssertTrue([return3.achievement isEqualToString:@"Super Mega Achievement #3"], [NSString stringWithFormat:@"[%@]#6 Achievement 3 is correct", section]);
                            done = YES;
                        }];
                    }];
                 }];
            }];
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test1ListWithFriends
{
    NSString *section = @"achievements.listwithfriends";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    [friends addObject:@"1"];
    [friends addObject:@"2"];
    [friends addObject:@"3"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    [list setObject:friends forKey:@"friendslist"];
    
    [[Playtomic Achievements] list:list andHandler:^(NSArray* achievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        PlayerAchievement *return1 = [achievements objectAtIndex:0];
        PlayerAchievement *return2 = [achievements objectAtIndex:1];
        PlayerAchievement *return3 = [achievements objectAtIndex:2];
        STAssertTrue([return1.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue([return2.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue([return3.achievement isEqualToString:@"Super Mega Achievement #3"], [NSString stringWithFormat:@"[%@] Achievement 3 is correct", section]);
        STAssertTrue(return1.friends != nil, [NSString stringWithFormat:@"[%@] Achievement 1 has friends", section]);
        STAssertTrue(return2.friends != nil, [NSString stringWithFormat:@"[%@] Achievement 2 has friends", section]);
        STAssertTrue(return3.friends == nil, [NSString stringWithFormat:@"[%@] Achievement 3 has no friends", section]);
        STAssertTrue([return1.friends count] == 3, [NSString stringWithFormat:@"[%@] Achievement 1 has 3 friends", section]);
        PlayerAward* r1f1 = [return1.friends objectAtIndex:0];
        PlayerAward* r1f2 = [return1.friends objectAtIndex:1];
        PlayerAward* r1f3 = [return1.friends objectAtIndex:2];
        STAssertTrue([r1f1.playername isEqualToString: @"ben"], [NSString stringWithFormat:@"[%@] Achievement 1 friend 1", section]);
        STAssertTrue([r1f2.playername isEqualToString: @"michelle"], [NSString stringWithFormat:@"[%@] Achievement 1 friend 2", section]);
        STAssertTrue([r1f3.playername isEqualToString: @"peter"], [NSString stringWithFormat:@"[%@] Achievement 1 friend 3", section]);
        PlayerAward* r2f1 = [return2.friends objectAtIndex:0];
        PlayerAward* r2f2 = [return2.friends objectAtIndex:1];
        STAssertTrue([r2f1.playername isEqualToString: @"michelle"], [NSString stringWithFormat:@"[%@] Achievement 2 friend 1", section]);
        STAssertTrue([r2f2.playername isEqualToString: @"peter"], [NSString stringWithFormat:@"[%@] Achievement 2 friend 2", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test2ListWithPlayer
{
    NSString *section = @"achievements.listwithplayer";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    [list setObject:@"1" forKey:@"playerid"];
    
    [[Playtomic Achievements] list:list andHandler:^(NSArray* achievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        PlayerAchievement *return1 = [achievements objectAtIndex:0];
        PlayerAchievement *return2 = [achievements objectAtIndex:1];
        PlayerAchievement *return3 = [achievements objectAtIndex:2];
        STAssertTrue([return1.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue([return2.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue([return3.achievement isEqualToString:@"Super Mega Achievement #3"], [NSString stringWithFormat:@"[%@] Achievement 3 is correct", section]);
        STAssertTrue(return1.friends == nil, [NSString stringWithFormat:@"[%@] Achievement 1 has no friends", section]);
        STAssertTrue(return2.friends == nil, [NSString stringWithFormat:@"[%@] Achievement 2 has no friends", section]);
        STAssertTrue(return3.friends == nil, [NSString stringWithFormat:@"[%@] Achievement 3 has no friends", section]);
        STAssertTrue(return1.player != nil, [NSString stringWithFormat:@"[%@] Achievement 1 has player", section]);
        STAssertTrue(return2.player == nil, [NSString stringWithFormat:@"[%@] Achievement 2 has no player", section]);
        STAssertTrue(return3.player == nil, [NSString stringWithFormat:@"[%@] Achievement 3 has no player", section]);
        STAssertTrue([return1.player.playername isEqualToString: @"ben"], [NSString stringWithFormat:@"[%@] Achievement 1 player is ben", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test3ListWithPlayerAndFriends
{
    NSString *section = @"achievements.listwithplayerandfriends";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    [friends addObject:@"2"];
    [friends addObject:@"3"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    [list setObject:friends forKey:@"friendslist"];
    [list setObject:@"1" forKey:@"playerid"];
    
    [[Playtomic Achievements] list:list andHandler:^(NSArray* achievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        PlayerAchievement *return1 = [achievements objectAtIndex:0];
        PlayerAchievement *return2 = [achievements objectAtIndex:1];
        PlayerAchievement *return3 = [achievements objectAtIndex:2];
        STAssertTrue([return1.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue([return2.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue([return3.achievement isEqualToString:@"Super Mega Achievement #3"], [NSString stringWithFormat:@"[%@] Achievement 3 is correct", section]);
        STAssertTrue(return1.friends != nil, [NSString stringWithFormat:@"[%@] Achievement 1 has friends", section]);
        STAssertTrue(return2.friends != nil, [NSString stringWithFormat:@"[%@] Achievement 2 has friends", section]);
        STAssertTrue(return3.friends == nil, [NSString stringWithFormat:@"[%@] Achievement 3 has no friends", section]);
        STAssertTrue(return1.player != nil, [NSString stringWithFormat:@"[%@] Achievement 1 has player", section]);
        STAssertTrue(return2.player == nil, [NSString stringWithFormat:@"[%@] Achievement 2 has no player", section]);
        STAssertTrue(return3.player == nil, [NSString stringWithFormat:@"[%@] Achievement 3 has no player", section]);
        STAssertTrue([return1.friends count] == 2, [NSString stringWithFormat:@"[%@] Achievement 1 has 2 friends", section]);
        STAssertTrue([return2.friends count] == 2, [NSString stringWithFormat:@"[%@] Achievement 2 has 2 friends", section]);
        PlayerAward* r1f1 = [return1.friends objectAtIndex:0];
        PlayerAward* r1f2 = [return1.friends objectAtIndex:1];
        STAssertTrue([r1f1.playername isEqualToString: @"michelle"], [NSString stringWithFormat:@"[%@] Achievement 1 friend 1", section]);
        STAssertTrue([r1f2.playername isEqualToString: @"peter"], [NSString stringWithFormat:@"[%@] Achievement 1 friend 2", section]);
        PlayerAward* r2f1 = [return2.friends objectAtIndex:0];
        PlayerAward* r2f2 = [return2.friends objectAtIndex:1];
        STAssertTrue([r2f1.playername isEqualToString: @"michelle"], [NSString stringWithFormat:@"[%@] Achievement 2 friend 1", section]);
        STAssertTrue([r2f2.playername isEqualToString: @"peter"], [NSString stringWithFormat:@"[%@] Achievement 2 friend 2", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test4Stream
{
    NSString *section = @"achievements.stream";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    
    [[Playtomic Achievements] stream:list andHandler:^(NSArray* achievements, int numachievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([achievements count] == 5, [NSString stringWithFormat:@"[%@] 5 achievements returned", section]);
        STAssertTrue(numachievements == 5, [NSString stringWithFormat:@"[%@] 5 achievements total", section]);
        PlayerAward *return1 = [achievements objectAtIndex:0];
        PlayerAward *return2 = [achievements objectAtIndex:1];
        PlayerAward *return3 = [achievements objectAtIndex:2];
        PlayerAward *return4 = [achievements objectAtIndex:3];
        PlayerAward *return5 = [achievements objectAtIndex:4];
        STAssertTrue([return1.playername isEqualToString:@"michelle"], [NSString stringWithFormat:@"[%@] Achievement 1 person", section]);
        STAssertTrue([return1.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue([return2.playername isEqualToString:@"peter"], [NSString stringWithFormat:@"[%@] Achievement 2 person", section]);
        STAssertTrue([return2.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue([return3.playername isEqualToString:@"peter"], [NSString stringWithFormat:@"[%@] Achievement 3 person", section]);
        STAssertTrue([return3.awarded.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 3 is correct", section]);
        STAssertTrue([return4.playername isEqualToString:@"michelle"], [NSString stringWithFormat:@"[%@] Achievement 4 person", section]);
        STAssertTrue([return4.awarded.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 4 is correct", section]);
        STAssertTrue([return5.playername isEqualToString:@"ben"], [NSString stringWithFormat:@"[%@] Achievement 5 person", section]);
        STAssertTrue([return5.awarded.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 5 is correct", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test5StreamWithFriends
{
    NSString *section = @"achievements.streamwithfriends";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    [friends addObject:@"2"];
    [friends addObject:@"3"];

    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    [list setObject:[NSNumber numberWithBool:YES] forKey:@"group"];
    [list setObject:friends forKey:@"friendslist"];
    
    [[Playtomic Achievements] stream:list andHandler:^(NSArray* achievements, int numachievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([achievements count] == 2, [NSString stringWithFormat:@"[%@] 2 achievements returned", section]);
        STAssertTrue(numachievements == 2, [NSString stringWithFormat:@"[%@] 2 achievements total", section]);
        PlayerAward *return1 = [achievements objectAtIndex:0];
        PlayerAward *return2 = [achievements objectAtIndex:1];
        STAssertTrue([return1.playername isEqualToString:@"michelle"], [NSString stringWithFormat:@"[%@] Achievement 1 person", section]);
        STAssertTrue([return1.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue(return1.awards == 2, [NSString stringWithFormat:@"[%@] Achievement 1 awards", section]);
        STAssertTrue([return2.playername isEqualToString:@"peter"], [NSString stringWithFormat:@"[%@] Achievement 2 person", section]);
        STAssertTrue([return2.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue(return2.awards == 2, [NSString stringWithFormat:@"[%@] Achievement 2 awards", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test6StreamWithPlayerAndFriends
{
    NSString *section = @"achievements.streamwithplayerandfriends";
    __block BOOL done = NO;
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableArray *friends = [[NSMutableArray alloc] init];
    [friends addObject:@"2"];
    [friends addObject:@"3"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:filters forKey:@"filters"];
    [list setObject:[NSNumber numberWithBool:YES] forKey:@"group"];
    [list setObject:friends forKey:@"friendslist"];
    [list setObject:@"1" forKey:@"playerid"];
    
    [[Playtomic Achievements] stream:list andHandler:^(NSArray* achievements, int numachievements, PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([achievements count] == 3, [NSString stringWithFormat:@"[%@] 3 achievements returned", section]);
        STAssertTrue(numachievements == 3, [NSString stringWithFormat:@"[%@] 3 achievements total", section]);
        PlayerAward *return1 = [achievements objectAtIndex:0];
        PlayerAward *return2 = [achievements objectAtIndex:1];
        PlayerAward *return3 = [achievements objectAtIndex:2];
        STAssertTrue([return1.playername isEqualToString:@"michelle"], [NSString stringWithFormat:@"[%@] Achievement 1 person", section]);
        STAssertTrue([return1.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 1 is correct", section]);
        STAssertTrue(return1.awards == 2, [NSString stringWithFormat:@"[%@] Achievement 1 awards", section]);
        STAssertTrue([return2.playername isEqualToString:@"peter"], [NSString stringWithFormat:@"[%@] Achievement 2 person", section]);
        STAssertTrue([return2.awarded.achievement isEqualToString:@"Super Mega Achievement #2"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue(return2.awards == 2, [NSString stringWithFormat:@"[%@] Achievement 2 awards", section]);
        STAssertTrue([return3.playername isEqualToString:@"ben"], [NSString stringWithFormat:@"[%@] Achievement 2 person", section]);
        STAssertTrue([return3.awarded.achievement isEqualToString:@"Super Mega Achievement #1"], [NSString stringWithFormat:@"[%@] Achievement 2 is correct", section]);
        STAssertTrue(return3.awards == 1, [NSString stringWithFormat:@"[%@] Achievement 1 awards", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void) test7Save
{
    NSString *section = @"achievements.save";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerAchievement *achievement = [[PlayerAchievement alloc] init];
    achievement.achievement = @"Super Mega Achievement #1";
    achievement.achievementkey = @"secretkey";
    achievement.playerid = [NSString stringWithFormat:@"%d", rnd];
    achievement.playername = [NSString stringWithFormat:@"a random name %d", rnd];
    achievement.fields = fields;
    
    [[Playtomic Achievements] save:achievement andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        [NSThread sleepForTimeInterval:2];
        
        [[Playtomic Achievements] save:achievement andHandler:^(PResponse* r2) {
            STAssertTrue(r2.success == false, [NSString stringWithFormat:@"[%@]#2 Request failed", section]);
            STAssertTrue(r2.errorcode == 506, [NSString stringWithFormat:@"[%@]#2 Already had errorcode", section]);
            [NSThread sleepForTimeInterval:2];
            
            achievement.overwrite = true;
            
            [[Playtomic Achievements] save:achievement andHandler:^(PResponse* r3) {
                STAssertTrue(r3.success, [NSString stringWithFormat:@"[%@]#3 Request succeeded", section]);
                STAssertTrue(r3.errorcode == 505, [NSString stringWithFormat:@"[%@]#3 Already had achievement errorcode", section]);
                [NSThread sleepForTimeInterval:2];
                
                achievement.allowduplicates = true;
                achievement.overwrite = false;
                
                [[Playtomic Achievements] save:achievement andHandler:^(PResponse* r4) {
                    STAssertTrue(r4.success, [NSString stringWithFormat:@"[%@]#4 Request succeeded", section]);
                    STAssertTrue(r4.errorcode == 505, [NSString stringWithFormat:@"[%@]#4 No errorcode", section]);
                    done = YES;
                }];
            }];
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

@end
