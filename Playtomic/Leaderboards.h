#import <Foundation/Foundation.h>
#import "PResponse.h"
#import "PlayerScore.h"

@interface Leaderboards : NSObject {
    
}

- (void) list:(NSMutableDictionary*)options andHandler:(void(^)(NSArray *scores, int numscores, PResponse *response))handler;
- (void) save:(PlayerScore*)score andHandler:(void(^)(PResponse *response))handler;
- (void) saveAndList:(PlayerScore*)score  andOptions:(NSDictionary*)options andHandler:(void(^)(NSArray *scores, int numscores, PResponse *response))handler;

@end

