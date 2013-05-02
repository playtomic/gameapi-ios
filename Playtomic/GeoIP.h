#import <Foundation/Foundation.h>
#import "PResponse.h"
#import "PlayerCountry.h"

@interface GeoIP : NSObject {
}

- (void) lookup:(void (^)(PlayerCountry* country, PResponse *response))handler;

@end
