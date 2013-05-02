#import "Playtomic.h"
#import "GeoIP.h"
#import "PResponse.h"
#import "PRequest.h"
#import "PlayerCountry.h"

NSString *const GEOIP_SECTION = @"geoip";
NSString *const GEOIP_LOOKUP = @"lookup";

@implementation GeoIP

- (void) lookup:(void (^)(PlayerCountry* country, PResponse *response))handler
{
    [PRequest requestWithSection:GEOIP_SECTION
                       andAction:GEOIP_LOOKUP
                     andPostData:nil
                      andHandler:^(NSDictionary* json, NSError *error)
     {
         PResponse *response;
         PlayerCountry *country;
         
         if(!error) {
             NSString* name = [json objectForKey: @"name"];
             NSString* code = [json objectForKey: @"code"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey: @"errorcode"] integerValue];
             country = [[PlayerCountry alloc] initWithName:name andCode:code];
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(country, response);
     }];
}

@end
