#import "PResponse.h"

@implementation PResponse
@synthesize success;
@synthesize errorcode;

- (id)initWithErrorCode:(NSInteger)perrorcode
{
    self.success = NO;
    self.errorcode = perrorcode;
    return self;
}

- (id)initWithSuccess:(int)psuccess
         andErrorCode:(NSInteger)perrorcode
{
    self.success = psuccess == 1;
    self.errorcode = perrorcode;
    return self;
}

@end
