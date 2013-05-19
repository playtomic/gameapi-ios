#import <Foundation/Foundation.h>

@class PlayerAchievement;

@interface PlayerAward : NSObject
@property (nonatomic, strong) NSString *playername;
@property (nonatomic, strong) NSString *playerid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *rdate;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, strong) PlayerAchievement *awarded;
@property (nonatomic) int64_t awards;

- (id)initWithDictionary:(NSDictionary*)award;

@end
