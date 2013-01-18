//
//  RequestOperation.m
//  
//
//  Created by 耿 建峰 on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RequestOperation.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"
#import "ASIInputStream.h"

@implementation RequestOperation
@synthesize delegate, _type;
@synthesize dictContent;
@synthesize httpRequest;

- (id) initWithDict:(NSDictionary *)dict
           delegate:(id<RequestOperationDelegate>)theDelegate 
               type:(REQUESTTYPE)type
{
    if((self = [super init]))
    {
        self.dictContent = dict;
        self.delegate = theDelegate;
        self._type = type;
    }
    return self;
}

- (void) main
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    switch (_type)
    {
        case REQUEST_GOOGLE_AUDIO:
        {
            [self uploadAudioToGoogle:GOOGLE_AUDIO_URL];
            break;
        }
        default:
            break;
    }
    
    [pool release];
}

- (void) uploadAudioToGoogle:(NSString *)sURL
{
    NSLog(@"%@", sURL);
    NSURL *url = [NSURL URLWithString:sURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"audio/x-flac; rate=16000"];
    
    request.requestMethod = @"POST";
    
    NSString *filePath_dest = [NSTemporaryDirectory() stringByAppendingFormat:@"dest.flac"];
    NSLog(@"dest.flac path:%@", filePath_dest);
    [request appendPostDataFromFile:filePath_dest];
    NSLog(@"%@", request.postData);

    self.httpRequest = request;
    
	[request startSynchronous];
    NSError *error = [request error];
	if (!error) 
	{
		NSString *responseString = [request responseString];
        NSLog(@"sURL:%@\n谷歌返回内容:%@", sURL, responseString);
        // 解析Google语音识别返回的内容
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dic = [parser objectWithString:responseString];
        if(dic == nil || [dic count] <= 0)
        {
            [parser release];
            if(![self isCancelled])
                [delegate requestError:nil];
            return;
        }
        NSArray *array = [dic objectForKey:@"hypotheses"];
        NSLog(@"%@", array);
        NSDictionary *dic_hypotheses = [array objectAtIndex:0];
        NSLog(@"%@", dic_hypotheses);
        NSString *sContent = [NSString stringWithFormat:@"%@", [dic_hypotheses objectForKey:@"utterance"]];

        if(sContent != nil && [sContent length] > 0)
        {
            if(![self isCancelled])
                [delegate didFinishRequest:sContent];
        }
        [parser release];
	}
	if((nil != error) && [error localizedDescription])
	{
        NSError *error = [request error];
        NSLog(@"error = %@",error);
        
        if(![self isCancelled])
            [delegate requestError:error];
	}
}
#pragma mark -

- (void)requestCancel
{
    if(httpRequest && ![httpRequest isFinished])
    {
        [httpRequest cancel];
    }
}

- (void) dealloc
{   
    [self requestCancel];
    if(httpRequest)
        self.httpRequest = nil;
    if(dictContent)
        self.dictContent = nil;
    [super dealloc];
}
@end
