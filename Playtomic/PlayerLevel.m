#import "PlayerLevel.h"
#import "Playtomic.h"

@implementation PlayerLevel
@synthesize levelid;
@synthesize name;
@synthesize playerid;
@synthesize playername;
@synthesize source;
@synthesize data;
@synthesize votes;
@synthesize rating;
@synthesize score;
@synthesize date;
@synthesize rdate;
@synthesize fields;

- (id) initWithDictionary:(NSDictionary*)level
{
    if([level objectForKey: @"levelid"] != nil)
    {
        self.levelid = [level objectForKey:@"levelid"];
    }

    if([level objectForKey: @"name"] != nil)
    {
        self.name = [level objectForKey:@"name"];
    }

    if([level objectForKey: @"playerid"] != nil)
    {
        self.playerid = [level objectForKey:@"playerid"];
    }

    if([level objectForKey: @"playername"] != nil)
    {
        self.playername = [level objectForKey:@"playername"];
    }

    if([level objectForKey: @"source"] != nil)
    {
        self.source = [level objectForKey:@"source"];
    }

    if([level objectForKey: @"date"] != nil)
    {
        self.data = [level objectForKey:@"data"];
    }

    if([level objectForKey: @"votes"] != nil)
    {
        self.votes = [[level objectForKey:@"votes"] integerValue];
    }

    if([level objectForKey: @"rating"] != nil)
    {
        self.rating = [[level objectForKey:@"rating"] decimalValue];
    }

    if([level objectForKey: @"score"] != nil)
    {
        self.score = [[level objectForKey:@"score"] integerValue];
    }

    if([level objectForKey: @"rdate"] != nil)
    {
        self.rdate = [level objectForKey:@"rdate"];
    }

    if([level objectForKey: @"fields"] != nil)
    {
        self.fields = [level objectForKey:@"fields"];
    }
    return self;
}

@end
