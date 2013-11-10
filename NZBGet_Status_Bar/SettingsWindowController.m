//
//  SettingsWindowController.m
//  NZBGet_Status_Bar
//
//  Created by Maarten Tamboer on 29-10-13.
//  Copyright (c) 2013 Maarten Tamboer. All rights reserved.
//

#import "SettingsWindowController.h"

@interface OnlyIntegerValueFormatter : NSNumberFormatter

@end

@implementation OnlyIntegerValueFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    
    return YES;
}

@end


@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (id)init {
	return [super initWithWindowNibName:@"SettingsWindowController"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
   // NSLog(@"Read key: %@\n", [defaults objectForKey:@"Username"]);
    [_NZBGet_Username setStringValue:[defaults objectForKey:@"Username"]];
    [_NZBGet_Password setStringValue:[defaults objectForKey:@"Password"]];
    [_NZBGet_Location setStringValue:[defaults objectForKey:@"Location"]];
    BOOL bAutoUp =[defaults boolForKey:@"AutoUpdate"];
    [_autoUpdateCheck setState:bAutoUp];
    [_updateHigh setEnabled:bAutoUp];
    [_updateLow setEnabled:bAutoUp];
    [_updateHigh setIntegerValue:[defaults integerForKey:@"UpdateHigh"]];
    [_updateLow setIntegerValue:[defaults integerForKey:@"UpdateLow"]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)okClicked:(NSButton *)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_NZBGet_Username stringValue] forKey:@"Username"];
    [defaults setObject:[_NZBGet_Password stringValue] forKey:@"Password"];
    [defaults setObject:[_NZBGet_Location stringValue] forKey:@"Location"];
    [defaults setBool:[_autoUpdateCheck state] forKey:@"AutoUpdate"];
    [defaults setInteger:[_updateHigh integerValue] forKey:@"UpdateHigh"];
    [defaults setInteger:[_updateLow integerValue] forKey:@"UpdateLow"];
    [self close];
}

- (IBAction)testClicked:(NSButton *)sender {
    NSString *username =[_NZBGet_Username stringValue];
    NSString *password =[_NZBGet_Password stringValue];
    NSString *location =[_NZBGet_Location stringValue];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@@%@/jsonrpc", username, password, location ];
    NSLog(@"Testing with URL: %@\n", url);
    
    
    self._jsonRPC = [[DSJSONRPC alloc] initWithServiceEndpoint:[NSURL URLWithString:url]];
    
    // We're going to use a standard completion handler for our json-rpc calls
    DSJSONRPCCompletionHandler completionHandler = ^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError *internalError) {
        if (methodError) {
            NSLog(@"\nMethod %@(%li) returned an error: %@\n\n", methodName, (long)callId, methodError);
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setInformativeText:[NSString stringWithFormat:@"Result:\n%@\n", methodError]];
            [alert setMessageText:@"Test Failed"];
            [alert runModal];
        }
        else if (internalError) {
            NSLog(@"\nMethod %@(%li) couldn't be sent with error: %@\n\n", methodName, (long)callId, internalError);
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setInformativeText:[NSString stringWithFormat:@"Result:\n%@\n", internalError]];
            [alert setMessageText:@"Test Failed"];
            [alert runModal];
        }
        else {
            NSLog(@"\nMethod %@(%li) completed with result: %@\n\n", methodName, (long)callId, methodResult);
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setInformativeText:[NSString stringWithFormat:@"Result:\nVersion = %@\n", methodResult]];
            [alert setMessageText:@"Test succeeded"];
            [alert runModal];
            //NSLog(@"Result %@\n",[methodResult objectForKey:@"DownloadRate"]);
            //NSLog(@"Val = %@");
        }
    };
    
    NSInteger callId;
    
    // Example of a method call with no parameters that returns a string representation of the current time
    callId = [self._jsonRPC callMethod:@"version" onCompletion:completionHandler];
    NSLog(@"\n*** now called with id: %li\n\n", (long)callId);

    
}

- (IBAction)autoUpdateClicked:(NSButton *)sender {
    [_updateHigh setEnabled:[sender state]];
    [_updateLow setEnabled:[sender state]];
}

- (void)getNZBGeturl:(NSString *)sURL{
  //  NSString *username =[_NZBGet_Username stringValue];
  //  NSString *password =[_NZBGet_Password stringValue];
  //  NSString *location =[_NZBGet_Location stringValue];
    //sURL = ;
  //  [sURL setValue:[NSString stringWithFormat:@"http://%@:%@@%@/jsonrpc", username, password, location ]];
}

@end
