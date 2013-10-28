//
//  AppDelegate.m
//  NZBGet_Status_Bar
//
//  Created by Maarten Tamboer on 27-10-13.
//  Copyright (c) 2013 Maarten Tamboer. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate


@synthesize statusMenu = _statusMenu;
@synthesize statusBar = _statusBar;

@synthesize queueList = _queueList;




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (void)timerTicked:(NSTimer*)timer {
    NSLog(@"Timer Ticked!!\n");
    
}

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"NZBGet";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
   _updateTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (IBAction)clickedRefresh:(NSMenuItem *)sender {
    [_downSpeed setTitle:@"1.12 MB/S"];
    [[_statusMenu itemAtIndex:3]setTitle:@"Queue 3"];
    NSMenuItem *newMenu = [[NSMenuItem alloc] initWithTitle:@"New" action:NULL keyEquivalent:@""];
    [_queueList addItem:newMenu];
    
    self._jsonRPC = [[DSJSONRPC alloc] initWithServiceEndpoint:[NSURL URLWithString:@"http://nzbget:nzbget@192.168.0.108:6789/jsonrpc"]];
    
    // We're going to use a standard completion handler for our json-rpc calls
    DSJSONRPCCompletionHandler completionHandler = ^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError *internalError) {
        if (methodError) {
            NSLog(@"\nMethod %@(%i) returned an error: %@\n\n", methodName, callId, methodError);
        }
        else if (internalError) {
            NSLog(@"\nMethod %@(%i) couldn't be sent with error: %@\n\n", methodName, callId, internalError);
        }
        else {
            NSLog(@"\nMethod %@(%i) completed with result: %@\n\n", methodName, callId, methodResult);
            //NSLog(@"Result %@\n",[methodResult objectForKey:@"DownloadRate"]);
            //NSLog(@"Val = %@");
        }
    };
    
    NSInteger callId;
    
    // Example of a method call with no parameters that returns a string representation of the current time
    callId = [self._jsonRPC callMethod:@"status" onCompletion:completionHandler];
    NSLog(@"\n*** now called with id: %li\n\n", (long)callId);
    
    callId = [self._jsonRPC callMethod:@"listfiles" withParameters:@{@"IDFrom": [NSNumber numberWithInt:0],@"IDTo": [NSNumber numberWithInt:0],@"NZBID": [NSNumber numberWithInt:0]} onCompletion:completionHandler];
    NSLog(@"\n*** now called with id: %li\n\n", (long)callId);
    
    [_updateTimer invalidate];
    _updateTimer = nil;
    _updateTimer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    

    
}


- (IBAction)clickedPref:(NSMenuItem *)sender {
}



@end
