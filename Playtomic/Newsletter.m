#import "Playtomic.h"
#import "Newsletter.h"
#import "PResponse.h"
#import "PRequest.h"

NSString *const NEWSLETTER_SECTION = @"newsletter";
NSString *const NEWSLETTER_SUBSCRIBE = @"subscribe";

@implementation Newsletter

- (void) subscribe:(NSDictionary *)options andHandler:(void (^)(PResponse *))handler
{
    [PRequest requestWithSection:NEWSLETTER_SECTION
                       andAction:NEWSLETTER_SUBSCRIBE
                     andPostData:options
                      andHandler:^(NSDictionary* json, NSError *error)
     {
         PResponse *response;
         
         if(!error) {
             int success = [[json objectForKey:@"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(response);
     }];
}

@end
