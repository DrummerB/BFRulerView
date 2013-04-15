//
//  AppDelegate.h
//  Demo
//
//  Created by Balázs Faludi on 15.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BFRulerView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet BFRulerView *rulerTop;
@property (weak) IBOutlet BFRulerView *rulerBottom;
@property (weak) IBOutlet BFRulerView *rulerLeft;
@property (weak) IBOutlet BFRulerView *rulerRight;
@property (nonatomic) NSArray *rulers;

- (IBAction)changedOffset:(id)sender;
- (IBAction)changedScale:(id)sender;
- (IBAction)changedMinLabelInterval:(id)sender;
- (IBAction)changedMinTickInterval:(id)sender;
- (IBAction)changedLabelTickSize:(id)sender;
- (IBAction)changedTickSize:(id)sender;
- (IBAction)changedTickColor:(id)sender;
- (IBAction)changedLabelColor:(id)sender;
- (IBAction)changedSubpixelRendering:(id)sender;

@end
