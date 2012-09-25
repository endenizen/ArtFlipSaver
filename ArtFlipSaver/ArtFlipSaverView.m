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

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];

    if (self) {
        ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"", @"RdioUsername",
                                    @"top", @"Source",
                                    @"3", @"Rows",
                                    @"3", @"Delay",
                                    nil]];
    
        webView = [[WebView alloc] initWithFrame:[self bounds] frameName:nil groupName:nil];
        [self addSubview:webView];
        [self setWebViewUrl];
    }
    
    return self;
}

- (NSArray*)sourceArray
{
    return [NSArray arrayWithObjects:@"top", @"collection", @"heavyrotation", @"friendsheavyrotation", nil];
}

- (NSDictionary*)sourceDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
               @"Top Albums", @"top",
               @"Collection", @"collection",
               @"Heavy Rotation", @"heavyrotation",
               @"Friends Heavy Rotation", @"friendsheavyrotation",
               nil];
}

- (void)setWebViewUrl
{
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
    
    NSString *url = @"http://artflip.herokuapp.com/#user=%@;type=%@;rows=%f;delay=%f";
    
    [webView setMainFrameURL:[NSString stringWithFormat:url,
                              [defaults stringForKey:@"RdioUsername"],
                              [defaults stringForKey:@"Source"],
                              [defaults doubleForKey:@"Rows"],
                              [defaults doubleForKey:@"Delay"]]];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
    
    if (!optionsPanel) {
         [NSBundle loadNibNamed:@"Options" owner:self];
    }
    
    NSDictionary *sources = [self sourceDict];
    NSArray *sourceKeys = [self sourceArray];
    for (NSString *key in sourceKeys)
    {
        [sourceSelector addItemWithTitle:[sources valueForKey:key]];
    }
    [sourceSelector selectItemWithTitle:[sources valueForKey:[defaults stringForKey:@"Source"]]];

    [usernameInput setStringValue:[defaults stringForKey:@"RdioUsername"]];
    
    [rowSlider setDoubleValue:[defaults doubleForKey:@"Rows"]];
    [rowLabel setDoubleValue:[defaults doubleForKey:@"Rows"]];
    [delaySlider setDoubleValue:[defaults doubleForKey:@"Delay"]];
    [delayLabel setDoubleValue:[defaults doubleForKey:@"Delay"]];
    
    [self setUsernameEnabled];
    
    return optionsPanel;
}

- (void)setUsernameEnabled
{
    NSDictionary *sources = [self sourceDict];
    
    NSString *top = [sources objectForKey:@"top"];
    if ([[sourceSelector titleOfSelectedItem] isEqualToString:top])
    {
        [usernameInput setEnabled:FALSE];
    }
    else
    {
        [usernameInput setEnabled:TRUE];
    }
}

- (IBAction)switchSource:(id)sender
{
    [self setUsernameEnabled];
}

- (IBAction)okSheetAction:(id)sender
{
    // set defaults
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:ArtFlip];
    NSDictionary *sources = [self sourceDict];
    
    [defaults setObject:[usernameInput stringValue] forKey:@"RdioUsername"];
    
    [defaults setObject:[sources allKeysForObject:[sourceSelector titleOfSelectedItem]][0] forKey:@"Source"];
    [defaults setDouble:[rowSlider doubleValue] forKey:@"Rows"];
    [defaults setDouble:[delaySlider doubleValue] forKey:@"Delay"];
    
    // save to disk
    [defaults synchronize];
    
    // refresh preview
    [self setWebViewUrl];
    
    [[NSApplication sharedApplication] endSheet:optionsPanel];
}

- (IBAction)cancelSheetAction:(id)sender
{
    [[NSApplication sharedApplication] endSheet:optionsPanel];
}

@end
