#import <SenTestingKit/SenTestingKit.h>

@interface LeaderboardsTest : SenTestCase {
    int rnd;
}

+ (int) rnd;
- (void) test0FirstScore;
- (void) test1SecondScore;
- (void) test2HighScores;
- (void) test3LowScores;
- (void) test4AllScores;
- (void) test5FriendsScores;
- (void) test6OwnScores;
@end
