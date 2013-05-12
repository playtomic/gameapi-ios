//
//  LeaderboardsTest.m
//  Playtomic iOS API
//
//  Created by Ben Lowry on 5/1/13.
//  Copyright (c) 2013 Ben Lowry. All rights reserved.
//

#import "LeaderboardsTest.h"
#import "Playtomic.h"
#import "PResponse.h"
#import "PlayerScore.h"

@interface LeaderboardsTest ()
@property (nonatomic, readwrite) int rnd;
@end

@implementation LeaderboardsTest
@synthesize rnd;

- (void) setUp
{
    self.rnd = [LeaderboardsTest rnd];
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

- (void) test0FirstScore
{
    NSString *section = @"leaderboards.firstscore";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerScore *score = [[PlayerScore alloc] init];
    score.name = @"person1";
    score.points = 10000;
    score.fields = fields;
    score.table = [NSString stringWithFormat:@"scores%d", rnd];
    score.highest = true;
    
    [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        
        // duplicate score gets rejected
        score.points = 9000;
    
        [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeded", section]);
            STAssertTrue(r2.errorcode == 209, [NSString stringWithFormat:@"[%@]#2 Rejected duplicate score", section]);
            
            // better score gets accepted
            score.points = 11000;
            
            [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
                STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeded", section]);
                STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
                
                // score gets allopwed
                score.allowduplicates = true;
                score.points = 9000;
                
                [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r3) {
                    STAssertTrue(r3.success, [NSString stringWithFormat:@"[%@]#3 Request succeded", section]);
                    STAssertTrue(r3.errorcode == 0, [NSString stringWithFormat:@"[%@]#3 No errorcode", section]);
                     done = YES;
                 }];
            }];
        }];
    }];
            
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(1000000);
    }
}

- (void) test1SecondScore
{
    NSString *section = @"leaderboards.secondscore";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    PlayerScore *score = [[PlayerScore alloc] init];
    score.name = @"person2";
    score.points = 20000;
    score.fields = fields;
    score.table = [NSString stringWithFormat:@"scores%d", rnd];
    score.highest = true;
    score.allowduplicates = true;
    
    [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        done = YES;
    }];
            
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(1000000);
    }
}

- (void) test2HighScores
{
    NSString *section = @"leaderboards.highscores";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];

    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSString stringWithFormat:@"scores%d", rnd] forKey:@"table"];
    [list setObject:[NSNumber numberWithBool:true] forKey:@"highest"];
    [list setObject:fields forKey:@"fields"];
    
    [[Playtomic Leaderboards] list:list andHandler:^(NSArray *scores, int numscores, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([scores count] > 0, [NSString stringWithFormat:@"[%@] Received scores", section]);
        STAssertTrue(numscores > 0, [NSString stringWithFormat:@"[%@] Received numscores", section]);

        if([scores count] > 1) {
            PlayerScore *score1 = scores[0];
            PlayerScore *score2 = scores[1];
            STAssertTrue(score1.points > score2.points, [NSString stringWithFormat:@"[%@] First score is greater than second", section]);
        } else {
            STAssertTrue(false, [NSString stringWithFormat:@"[%@] First score is greater than second forced failure", section]);
        }

        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) test3LowScores
{
    NSString *section = @"leaderboards.lowscores";
    __block BOOL done = NO;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSString stringWithFormat:@"scores%d", rnd] forKey:@"table"];
    [list setObject:[NSNumber numberWithBool:true] forKey:@"lowest"];
    [list setObject:fields forKey:@"fields"];
    [list setObject:[NSNumber numberWithInt:2] forKey:@"perpage"];
    
    [[Playtomic Leaderboards] list:list andHandler:^(NSArray *scores, int numscores, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([scores count] > 0, [NSString stringWithFormat:@"[%@] Received scores", section]);
        STAssertTrue(numscores > 0, [NSString stringWithFormat:@"[%@] Received numscores", section]);
        
        if([scores count] > 1) {
            PlayerScore *score1 = scores[0];
            PlayerScore *score2 = scores[1];
            STAssertTrue(score1.points < score2.points, [NSString stringWithFormat:@"[%@] First score is less than second", section]);
        } else {
            STAssertTrue(false, [NSString stringWithFormat:@"[%@] First score is less than second forced failure", section]);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

- (void) test4AllScores
{
    NSString *section = @"leaderboards.allscores";
    __block BOOL done = NO;
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSString stringWithFormat:@"scores%d", rnd] forKey:@"table"];
    [list setObject:[NSNumber numberWithInt:2] forKey:@"perpage"];
    [list setObject:@"newest" forKey:@"mode"];
    
    [[Playtomic Leaderboards] list:list andHandler:^(NSArray *scores, int numscores, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([scores count] > 0, [NSString stringWithFormat:@"[%@] Received scores", section]);
        STAssertTrue(numscores > 0, [NSString stringWithFormat:@"[%@] Received numscores", section]);

        if([scores count] > 1) {
            PlayerScore *score1 = scores[0];
            PlayerScore *score2 = scores[1];
            NSComparisonResult order = [score1.date compare:score2.date];
            STAssertTrue(order == NSOrderedDescending, [NSString stringWithFormat:@"[%@] First score is newer or equal to second", section]);
        } else {
            STAssertTrue(false, [NSString stringWithFormat:@"[%@] First score is newer or equal to second forced failure", section]);
        }
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}

@end
