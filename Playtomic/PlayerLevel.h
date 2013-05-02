#import <Foundation/Foundation.h>

@interface PlayerLevel : NSObject
@property (nonatomic, strong) NSString *levelid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *playerid;
@property (nonatomic, strong) NSString *playername;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *data;
@property (nonatomic) NSInteger votes;
@property (nonatomic) NSDecimal rating;
@property (nonatomic) NSInteger score;
@property (strong) NSDate *date;
@property (nonatomic, strong) NSString *rdate;
@property (nonatomic, strong) NSDictionary *fields;

- (id)initWithDictionary:(NSDictionary*)level;

@end
