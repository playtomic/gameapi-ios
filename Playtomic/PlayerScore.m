#import "PlayerScore.h"

@implementation PlayerScore
@synthesize playername;
@synthesize playerid;
@synthesize source;
@synthesize points;
@synthesize rank;
@synthesize date;
@synthesize rdate;
@synthesize fields;
@synthesize table;
@synthesize allowduplicates;
@synthesize highest;

- (id)initWithDictionary:(NSDictionary*)score
{
    if([score objectForKey:@"playername"] != nil)
    {
        self.playername = [score objectForKey:@"playername"];
    }
    
    if([score objectForKey: @"playerid"] != nil)
    {
        self.playerid = [score objectForKey:@"playerid"];
    }

    if([score objectForKey: @"source"] != nil)
    {
        self.source = [score objectForKey:@"source"];
    }
    
    if([score objectForKey: @"rank"] != nil)
    {
        self.rank = [[score objectForKey:@"rank"] integerValue];
    }
    
    if([score objectForKey: @"points"] != nil)
    {
        self.points = [[score objectForKey:@"points"] longValue];
    }

    if([score objectForKey: @"date"] != nil)
    {
        self.date = [score objectForKey:@"date"];
    }

    if([score objectForKey: @"rdate"] != nil)
    {
        self.rdate = [score objectForKey:@"rdate"];
    }

    if([score objectForKey: @"fields"] != nil)
    {
        self.fields = [score objectForKey:@"fields"];
    }
    
    return self;
}

@end