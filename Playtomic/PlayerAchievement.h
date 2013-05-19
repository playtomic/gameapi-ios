#import <Foundation/Foundation.h>

@class PlayerAward;

@interface PlayerAchievement : NSObject
@property (nonatomic, strong) NSString *achievement;
@property (nonatomic, strong) NSString *achievementkey;
@property (nonatomic, strong) NSString *playername;
@property (nonatomic, strong) NSString *playerid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *rdate;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, strong) PlayerAward *player;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic) Boolean allowduplicates;
@property (nonatomic) Boolean overwrite;

- (id)initWithDictionary:(NSDictionary*)ach;

@end
