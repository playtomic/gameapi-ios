#import <SenTestingKit/SenTestingKit.h>

@interface AchievementsTest : SenTestCase {
    int rnd;
}

+ (int) rnd;
- (void) test0List;
- (void) test1ListWithFriends;
- (void) test2ListWithPlayer;
- (void) test3ListWithPlayerAndFriends;
- (void) test4Stream;
- (void) test5StreamWithFriends;
- (void) test6StreamWithPlayerAndFriends;
- (void) test7Save;

@end