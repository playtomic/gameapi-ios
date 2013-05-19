#import <Foundation/Foundation.h>
#import "PResponse.h"
#import "PlayerAchievement.h"
#import "PlayerAward.h"

@interface Achievements : NSObject

- (void) list:(NSMutableDictionary*)options
   andHandler:(void(^)(NSArray *achievements, PResponse *response))handler;
- (void) save:(PlayerAchievement*)achievement
   andHandler:(void(^)(PResponse *response))handler;
- (void) stream:(NSMutableDictionary*)options
          andHandler:(void(^)(NSArray *achievements, int numachievements, PResponse *response))handler;

@end

