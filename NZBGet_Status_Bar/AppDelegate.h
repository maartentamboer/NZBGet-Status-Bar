//
//  AppDelegate.h
//  NZBGet_Status_Bar
//
//  Created by Maarten Tamboer on 27-10-13.
//  Copyright (c) 2013 Maarten Tamboer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DSJSONRPC.h"
#import "SettingsWindowController.h"

struct NZBGetStatusStruct{
    NSInteger RemainingSizeMB;
    NSInteger DownloadRate;
    NSInteger ThreadCount;
    NSInteger PostJobCount;
    NSInteger UpTimeSec;
    BOOL ServerStandBy;
    BOOL ServerPaused;
    BOOL DownloadPaused;
    BOOL Download2Paused;
    BOOL PostPaused;
};


@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSString* sNZBGeturl;
    BOOL bAutoupdate;
    NSInteger iUpdateLow;
    NSInteger iUpdateHigh;
    BOOL bDownloading;
    struct NZBGetStatusStruct NZBGetStatus;
}

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSMenu *statusMenu;

@property (strong, nonatomic) NSStatusItem *statusBar;


@property (weak) IBOutlet NSMenuItem *downSpeed;


@property (weak) IBOutlet NSMenu *queueList;


@property (strong, nonatomic) DSJSONRPC *_jsonRPC;

@property (strong) NSTimer *updateTimer;

@property (strong) SettingsWindowController *settingsWindow;


//Setting variables


-(void) updateVarsFromDefaults;
-(void) updateUI;
-(void) updateTimers;

@end
