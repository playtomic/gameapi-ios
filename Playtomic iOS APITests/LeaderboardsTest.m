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
    score.playername = @"person1";
    score.points = 10000;
    score.fields = fields;
    score.table = [NSString stringWithFormat:@"scores%d", rnd];
    score.highest = true;
    
    [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@]#1 Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@]#1 No errorcode", section]);
        
        // duplicate score gets rejected
        score.points = 9000;
        
        [NSThread sleepForTimeInterval:1];
    
        [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r2) {
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 209, [NSString stringWithFormat:@"[%@]#2 Rejected duplicate score", section]);
            
            // better score gets accepted
            score.points = 11000;
            
            [NSThread sleepForTimeInterval:1];
            
            [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r3) {
                STAssertTrue(r3.success, [NSString stringWithFormat:@"[%@]#3 Request succeeded", section]);
                STAssertTrue(r3.errorcode == 0, [NSString stringWithFormat:@"[%@]#3 No errorcode", section]);
                
                // score gets allowed
                score.allowduplicates = true;
                score.points = 9000;
                
                [NSThread sleepForTimeInterval:1];
                
                [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r4) {
                    STAssertTrue(r4.success, [NSString stringWithFormat:@"[%@]#4 Request succeeded", section]);
                    STAssertTrue(r4.errorcode == 0, [NSString stringWithFormat:@"[%@]#4 No errorcode", section]);
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
    score.playername = @"person2";
    score.points = 20000;
    score.fields = fields;
    score.table = [NSString stringWithFormat:@"scores%d", rnd];
    score.highest = true;
    score.allowduplicates = true;
    
    [NSThread sleepForTimeInterval:1];
    
    [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
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
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
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
        usleep(10000);
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
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
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
        usleep(10000);
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
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
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
        usleep(10000);
    }
}

- (void) test5FriendsScores
{
    NSString *section = @"leaderboards.friendsscores";
    __block int submitted = 0;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    for(int i=0; i<10; i++)
    {
        PlayerScore *score = [[PlayerScore alloc] init];
        score.playername = [NSString stringWithFormat: @"person%d", i];
        score.points = i * 1000;
        score.fields = fields;
        score.table = [NSString stringWithFormat:@"friends%d", rnd];
        score.highest = true;
        score.allowduplicates = true;
        score.playerid = [NSString stringWithFormat: @"%d", (i+1)];
        
        [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
            STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
            STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
            submitted++;
        }];
    }
    
    // wait for our first 10 scores to be done
    while (submitted < 10) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
    
    __block BOOL done = NO;
    
    NSMutableArray *friendslist = [[NSMutableArray alloc] init];
    [friendslist addObject:@"1"];
    [friendslist addObject:@"2"];
    [friendslist addObject:@"3"];
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSString stringWithFormat:@"friends%d", rnd] forKey:@"table"];
    [list setObject:[NSNumber numberWithInt:3] forKey:@"perpage"];
    [list setObject:friendslist forKey:@"friendslist"];
    
    [[Playtomic Leaderboards] list:list andHandler:^(NSArray *scores, int numscores, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([scores count] == 3, [NSString stringWithFormat:@"[%@] Received 3 scores", section]);
        STAssertTrue(numscores == 3, [NSString stringWithFormat:@"[%@] Received numscores 3", section]);
        
        PlayerScore *score1 = scores[0];
        PlayerScore *score2 = scores[1];
        PlayerScore *score3 = scores[2];
        
        STAssertTrue([score1.playerid isEqual:@"3"], [NSString stringWithFormat:@"[%@] Player id #1", section]);
        STAssertTrue([score2.playerid isEqual:@"2"], [NSString stringWithFormat:@"[%@] Player id #2", section]);
        STAssertTrue([score3.playerid isEqual:@"1"], [NSString stringWithFormat:@"[%@] Player id #3", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

- (void)test6OwnScores
{
    NSString *section = @"leaderboards.ownScores";
    __block int submitted = 0;
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    [fields setObject:[NSNumber numberWithInt:rnd] forKey:@"rnd"];
    
    int points = 0;
    
    for(int i=0; i<9; i++)
    {
        points += 1000;
        
        PlayerScore *score = [[PlayerScore alloc] init];
        score.playername = @"test account";
        score.points = points;
        score.fields = fields;
        score.table = [NSString stringWithFormat:@"personal%d", rnd];
        score.highest = true;
        score.allowduplicates = true;
        score.playerid = @"test@example.com";
        
        [[Playtomic Leaderboards] save:score andHandler:^(PResponse* r) {
            STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
            STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
            submitted++;
        }];
    }
    
    // wait for our first 9 scores to be done
    while (submitted < 9) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
    
    __block BOOL done = NO;
    
    PlayerScore *finalscore = [[PlayerScore alloc] init];
    finalscore.playername = @"test account";
    finalscore.points = 3000;
    finalscore.fields = fields;
    finalscore.table = [NSString stringWithFormat:@"personal%d", rnd];
    finalscore.highest = true;
    finalscore.allowduplicates = true;
    finalscore.playerid = @"test@example.com";
    
    NSMutableDictionary *list = [[NSMutableDictionary alloc] init];
    [list setObject:[NSNumber numberWithInt:5] forKey:@"perpage"];
    [list setObject:[NSString stringWithFormat:@"personal%d", rnd] forKey:@"table"];
    [list setObject:[NSNumber numberWithBool:true] forKey:@"highest"];
    [list setObject:@"test@example.com" forKey:@"playerid"];
    
    [[Playtomic Leaderboards] saveAndList:finalscore andOptions:list andHandler:^(NSArray *scores, int numscores, PResponse *r) {
        STAssertTrue(r.success, [NSString stringWithFormat:@"[%@] Request succeeded", section]);
        STAssertTrue(r.errorcode == 0, [NSString stringWithFormat:@"[%@] No errorcode", section]);
        STAssertTrue([scores count] == 5, [NSString stringWithFormat:@"[%@] Received 5 scores", section]);
        STAssertTrue(numscores == 10, [NSString stringWithFormat:@"[%@] Received numscores 10", section]);
        PlayerScore *score1 = scores[0];
        PlayerScore *score2 = scores[1];
        PlayerScore *score3 = scores[2];
        PlayerScore *score4 = scores[3];
        PlayerScore *score5 = scores[4];
        STAssertTrue(score1.rank == 6, [NSString stringWithFormat:@"[%@] Score 1 ranked 6", section]);
        STAssertTrue(score2.rank == 7, [NSString stringWithFormat:@"[%@] Score 2 ranked 7", section]);
        STAssertTrue(score3.rank == 8, [NSString stringWithFormat:@"[%@] Score 3 ranked 8", section]);
        STAssertTrue(score4.rank == 9, [NSString stringWithFormat:@"[%@] Score 4 ranked 9", section]);
        STAssertTrue(score5.rank == 10, [NSString stringWithFormat:@"[%@] Score 5 ranked 10", section]);
        STAssertTrue(score1.points == 4000, [NSString stringWithFormat:@"[%@] Score 1 points", section]);
        STAssertTrue(score2.points == 3000, [NSString stringWithFormat:@"[%@] Score 2 points", section]);
        STAssertTrue(score3.points == 3000, [NSString stringWithFormat:@"[%@] Score 3 points", section]);
        STAssertTrue(score4.points == 2000, [NSString stringWithFormat:@"[%@] Score 4 points", section]);
        STAssertTrue(score5.points == 1000, [NSString stringWithFormat:@"[%@] Score 5 points", section]);
        done = YES;
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
}

@end
