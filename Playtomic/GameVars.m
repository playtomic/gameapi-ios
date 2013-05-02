#import "Playtomic.h"
#import "GameVars.h"
#import "PResponse.h"
#import "PRequest.h"

NSString *const GAMEVARS_SECTION = @"gamevars";
NSString *const GAMEVARS_LOAD = @"load";
NSString *const GAMEVARS_LOADSINGLE = @"single";

@implementation GameVars

- (void)load:(void (^)(NSDictionary* gamevars, PResponse *response))handler
{
    [PRequest requestWithSection:GAMEVARS_SECTION
                       andAction:GAMEVARS_LOAD
                     andPostData:nil
                      andHandler:^(NSDictionary* json, NSError *error)
     {
         PResponse *response;
         NSMutableDictionary *gamevars;
         
         if(!error) {
             gamevars = [[NSMutableDictionary alloc] init];
             for(id key in json)
             {
                 if([key isEqualToString: @"success"] || [key isEqualToString: @"errorcode"])
                 {
                     continue;
                 }
                 
                 [gamevars setObject:[json objectForKey: key] forKey:key];
             }
             
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey: @"errorcode"] integerValue];
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(gamevars, response);
     }];
}

- (void)loadWithName:(NSString*)name andHandler:(void (^)(NSDictionary* gamevars, PResponse *response)) handler
{
    [PRequest requestWithSection:GAMEVARS_SECTION
                       andAction:GAMEVARS_LOADSINGLE
                     andPostData:[NSDictionary dictionaryWithObject:name forKey:@"name"]
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableDictionary *gamevars;
         
         if(!error) {             
             gamevars = [[NSMutableDictionary alloc] init];
             for(id key in json)
             {
                 if([key isEqualToString: @"success"] || [key isEqualToString: @"errorcode"])
                 {
                     continue;
                 }
                
                 [gamevars setObject:[json objectForKey: key] forKey: [NSString stringWithFormat: @"%@", key]];
             }
             
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey: @"errorcode"] integerValue];
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler([NSDictionary dictionaryWithDictionary:gamevars], response);
     }];
}

@end
