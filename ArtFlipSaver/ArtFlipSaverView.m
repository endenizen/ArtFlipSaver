//
//  ArtFlipSaverView.m
//  ArtFlipSaver
//
//  Created by Brian Ferrell on 8/25/12.
//  Copyright (c) 2012 Brian Ferrell. All rights reserved.
//

#import "ArtFlipSaverView.h"

#import <WebKit/WebKit.h>

@implementation ArtFlipSaverView

static NSString* const ArtFlip = @"com.endenizen.ArtFlipSaver";

@synthesize usernameInput;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    
    
    if (self) {
        ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"endenizen", @"RdioUsername",
                                    @"", @"Rows",
                                    @"", @"Delay",
                                    nil]];
        
        webView = [[WebView alloc] initWithFrame:[self bounds] frameName:nil groupName:nil];
        [webView setMainFrameURL:[NSString stringWithFormat:@"http://artflip.herokuapp.com/"]];
        [self addSubview:webView];
    }
    
    return self;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
    
    [usernameInput setStringValue:[defaults objectForKey:@"RdioUsername"]];
    
    if (!optionsPanel) {
         [NSBundle loadNibNamed:@"Options" owner:self];
    }
    return optionsPanel;
}

- (IBAction)okSheetAction:(id)sender
{
    // set defaults
    
    // save
    [[NSApplication sharedApplication] endSheet:optionsPanel];
}

- (IBAction)cancelSheetAction:(id)sender
{
    [[NSApplication sharedApplication] endSheet:optionsPanel];
}

@end
