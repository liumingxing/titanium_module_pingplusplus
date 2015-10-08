/**
 * pingxx_ios
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComMamashaiPingxxModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import "Pingpp.h"

@implementation ComMamashaiPingxxModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"188c955e-3d78-4e29-bbc3-9ecc20cca761";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.mamashai.pingxx";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)pay:(id)args{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    [Pingpp setDebugMode:YES];
    
    //[super fireEvent:@"my_event" withObject:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@?order_no=%@&channel=%@&amount=%@",
                    [TiUtils stringValue:[args valueForKey:@"url"]],
                    [TiUtils stringValue:[args valueForKey:@"order_no"]],
                    [TiUtils stringValue:[args valueForKey:@"channel"]],
                    [TiUtils stringValue:[args valueForKey:@"amount"]]];
    NSLog(@"url:  %@", url);
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [postRequest setHTTPMethod:@"GET"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"statusCode = %@", httpResponse.statusCode);
            return;
        }
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            return;
        }
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~11");
        
        TiModule* _app = self;
        
        UIViewController * __weak weakSelf = [[TiApp app] controller];
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~22");
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:[TiUtils stringValue:[args valueForKey:@"url_scheme"]] withCompletion:^(NSString *result, PingppError *error) {
            
            NSLog(@"~~~~~~~~~~~~~~~~~~~~~~33");
            
            [weakSelf showAlertMessage:result];
            
            [_app fireEvent:@"my_event0" withObject:nil];
            
            NSLog(@"completion block: %@", result);
            if (error == nil) {
                [_app fireEvent:@"my_event1" withObject:nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"code",result, nil];
                
                [_app fireEvent:@"ping_paid" withObject:dict];
                NSLog(@"PingppError is nil");
            } else {
                [_app fireEvent:@"my_event2" withObject:nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"code", error.code, @"text", [error getMsg], nil];
                
                [_app fireEvent:@"ping_paid" withObject:dict];
                
                NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
            }
            
            
        }];
    }];
}

@end
