//
//  BFRulerView.h
//  BFRulerView
//
//  Created by Balázs Faludi on 15.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, BFRulerViewPosition) {
	BFRulerViewPositionTop,
	BFRulerViewPositionBottom,
	BFRulerViewPositionLeft,
	BFRulerViewPositionRight
};

#define BFRulerViewPositionIsHorizonal(x) ((x) == BFRulerViewPositionTop || (x) == BFRulerViewPositionBottom)
#define BFRulerViewPositionIsVertical(x) ((x) == BFRulerViewPositionLeft || (x) == BFRulerViewPositionRight)
#define BFRulerViewPositionIsLow(x) ((x) == BFRulerViewPositionBottom || (x) == BFRulerViewPositionLeft)
#define BFRulerViewPositionIsHigh(x) ((x) == BFRulerViewPositionTop || (x) == BFRulerViewPositionRight)

@interface BFRulerView : NSView

@property (nonatomic) CGFloat offset;
@property (nonatomic) CGFloat scale;
@property (nonatomic) BFRulerViewPosition position;
@property (nonatomic) BOOL allowSubpixelRendering;

@property (nonatomic) CGFloat minLabelInterval;
@property (nonatomic) CGFloat minTickInterval;

@property (nonatomic) CGFloat tickSize;		// 0.0 - 1.0
@property (nonatomic) CGFloat labelTickSize;// 0.0 - 1.0

@property (nonatomic) NSFont *labelFont;
@property (nonatomic) NSColor *fontColor;
@property (nonatomic) NSColor *tickColor;

@property (nonatomic) NSString *labelFormat;

@end
