//
//  OKNetworker.h
//  OKNetworker
//
//  Created by Manuel Martinez-Almeida on 9/2/13.
//  Copyright (c) 2013 OpenKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPClient;
@interface PRequest : NSObject

+ (AFHTTPClient*) httpClient;
+ (NSString*) path;

+ (void) requestWithSection:(NSString*)section
                  andAction:(NSString*)action
                andPostData:(NSDictionary*)postdata
                 andHandler:(void (^)(id responseObject, NSError* error))handler;

@end