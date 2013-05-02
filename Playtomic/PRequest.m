//  Pilfered from openkit.io.
//
//  OKNetworker.m
//  OKNetworker
//
//  Created by Manuel Martinez-Almeida on 9/2/13.
//  Copyright (c) 2013 OpenKit. All rights reserved.
//

#import "Playtomic.h"
#import "PRequest.h"
#import "PEncode.h"
#import "AFNetworking.h"

static AFHTTPClient* _httpClient = nil;
static NSString* _path = nil;

@implementation PRequest

+ (AFHTTPClient*) httpClient
{
    if(!_httpClient) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: [Playtomic apiURL]]];
        //[_httpClient setParameterEncoding:AFJSONParameterEncoding];
        [_httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        [_httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    }
    return _httpClient;
}

+ (NSString*) path
{
    if(_path == nil) {
        _path = [NSString stringWithFormat:@"/v1?publickey=%@", [Playtomic publicKey]];
    }
    
    return _path;
}

+ (void) requestWithSection:(NSString*)section
                  andAction:(NSString*)action
                andPostData:(NSDictionary*)data
                 andHandler:(void (^)(id responseObject, NSError* error))handler
{
    
    NSMutableDictionary *jsondict = [[NSMutableDictionary alloc] init];
    [jsondict addEntriesFromDictionary:data];
    [jsondict setObject:[Playtomic publicKey] forKey:@"publickey"];
    [jsondict setObject:section forKey:@"section"];
    [jsondict setObject:action forKey:@"action"];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:jsondict options:kNilOptions error:nil];
    NSString *jsonstring = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSString *md5 = [PEncode md5: [NSString stringWithFormat:@"%@%@", jsonstring, [Playtomic privateKey]]];
    NSString *b64 = [PEncode encodeBase64WithString:jsonstring];
    
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] init];
    [postdata setObject:md5 forKey:@"hash"];
    [postdata setObject:b64 forKey:@"data"];
    [postdata setObject:@"true" forKey:@"json"];
    
    AFHTTPClient *httpclient = [self httpClient];    
    NSMutableURLRequest *request = [httpclient requestWithMethod:@"POST"
                                                            path:[self path]
                                                      parameters:postdata];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                                                 success:^(NSURLRequest *req, NSHTTPURLResponse *response, id json) {
        handler(json, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        handler(json, error);
    }];

    [operation start];
}

@end