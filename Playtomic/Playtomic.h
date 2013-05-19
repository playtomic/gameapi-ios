#import <Foundation/Foundation.h>
#import "GameVars.h"
#import "GeoIP.h"
#import "Leaderboards.h"
#import "PlayerLevels.h"
#import "Achievements.h"

@interface Playtomic : NSObject {
    GameVars *gamevars;
    GeoIP *geoIP;
    Leaderboards *leaderboards;
    PlayerLevels *playerlevels;
    Achievements *achievements;
    NSString *apiURL;
    NSString *privateKey;
    NSString *publicKey;
}

+ (void)initWithPublicKey:(NSString*)publickey
            andPrivateKey:(NSString*)privatekey
                andAPIURL:(NSString*)apiUrl;

+ (GameVars*)GameVars;
+ (GeoIP*)GeoIP;
+ (Leaderboards*)Leaderboards;
+ (PlayerLevels*)PlayerLevels;
+ (Achievements*)Achievements;
+ (NSString*)apiURL;
+ (NSString*)privateKey;
+ (NSString*)publicKey;

@end
