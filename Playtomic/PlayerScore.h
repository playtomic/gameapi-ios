#import <Foundation/Foundation.h>

@interface PlayerScore : NSObject 
@property (nonatomic, strong) NSString *playername;
@property (nonatomic, strong) NSString *playerid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic) int64_t points;
@property (nonatomic) NSInteger rank;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *rdate;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSString *table;
@property (nonatomic) Boolean allowduplicates;
@property (nonatomic) Boolean highest;
@property (nonatomic) Boolean submitted;

- (id)initWithDictionary:(NSDictionary*)score;

@end
