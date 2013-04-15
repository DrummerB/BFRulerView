//
//  BFRulerView.m
//  BFRulerView
//
//  Created by Balázs Faludi on 15.04.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFRulerView.h"

@interface BFRulerView ()

@end

@implementation BFRulerView

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_offset = 0.0f;
		_scale = 1.0f;
		_minLabelInterval = 35.0f;
		_minTickInterval = 3.0f;
		_tickSize = 0.2f;
		_labelTickSize = 1.0f;
		_fontColor = [NSColor blackColor];
		_tickColor = [NSColor blackColor];
		_allowSubpixelRendering = NO;
    }
    return self;
}

- (void)viewDidMoveToSuperview {
	[self guessPosition];
}

#pragma mark -
#pragma mark Auxiliary methods

- (void)guessPosition {
	if (self.frame.size.width > self.frame.size.height) {
		if (self.frame.origin.y + self.frame.size.height / 2.0f > self.superview.bounds.size.height / 2.0f) {
			self.position = BFRulerViewPositionTop;
		} else {
			self.position = BFRulerViewPositionBottom;
		}
	} else {
		if (self.frame.origin.x + self.frame.size.width / 2.0f > self.superview.bounds.size.width / 2.0f) {
			self.position = BFRulerViewPositionRight;
		} else {
			self.position = BFRulerViewPositionLeft;
		}
	}
}

- (void)updateAutoresizingMask {
	switch (_position) {
		case BFRulerViewPositionTop:
			self.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin;
			break;
		case BFRulerViewPositionBottom:
			self.autoresizingMask = NSViewWidthSizable;
			break;
		case BFRulerViewPositionLeft:
			self.autoresizingMask = NSViewHeightSizable;
			break;
		case BFRulerViewPositionRight:
			self.autoresizingMask = NSViewHeightSizable | NSViewMinXMargin;
		default:
			break;
	}
}

- (CGFloat)length {
	return BFRulerViewPositionIsHorizonal(_position) ? self.bounds.size.width : self.bounds.size.height;
}

- (CGFloat)width {
	return BFRulerViewPositionIsHorizonal(_position) ? self.bounds.size.height : self.bounds.size.width;
}

#pragma mark -
#pragma mark Getters & Setters

- (void)setMinLabelInterval:(CGFloat)minLabelInterval {
	if (_minLabelInterval != minLabelInterval) {
		_minLabelInterval = minLabelInterval;
		[self setNeedsDisplay:YES];
	}
}

- (void)setMinTickInterval:(CGFloat)minTickInterval {
	if (_minTickInterval != minTickInterval) {
		_minTickInterval = minTickInterval;
		[self setNeedsDisplay:YES];
	}
}

- (void)setFontColor:(NSColor *)fontColor {
	if (_fontColor != fontColor) {
		_fontColor = fontColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setTickColor:(NSColor *)tickColor {
	if (_tickColor != tickColor) {
		_tickColor = tickColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setLabelFont:(NSFont *)labelFont {
	if (_labelFont != labelFont) {
		_labelFont = labelFont;
		[self setNeedsDisplay:YES];
	}
}

- (void)setTickSize:(CGFloat)tickSize {
	if (_tickSize != tickSize ) {
		_tickSize = tickSize;
		[self setNeedsDisplay:YES];
	}
}

- (void)setLabelTickSize:(CGFloat)labelTickSize {
	if (_labelTickSize != labelTickSize) {
		_labelTickSize = labelTickSize;
		[self setNeedsDisplay:YES];
	}
}

- (void)setOffset:(CGFloat)offset {
	if (_offset != offset) {
		_offset = offset;
		[self setNeedsDisplay:YES];
	}
}

- (void)setScale:(CGFloat)scale {
	if (_scale != scale) {
		_scale = scale;
		[self setNeedsDisplay:YES];
	}
}

- (void)setAllowSubpixelRendering:(BOOL)allowSubpixelRendering {
	if (_allowSubpixelRendering != allowSubpixelRendering) {
		_allowSubpixelRendering = allowSubpixelRendering;
		[self setNeedsDisplay:YES];
	}
}

- (void)setPosition:(BFRulerViewPosition)position {
	_position = position;
	[self updateAutoresizingMask];
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
	
	CGContextRef c = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	[_tickColor setStroke];
	
	[[NSColor whiteColor] setFill];
	NSRectFill(dirtyRect);
	
	CGFloat unitLength = _scale;	// scaled size of a pixel
	CGFloat labelInterval = 1;		// label tick interval (in units, not pixels)

	// Calculate the minimum distance between tick labels that is bigger
	// than a given minimum and a 10 multiple of 1, 2 or 5.
	int nMult = 3;
	CGFloat mult[3] = {2, 2.5, 2};
	int m = 0;
	while (labelInterval * unitLength < MAX(_minLabelInterval, 1.0f)) {
		labelInterval *= mult[m];
		m = (m+1)%nMult;
	}
	
	CGFloat tickLabelInterval = labelInterval * unitLength;		// distance between two tick labels in pixels.
	tickLabelInterval = MAX(MAX(_minTickInterval, 1.0f), tickLabelInterval);
	
	// Calculate the maximum number of ticks between labels, so that the tick interval
	// is still bigger than a given minimum and the number is a 10 multiple of 1, 2, or 5.
	m = 0;
	int ticksPerLabelInterval = 1;
	while (tickLabelInterval / ticksPerLabelInterval > MAX(_minTickInterval, 1.0f)) {
		ticksPerLabelInterval *= mult[m];
		m = (m+1)%nMult;
	}
	m = (m+nMult-1)%nMult;
	ticksPerLabelInterval /= mult[m];
	ticksPerLabelInterval = MAX(ticksPerLabelInterval, 1);
	
	CGFloat tickInterval = tickLabelInterval / ticksPerLabelInterval;

	CGFloat firstTickOffset = fmodf(_offset, tickInterval);
	CGFloat firstLabelTickOffset = fmodf(_offset, tickLabelInterval);
	if (firstTickOffset < 0.0f) firstTickOffset += tickInterval;
	if (firstLabelTickOffset < 0.0f) firstLabelTickOffset += tickLabelInterval;
	
	int subTickIndex = (firstLabelTickOffset - firstTickOffset) / tickInterval;
	
	CGFloat currentOffset = firstTickOffset;
	
	CGFloat length = [self length];	// the longer size
	CGFloat width = [self width];	// the shorter size
	
	CGFloat x, y;
	CGFloat *xp = BFRulerViewPositionIsHorizonal(_position) ? &x : &y;
	CGFloat *yp = BFRulerViewPositionIsHorizonal(_position) ? &y : &x;
	while (currentOffset < length) {
		x = (_allowSubpixelRendering ? currentOffset : roundf(currentOffset)) + 0.5;
		y = BFRulerViewPositionIsHigh(_position) ? 0.0f : width;
		CGContextMoveToPoint(c, *xp, *yp);
		
		BOOL isLabelTick = subTickIndex == 0;
		CGFloat tickSize = isLabelTick ? _labelTickSize : _tickSize;
		tickSize *= width;
		y = BFRulerViewPositionIsHigh(_position) ? tickSize : width - tickSize;
		CGContextAddLineToPoint(c, *xp, *yp);
	
		CGContextStrokePath(c);
		subTickIndex = (subTickIndex + 1) % ticksPerLabelInterval;
		currentOffset += tickInterval;
	}
}

@end
