#import <Foundation/Foundation.h>
#import "PlayerLevel.h"
#import "PResponse.h"

@interface PlayerLevels : NSObject {
}

- (void)load:(NSString*)levelid andHandler:(void(^)(PlayerLevel *level, PResponse *response))handler;
- (void)rate:(NSString*)levelid andRating:(int)rating andHandler: (void(^)(PResponse *response))handler;
- (void)list:(NSDictionary*)options andHandler:(void (^)(NSArray *levels, int numlevels, PResponse *response))handler;
- (void)save:(PlayerLevel*)level andHandler:(void(^)(PlayerLevel *level, PResponse *response))handler;

@end
