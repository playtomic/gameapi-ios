#import <Foundation/Foundation.h>


@interface PEncode : NSObject {
    
}

+ (NSString*) md5:(NSString*)string;

+ (NSString *)encodeBase64WithString:(NSString *)strData;

+ (NSString *)encodeBase64WithData:(NSData *)objData;

+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

@end
