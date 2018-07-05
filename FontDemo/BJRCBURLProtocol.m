//
//  BJRCBURLProtocol.m
//  FontDemo
//
//  Created by 黄新 on 2018/7/5.
//  Copyright © 2018年 BJRCB. All rights reserved.
//

#import "BJRCBURLProtocol.h"

static NSString *const RCBURLProtocolHandledKey = @"RCBURLProtocolHandledKey";

@interface BJRCBURLProtocol()

@property (nonatomic, strong) NSURLConnection *connection;   ///< 连接对象
@property (nonatomic, strong) NSMutableData   *data;         ///< 返回数据
@property (nonatomic, strong) NSURLResponse   *response;     ///< 请求对象

@end

@implementation BJRCBURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSLog(@"---->%@",request.URL);
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame  ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"file"] == NSOrderedSame)){
        if ([NSURLProtocol propertyForKey:RCBURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

- (void)startLoading{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:RCBURLProtocolHandledKey inRequest:mutableReqeust];
    NSLog(@"URL-------->%@",self.request.URL);
    if ([[self.request.URL absoluteString] hasSuffix:@"ttf"] ||
        [[self.request.URL absoluteString] hasSuffix:@"TTF"]) {

        //带格式
        NSString *font = [self.request.URL.absoluteString lastPathComponent];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:font ofType:nil];
        
        NSData *fontData = [NSData dataWithContentsOfFile:path];
        
        NSURLResponse *response = [[NSURLResponse alloc] init];
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:fontData];
        [[self client] URLProtocolDidFinishLoading:self];
    }else{
        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

- (void)stopLoading{
    [self.connection cancel];
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    //保存网络获取的数据和数据对象
    self.data = [[NSMutableData alloc] init];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [[self client] URLProtocol:self didLoadData:data];
    //累加数据
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [[self client] URLProtocol:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [[self client] URLProtocolDidFinishLoading:self];
    if (!self.response || [self.data length] == 0) {
        return;
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    if (response) {
        // simply consider redirect as an error
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorResourceUnavailable userInfo:nil];
        [[self client] URLProtocol:self didFailWithError:error];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

@end
