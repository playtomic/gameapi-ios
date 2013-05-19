#import "PlayerAward.h"
#import "PlayerAchievement.h"

@implementation PlayerAward
@synthesize playername;
@synthesize playerid;
@synthesize source;
@synthesize date;
@synthesize rdate;
@synthesize fields;
@synthesize awarded;
@synthesize awards;

- (id)initWithDictionary:(NSDictionary*)award
{
    if([award objectForKey:@"playername"] != nil)
    {
        self.playername = [award objectForKey:@"playername"];
    }
    
    if([award objectForKey:@"playerid"] != nil)
    {
        self.playerid = [award objectForKey:@"playerid"];
    }
    
    if([award objectForKey:@"source"] != nil)
    {
        self.source = [award objectForKey:@"source"];
    }
    
    if([award objectForKey:@"date"] != nil)
    {
        self.date = [award objectForKey:@"date"];
    }
    
    if([award objectForKey:@"rdate"] != nil)
    {
        self.rdate = [award objectForKey:@"rdate"];
    }
    
    if([award objectForKey:@"fields"] != nil)
    {
        self.fields = [award objectForKey:@"fields"];
    }

    if([award objectForKey:@"awarded"] != nil)
    {
        self.awarded = [[PlayerAchievement alloc] initWithDictionary: [award objectForKey:@"awarded"]];
    }
    
    if([award objectForKey:@"awards"] != nil)
    {
        self.awards = [[award objectForKey:@"awards"] longValue];
    }
    
    return self;
}

@end