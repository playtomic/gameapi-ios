#import "NewsletterTest.h"
#import "Playtomic.h"
#import "PResponse.h"

@implementation NewsletterTest

- (void) testSubscribe
{
    NSString *section = @"newsletter.testSubscribe";
    __block BOOL done = NO;
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:@"invalid email@test.com" forKey:@"email"];
    
    // rejected
    [[Playtomic Newsletter] subscribe:options andHandler:^(PResponse* r){
        STAssertFalse(r.success, [NSString stringWithFormat:@"[%@]#1 Request failed", section]);
        STAssertTrue(r.errorcode == 602, [NSString stringWithFormat:@"[%@]#1 MailChimp API error", section]);
        
        // works
        [options setObject:@"valid@testuri.com" forKey:@"email"];
        [[Playtomic Newsletter] subscribe:options andHandler:^(PResponse* r2){
            STAssertTrue(r2.success, [NSString stringWithFormat:@"[%@]#2 Request succeeded", section]);
            STAssertTrue(r2.errorcode == 0, [NSString stringWithFormat:@"[%@]#2 No errorcode", section]);
            done = YES;
        }];
    }];
    
    while (!done) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(100000);
    }
}
@end
