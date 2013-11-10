//
//  AppDelegate.m
//  NZBGet_Status_Bar
//
//  Created by Maarten Tamboer on 27-10-13.
//  Copyright (c) 2013 Maarten Tamboer. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindowController.h"


@implementation AppDelegate


@synthesize statusMenu = _statusMenu;
@synthesize statusBar = _statusBar;

@synthesize queueList = _queueList;

@synthesize settingsWindow = _settingsWindow;

//@synthesize NZBGeturl = _NZBGeturl;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self updateVarsFromDefaults];
    bDownloading = NO;
    [self updateTimers];
}


- (void)timerTicked:(NSTimer*)timer {
   // NSLog(@"Timer Ticked!!\n");
    
    
    self._jsonRPC = [[DSJSONRPC alloc] initWithServiceEndpoint:[NSURL URLWithString:sNZBGeturl]];
    
    
    DSJSONRPCCompletionHandler completionHandler = ^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError *internalError) {
        if (methodError) {
            NSLog(@"\nMethod %@(%li) returned an error: %@\n\n", methodName, (long)callId, methodError);
        }
        else if (internalError) {
            NSLog(@"\nMethod %@(%li) couldn't be sent with error: %@\n\n", methodName, (long)callId, internalError);
        }
        else {
            //NSLog(@"\nMethod %@(%li) completed with result: %@\n\n", methodName, (long)callId, methodResult);
            //NSLog(@"Result %@\n",[methodResult objectForKey:@"DownloadRate"]);
            //NSLog(@"Val = %@");
            NZBGetStatus.RemainingSizeMB = [methodResult integerForKey:@"RemainingSizeMB"];
            NZBGetStatus.DownloadRate = [methodResult integerForKey:@"DownloadRate"];
            NZBGetStatus.ThreadCount = [methodResult integerForKey:@"ThreadCount"];
            NZBGetStatus.PostJobCount = [methodResult integerForKey:@"PostJobCount"];
            NZBGetStatus.UpTimeSec = [methodResult integerForKey:@"UpTimeSec"];
            NZBGetStatus.ServerStandBy = [methodResult boolForKey:@"ServerStandBy"];
            NZBGetStatus.ServerPaused = [methodResult boolForKey:@"ServerPaused"];
            NZBGetStatus.DownloadPaused = [methodResult boolForKey:@"DownloadPaused"];
            NZBGetStatus.Download2Paused = [methodResult boolForKey:@"Download2Paused"];
            NZBGetStatus.PostPaused = [methodResult boolForKey:@"PostPaused"];
            NSLog(@"Standby: %@\n",  NZBGetStatus.ServerStandBy?@"YES":@"NO");
            NSLog(@"Paused: %@\n",  NZBGetStatus.ServerPaused?@"YES":@"NO");
            [self updateUI];
            [self updateTimers];
            //NSLog(@"UpTime: %ld", (long)NZBGetStatus.UpTimeSec);
        }
    };

   [self._jsonRPC callMethod:@"status" onCompletion:completionHandler];
    
    
}


- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"NZBGet";
    NSLog(@"Image test!\n");
    // you can also set an image
    //NSImage * afbeelding = ;
    
    self.statusBar.image = [NSImage imageNamed:@"statusicon"];
    self.statusBar.alternateImage = [NSImage imageNamed:@"statusicon-inv"];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;

    
   //_updateTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (IBAction)clickedRefresh:(NSMenuItem *)sender {
    [_downSpeed setTitle:@"0 MB/S"];
    [[_statusMenu itemAtIndex:3]setTitle:@"Queue 0"];
    NSMenuItem *newMenu = [[NSMenuItem alloc] initWithTitle:@"New" action:NULL keyEquivalent:@""];
    [_queueList addItem:newMenu];
    [self timerTicked:_updateTimer];
  /*  self._jsonRPC = [[DSJSONRPC alloc] initWithServiceEndpoint:[NSURL URLWithString:sNZBGeturl]];
    
    // We're going to use a standard completion handler for our json-rpc calls
    DSJSONRPCCompletionHandler completionHandler = ^(NSString *methodName, NSInteger callId, id methodResult, DSJSONRPCError *methodError, NSError *internalError) {
        if (methodError) {
            NSLog(@"\nMethod %@(%li) returned an error: %@\n\n", methodName, (long)callId, methodError);
        }
        else if (internalError) {
            NSLog(@"\nMethod %@(%li) couldn't be sent with error: %@\n\n", methodName, (long)callId, internalError);
        }
        else {
            NSLog(@"\nMethod %@(%li) completed with result: %@\n\n", methodName, (long)callId, methodResult);
            //NSLog(@"Result %@\n",[methodResult objectForKey:@"DownloadRate"]);
            //NSLog(@"Val = %@");
        }
    };
    
    NSInteger callId;
    
    // Example of a method call with no parameters that returns a string representation of the current time
    callId = [self._jsonRPC callMethod:@"status" onCompletion:completionHandler];
    NSLog(@"\n*** now called with id: %li\n\n", (long)callId);
    
    //callId = [self._jsonRPC callMethod:@"listfiles" withParameters:@{@"IDFrom": [NSNumber numberWithInt:0],@"IDTo": [NSNumber numberWithInt:0],@"NZBID": [NSNumber numberWithInt:0]} onCompletion:completionHandler];
    NSLog(@"\n*** now called with id: %li\n\n", (long)callId);*/
    
   /* [_updateTimerLow invalidate];
    _updateTimerLow = nil;
    _updateTimerLow =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];*/
    
    //NSUserNotification *notification = [[NSUserNotification alloc] init];
    //notification.title = @"Hello, World!";
    //notification.informativeText = @"A notification";
    //notification.soundName = NSUserNotificationDefaultSoundName;
    
   // [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
}


- (IBAction)clickedPref:(NSMenuItem *)sender {
    NSLog(@"Preferences Clicked!\n");
    _settingsWindow = [[SettingsWindowController alloc] init];
    [_settingsWindow showWindow:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(preferencesWillClose:)
												 name:NSWindowWillCloseNotification
											   object:[_settingsWindow window]];
}

- (void)preferencesWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillCloseNotification
												  object:[_settingsWindow window]];
	//[_settingsWindow getNZBGeturl:_NZBGeturl];
   // NSLog(@"Retrieved URL: %@\n", _NZBGeturl);
    _settingsWindow = nil;
    NSLog(@"Preferences Closed!\n");
    [self updateVarsFromDefaults];
    [self updateTimers];
    
	//[self userDefaultsDidChange:nil];
}


-(void) updateVarsFromDefaults{
    NSLog(@"Updating local variables from defaults\n");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString * username = [defaults objectForKey:@"Username"];
    NSString * password = [defaults objectForKey:@"Password"];
    NSString * location = [defaults objectForKey:@"Location"];
    
    
    sNZBGeturl = [NSString stringWithFormat:@"http://%@:%@@%@/jsonrpc", username, password, location ];
    
    bAutoupdate =[defaults boolForKey:@"AutoUpdate"];
    iUpdateLow =[defaults integerForKey:@"UpdateLow"];
    iUpdateHigh =[defaults integerForKey:@"UpdateHigh"];
}

-(void) updateUI{
    //Simulate download
    //NZBGetStatus.ServerStandBy = NO;
    //NZBGetStatus.RemainingSizeMB = 100;
    //NZBGetStatus.DownloadRate = 6568334;
    
    if(NZBGetStatus.PostJobCount > 0)   //Were Post processing
    {
        self.statusBar.title = @"Post";
        bDownloading = YES;
    }
    else if (NZBGetStatus.ServerStandBy) {
        self.statusBar.title = @"Std-by";
        bDownloading = NO;
    }
    else if (NZBGetStatus.ServerPaused || NZBGetStatus.Download2Paused || NZBGetStatus.DownloadPaused)
    {
        self.statusBar.title = @"Pause";
        bDownloading = NO;
    }
    else if (NZBGetStatus.RemainingSizeMB >0)//Now its probably downloading
    {
        self.statusBar.title = [NSString stringWithFormat:@"%2.2f|%ld", (float)NZBGetStatus.DownloadRate/1000000, (long)NZBGetStatus.RemainingSizeMB];
         bDownloading = YES;
    }
}

-(void) updateTimers{

    if(bDownloading){
        NSLog(@"Setting updateTimer to High: %ld\n", (long)iUpdateHigh);
        [_updateTimer invalidate];
        _updateTimer = nil;
        _updateTimer =  [NSTimer scheduledTimerWithTimeInterval:iUpdateHigh target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    }
    else{
        NSLog(@"Setting updateTimer to Low: %ld\n", (long)iUpdateLow);
        [_updateTimer invalidate];
        _updateTimer = nil;
        _updateTimer =  [NSTimer scheduledTimerWithTimeInterval:iUpdateLow target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    }
    
}

@end
