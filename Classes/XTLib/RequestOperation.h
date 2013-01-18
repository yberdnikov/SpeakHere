//
//  RequestOperation.h
//
//
//  Created by 耿 建峰 on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "COMMON.h"


@protocol RequestOperationDelegate;

@interface RequestOperation : NSOperation<ASIHTTPRequestDelegate>
{
    id<RequestOperationDelegate> delegate;
    REQUESTTYPE _type;
    
    NSDictionary *dictContent;
    ASIHTTPRequest *httpRequest;
}
@property (nonatomic, assign) id<RequestOperationDelegate> delegate;
@property (nonatomic, assign) REQUESTTYPE _type;
@property (nonatomic, retain) NSDictionary *dictContent;
@property (nonatomic, retain) ASIHTTPRequest *httpRequest;

// init
- (id) initWithDict:(NSDictionary *)dict
           delegate:(id<RequestOperationDelegate>)theDelegate 
               type:(REQUESTTYPE)type;

// google语音识别
- (void) uploadAudioToGoogle:(NSString *)sURL;
- (void)requestCancel;
@end

@protocol RequestOperationDelegate
- (void)didFinishRequest:(id)sender;
- (void)requestError:(NSError *)error;
@end
