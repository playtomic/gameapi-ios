#import <Foundation/Foundation.h>
#import "PResponse.h"

@interface GameVars : NSObject {
}

- (void) load:(void (^)(NSDictionary* gamevars, PResponse *response))handler;
- (void) loadWithName:(NSString*) name
           andHandler:(void (^)(NSDictionary* gamevars, PResponse *response))handler;

@end