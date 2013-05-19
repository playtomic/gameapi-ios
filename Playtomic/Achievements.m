#import "Achievements.h"
#import "PResponse.h"
#import "Playtomic.h"
#import "PlayerAchievement.h"
#import "PlayerAward.h"
#import "PRequest.h"

@interface Achievements()
@end

NSString *const ACHIEVEMENTS_SECTION = @"achievements";
NSString *const ACHIEVEMENTS_LIST = @"list";
NSString *const ACHIEVEMENTS_SAVE = @"save";
NSString *const ACHIEVEMENTS_STREAM = @"stream";

@implementation Achievements

- (void) list:(NSDictionary*)options andHandler:(void(^)(NSArray *achievements, PResponse *response))handler
{
    [PRequest requestWithSection:ACHIEVEMENTS_SECTION
                       andAction:ACHIEVEMENTS_LIST
                     andPostData:options
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableArray *achievements;
         
         if(!error) {
             id achievementsjson = [json objectForKey:@"achievements"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             NSArray *achievementsraw = (NSArray*)achievementsjson;
             
             achievements = [NSMutableArray arrayWithCapacity:[achievementsraw count]];
             
             for(id key in achievementsraw)
             {
                 [achievements addObject:[[PlayerAchievement alloc] initWithDictionary:key]];
             }
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
         }
         
         handler(achievements, response);
     }];
}

- (void) stream:(NSDictionary*)options andHandler:(void (^)(NSArray *achievements, int numachievements, PResponse *response))handler
{
    [PRequest requestWithSection:ACHIEVEMENTS_SECTION
                       andAction:ACHIEVEMENTS_STREAM
                     andPostData:options
                      andHandler:^(id json, NSError *error)
     {
         PResponse *response;
         NSMutableArray *achievements;
         NSInteger numachievements;
         
         if(!error) {
             id achievementsjson = [json objectForKey:@"achievements"];
             int success = [[json objectForKey: @"success"] integerValue];
             NSInteger errorcode = [[json objectForKey:@"errorcode"] integerValue];
             NSArray *achievementsraw = (NSArray*)achievementsjson;
             
             numachievements = [[json objectForKey:@"numachievements"] integerValue];
             achievements = [NSMutableArray arrayWithCapacity:[achievementsraw count]];
             
             for(id key in achievementsraw)
             {
                 [achievements addObject:[[PlayerAward alloc] initWithDictionary:key]];
             }
             
             response = [[PResponse alloc] initWithSuccess:success andErrorCode:errorcode];
         }else{
             response = [[PResponse alloc] initWithErrorCode:1];
             numachievements = 0;
         }
         
         handler(achievements, numachievements, response);
     }];
}

- (void) save:(PlayerAchievement*)achievement andHandler:(void(^)(PResponse *response))handler
{
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    
    if(achievement.playername != nil)
    {
        [postdata setObject:achievement.playername forKey:@"playername"];
    }
    
    if(achievement.playerid != nil)
    {
        [postdata setObject:achievement.playerid forKey:@"playerid"];
    }
    
    if(achievement.achievement != nil)
    {
        [postdata setObject:achievement.achievement forKey:@"achievement"];
    }
    
    if(achievement.achievementkey != nil)
    {
        [postdata setObject:achievement.achievementkey forKey:@"achievementkey"];
    }
    
    if(achievement.source != nil)
    {
        [postdata setObject:achievement.source forKey:@"source"];
    }
    
    if(achievement.fields != nil)
    {
        [postdata setObject:achievement.fields forKey:@"fields"];
    }
    
    [postdata setObject:[NSNumber numberWithBool:achievement.overwrite] forKey:@"overwrite"];
    [postdata setObject:[NSNumber numberWithBool:achievement.allowduplicates] forKey:@"allowduplicates"];
    
    [PRequest requestWithSection:ACHIEVEMENTS_SECTION
                       andAction:ACHIEVEMENTS_SAVE
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

@end