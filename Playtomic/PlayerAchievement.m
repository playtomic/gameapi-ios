#import "PlayerAchievement.h"
#import "PlayerAward.h"

@implementation PlayerAchievement
@synthesize achievement;
@synthesize achievementkey;
@synthesize playername;
@synthesize playerid;
@synthesize source;
@synthesize date;
@synthesize rdate;
@synthesize fields;
@synthesize player;
@synthesize friends;
@synthesize allowduplicates;
@synthesize overwrite;

- (id)initWithDictionary:(NSDictionary*)ach
{
    if([ach objectForKey:@"achievement"] != nil)
    {
        self.achievement = [ach objectForKey:@"achievement"];
    }
    
    if([ach objectForKey:@"playername"] != nil)
    {
        self.playername = [ach objectForKey:@"playername"];
    }
    
    if([ach objectForKey: @"playerid"] != nil)
    {
        self.playerid = [ach objectForKey:@"playerid"];
    }
    
    if([ach objectForKey: @"source"] != nil)
    {
        self.source = [ach objectForKey:@"source"];
    }
        
    if([ach objectForKey: @"date"] != nil)
    {
        self.date = [ach objectForKey:@"date"];
    }
    
    if([ach objectForKey: @"rdate"] != nil)
    {
        self.rdate = [ach objectForKey:@"rdate"];
    }
    
    if([ach objectForKey: @"fields"] != nil)
    {
        self.fields = [ach objectForKey:@"fields"];
    }
    
    if([ach objectForKey:@"player"] != nil)
    {
        self.player = [[PlayerAward alloc] initWithDictionary: [ach objectForKey:@"player"]];
    }
    
    if([ach objectForKey:@"friends"] != nil)
    {
        NSArray *achievementsraw = (NSArray*)[ach objectForKey:@"friends"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[achievementsraw count]];
        
        for(id key in achievementsraw)
        {
            [array addObject:[[PlayerAward alloc] initWithDictionary:key]];
        }
        
        self.friends = array;
    }
    
    return self;
}

@end