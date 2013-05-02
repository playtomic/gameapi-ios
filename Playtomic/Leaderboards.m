#import "Leaderboards.h"
#import "PResponse.h"
#import "Playtomic.h"
#import "PlayerScore.h"
#import "PRequest.h"


@interface Leaderboards()
@end

NSString *const LEADERBOARDS_SECTION = @"leaderboards";
NSString *const LEADERBOARDS_LIST = @"list";
NSString *const LEADERBOARDS_SAVE = @"save";
NSString *const LEADERBOARDS_SAVEANDLIST = @"saveandlist";

@implementation Leaderboards

- (void) list:(NSMutableDictionary*)options andHandler:(void(^)(NSArray *scores, int numscores, PResponse *response))handler
{
    [PRequest requestWithSection:LEADERBOARDS_SECTION
                       andAction:LEADERBOARDS_LIST
                     andPostData:options
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableArray *scores;
         NSInteger numscores;

         if(!error) {
             id scoresjson = [json objectForKey:@"scores"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             NSArray *scoresraw = (NSArray*)scoresjson;

             numscores = [[json objectForKey:@"numscores"] integerValue];
             scores = [NSMutableArray arrayWithCapacity:[scoresraw count]];
             
             for(id key in scoresraw)
             {
                 [scores addObject:[[PlayerScore alloc] initWithDictionary:key]];
             }

             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
             numscores = 0;
         }
         
         handler(scores, numscores, response);
     }];
}

- (void) save:(PlayerScore*)score andHandler:(void(^)(PResponse *response))handler
{
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    
    if(score.name != nil)
    {
        [postdata setObject:score.name forKey:@"name"];
    }
    
    if(score.playerid != nil)
    {
        [postdata setObject:score.playerid forKey:@"playerid"];
    }
    
    if(score.source != nil)
    {
        [postdata setObject:score.source forKey:@"source"];
    }
    
    if(score.fields != nil)
    {
        [postdata setObject:score.fields forKey:@"fields"];
    }
    
    if(score.table != nil)
    {
        [postdata setObject:score.table forKey:@"table"];
    }
    
    [postdata setObject:[NSNumber numberWithLong:score.points] forKey:@"points"];
    [postdata setObject:[NSNumber numberWithBool:score.highest] forKey:@"highest"];
    [postdata setObject:[NSNumber numberWithBool:score.allowduplicates] forKey:@"allowduplicates"];

    [PRequest requestWithSection:LEADERBOARDS_SECTION
                       andAction:LEADERBOARDS_SAVE
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

- (void) saveAndList:(PlayerScore*)score andOptions:(NSMutableDictionary*)options andHandler:(void(^)(NSArray *scores, int numscores, PResponse *response))handler
{
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithDictionary:options];

    if(score.name != nil)
    {
        [postdata setObject:score.name forKey:@"name"];
    }
    
    if(score.playerid != nil)
    {
        [postdata setObject:score.playerid forKey:@"playerid"];
    }
    
    if(score.source != nil)
    {
        [postdata setObject:score.source forKey:@"source"];
    }
    
    if(score.fields != nil)
    {
        [postdata setObject:score.fields forKey:@"fields"];
    }
    
    if(score.table != nil)
    {
        [postdata setObject:score.table forKey:@"table"];
    }
    
    [postdata setObject:[NSNumber numberWithLong:score.points] forKey:@"points"];
    [postdata setObject:[NSNumber numberWithBool:score.highest] forKey:@"highest"];
    [postdata setObject:[NSNumber numberWithBool:score.allowduplicates] forKey:@"allowduplicates"];
    
    [PRequest requestWithSection:LEADERBOARDS_SECTION
                       andAction:LEADERBOARDS_SAVEANDLIST
                     andPostData:postdata
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableArray *scores;
         NSInteger numscores;
         
         if(!error) {
             id scoresjson = [json objectForKey:@"scores"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             NSArray *scoresraw = (NSArray*)scoresjson;
             
             numscores = [[json objectForKey:@"numscores"] integerValue];
             scores = [NSMutableArray arrayWithCapacity:[scoresraw count]];
             
             for(id key in scoresraw)
             {
                 [scores addObject:[[PlayerScore alloc] initWithDictionary:key]];
             }
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
             numscores = 0;
         }
         
         handler(scores, numscores, response);
     }];
}

@end
