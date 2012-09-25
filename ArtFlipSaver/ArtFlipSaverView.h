//
//  ArtFlipSaverView.h
//  ArtFlipSaver
//
//  Created by Brian Ferrell on 8/25/12.
//  Copyright (c) 2012 Brian Ferrell. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

#import <WebKit/WebKit.h>


@interface ArtFlipSaverView : ScreenSaverView
{
    WebView *webView;
    IBOutlet NSWindow *optionsPanel;
    IBOutlet id usernameInput;
    IBOutlet id sourceSelector;
    IBOutlet id rowSlider;
    IBOutlet id rowLabel;
    IBOutlet id delaySlider;
    IBOutlet id delayLabel;
}

- (IBAction) cancelSheetAction: (id)sender;
- (IBAction) okSheetAction: (id)sender;
- (IBAction) switchSource: (id)sender;

@end