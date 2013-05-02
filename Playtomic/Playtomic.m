#import "Playtomic.h"
#import "UIKit/UIDevice.h"

@interface Playtomic ()
@property (strong) GameVars *gamevars;
@property (strong) GeoIP *geoip;
@property (strong) Leaderboards *leaderboards;
@property (strong) PlayerLevels *playerlevels;
@property (strong) NSString *apiURL;
@property (strong) NSString *privateKey;
@property (strong) NSString *publicKey;
@end

@implementation Playtomic
@synthesize gamevars;
@synthesize geoip;
@synthesize leaderboards;
@synthesize playerlevels;
@synthesize apiURL;
@synthesize privateKey;
@synthesize publicKey;

static Playtomic *instance = nil;

+ (void)initWithPublicKey:(NSString*)publickey
            andPrivateKey:(NSString*)privatekey
                andAPIURL:(NSString*)apiurl;
{
    if (instance == nil)
    {
        instance = [[self alloc] init];
    }
    
    instance.privateKey = privatekey;
    instance.publicKey = publickey;
    instance.apiURL = apiurl;
    instance.gamevars = [[GameVars alloc] init];
    instance.geoip = [[GeoIP alloc] init];
    instance.leaderboards = [[Leaderboards alloc] init];
    instance.playerlevels = [[PlayerLevels alloc] init];  
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.gamevars = nil;
    self.geoip = nil;
    self.leaderboards = nil;
    self.playerlevels = nil;
    self.apiURL = nil;
    self.privateKey = nil;
    self.publicKey = nil;
}

+ (GameVars*)GameVars
{
	return instance.gamevars;
}

+ (GeoIP*)GeoIP
{
    return instance.geoip;
}

+ (Leaderboards*)Leaderboards
{
    return instance.leaderboards;
}
 
+ (PlayerLevels*)PlayerLevels
{
     return instance.playerlevels;
}

+ (NSString*)apiURL
{
    return instance.apiURL;
}

+ (NSString*)privateKey
{
    return instance.privateKey;
}

+ (NSString*)publicKey
{
    return instance.publicKey;
}


@end
