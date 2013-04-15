//
//  AppDelegate.m
//  Demo
//
//  Created by Balázs Faludi on 15.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "AppDelegate.h"
#import "BFRulerView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.rulers = @[_rulerTop, _rulerBottom, _rulerLeft, _rulerRight];
}

- (IBAction)changedOffset:(id)sender {
	for (BFRulerView *r in _rulers) r.offset = [sender floatValue];
}

- (IBAction)changedScale:(id)sender {
	for (BFRulerView *r in _rulers) r.scale = [sender floatValue];
}

- (IBAction)changedMinLabelInterval:(id)sender {
	for (BFRulerView *r in _rulers) r.minLabelInterval = [sender floatValue];
}

- (IBAction)changedMinTickInterval:(id)sender {
	for (BFRulerView *r in _rulers) r.minTickInterval = [sender floatValue];
}

- (IBAction)changedLabelTickSize:(id)sender {
	for (BFRulerView *r in _rulers) r.labelTickSize = [sender floatValue];
}

- (IBAction)changedTickSize:(id)sender {
	for (BFRulerView *r in _rulers) r.tickSize = [sender floatValue];
}

- (IBAction)changedTickColor:(id)sender {
	for (BFRulerView *r in _rulers) r.tickColor = [sender color];
}

- (IBAction)changedLabelColor:(id)sender {
	for (BFRulerView *r in _rulers) r.fontColor = [sender color];
}

- (IBAction)changedSubpixelRendering:(id)sender {
	for (BFRulerView *r in _rulers) r.allowSubpixelRendering = [sender state] == NSOnState;
}
@end
