#import <Foundation/Foundation.h>
#import "PResponse.h"

@interface Newsletter : NSObject {
}

- (void) subscribe:(NSDictionary*)options andHandler:(void (^)(PResponse *response))handler;

@end
