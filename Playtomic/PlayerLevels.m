#import "PlayerLevels.h"
#import "PlayerLevel.h"
#import "PResponse.h"
#import "PRequest.h"
#import "Playtomic.h"

@interface PlayerLevels() 
@end

NSString *const PLAYERLEVELS_SECTION = @"playerlevels";
NSString *const PLAYERLEVELS_LOAD = @"load";
NSString *const PLAYERLEVELS_RATE = @"rate";
NSString *const PLAYERLEVELS_SAVE = @"save";
NSString *const PLAYERLEVELS_LIST = @"list";

@implementation PlayerLevels

- (void)load:(NSString*)levelid andHandler:(void(^)(PlayerLevel *level, PResponse *response))handler
{
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc]init];
    [postdata setObject:levelid forKey:@"levelid"];
    
    [PRequest requestWithSection:PLAYERLEVELS_SECTION
                       andAction:PLAYERLEVELS_LOAD
                     andPostData:postdata
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         PlayerLevel *level;
         if(!error) {
             id leveljson = [json objectForKey:@"level"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             level = [[PlayerLevel alloc] initWithDictionary:leveljson];
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         handler(level, response);
     }];
}

- (void)rate:(NSString*)levelid andRating:(int)rating andHandler:(void(^)(PResponse *response))handler
{
    if(rating < 1 || rating > 10)
    {
        handler([[PResponse alloc] initWithErrorCode:401]);
        return;
    }
    
    NSMutableDictionary* postdata = [[NSMutableDictionary alloc] init];
    [postdata setValue:[NSNumber numberWithInteger:rating] forKey:@"rating"];
    [postdata setValue:levelid forKey:@"levelid"];
    
    [PRequest requestWithSection:PLAYERLEVELS_SECTION
                       andAction:PLAYERLEVELS_RATE
                     andPostData:postdata
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         
         if(!error) {
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(response);
     }];
}

- (void)list:(NSDictionary*)options andHandler:(void(^)(NSArray *levels, int numlevels, PResponse *response))handler
{    
    [PRequest requestWithSection:PLAYERLEVELS_SECTION
                       andAction:PLAYERLEVELS_LIST
                     andPostData:options
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableArray *levels;
         NSInteger numlevels;
         
         if(!error) {
             id levelsjson = [json objectForKey:@"levels"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             NSArray *levelsraw = (NSArray*)levelsjson;
             
             numlevels = [[json objectForKey:@"numlevels"] integerValue];
             levels = [NSMutableArray arrayWithCapacity:[levelsraw count]];
             
             for(id key in levelsraw)
             {
                 [levels addObject:[[PlayerLevel alloc] initWithDictionary:key]];
             }
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
             numlevels = 0;
         }
         
         handler(levels, numlevels, response);
     }];
}

- (void)save:(PlayerLevel*)level andHandler:(void(^)(PlayerLevel *level, PResponse *response))handler
{
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    
    if(level.name != nil)
    {
        [postdata setObject:level.name forKey:@"name"];
    }
    
    if(level.playerid != nil)
    {
        [postdata setObject:level.playerid forKey:@"playerid"];
    }
    
    if(level.playername != nil)
    {
        [postdata setObject:level.playername forKey:@"playername"];
    }
    
    if(level.source != nil)
    {
        [postdata setObject:level.source forKey:@"source"];
    }
    
    if(level.data != nil)
    {
        [postdata setObject:level.data forKey:@"data"];
    }
    
    if(level.fields != nil)
    {
        [postdata setObject:level.fields forKey:@"fields"];
    }

    [PRequest requestWithSection:PLAYERLEVELS_SECTION
                       andAction:PLAYERLEVELS_SAVE
                     andPostData:postdata
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         PlayerLevel *level;
         
         if(!error) {
             
             id leveljson = [json objectForKey:@"level"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             level = [[PlayerLevel alloc] initWithDictionary:leveljson];
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(level, response);
     }];
}

@end
