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
