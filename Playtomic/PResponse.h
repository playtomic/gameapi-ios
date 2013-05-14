#import <Foundation/Foundation.h>

@interface PResponse : NSObject
@property (nonatomic, assign, readwrite) NSInteger errorcode;
@property (nonatomic, assign, readwrite) Boolean success;

- (id)initWithErrorCode:(NSInteger)errorcode;

- (id)initWithSuccess:(int)success
         andErrorCode:(NSInteger)errorcode;

- (NSString*) errorMessage;

@end