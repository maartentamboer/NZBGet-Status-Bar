//
//  SettingsWindowController.h
//  NZBGet_Status_Bar
//
//  Created by Maarten Tamboer on 29-10-13.
//  Copyright (c) 2013 Maarten Tamboer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSJSONRPC.h"


@interface SettingsWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *NZBGet_Location;

@property (weak) IBOutlet NSTextField *NZBGet_Username;
@property (weak) IBOutlet NSTextField *NZBGet_Password;

@property (weak) IBOutlet NSTextField *updateHigh;
@property (weak) IBOutlet NSTextField *updateLow;

@property (weak) IBOutlet NSButton *autoUpdateCheck;



@property (strong, nonatomic) DSJSONRPC *_jsonRPC;

-(void)getNZBGeturl:(NSString *)sURL;


@end
