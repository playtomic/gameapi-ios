#import <Foundation/Foundation.h>
#import "GameVars.h"
#import "GeoIP.h"
#import "Leaderboards.h"
#import "PlayerLevels.h"
#import "Achievements.h"
#import "Newsletter.h"

@interface Playtomic : NSObject {
    GameVars *gamevars;
    GeoIP *geoIP;
    Leaderboards *leaderboards;
    PlayerLevels *playerlevels;
    Achievements *achievements;
    Newsletter *newsletter;
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
+ (Newsletter*)Newsletter;
+ (NSString*)apiURL;
+ (NSString*)privateKey;
+ (NSString*)publicKey;

@end
