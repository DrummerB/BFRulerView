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
		_labelFont = [NSFont fontWithName:@"LucidaGrande" size:9.0];
		_fontColor = [NSColor blackColor];
		_tickColor = [NSColor blackColor];
		_allowSubpixelRendering = NO;
		_labelFormat = @"%.0f";
		_backgroundColor = [NSColor whiteColor];
		_contentBorderColor = [NSColor blackColor];
		_outsideBorderColor = nil;
		_startBorderColor = [NSColor blackColor];
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

- (void)setLabelFormat:(NSString *)labelFormat {
	if (_labelFormat != labelFormat) {
		_labelFormat = labelFormat;
		[self setNeedsDisplay:YES];
	}
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	if (_backgroundColor != backgroundColor) {
		_backgroundColor = backgroundColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setBackgroundGradient:(NSGradient *)backgroundGradient {
	if (_backgroundGradient != backgroundGradient) {
		_backgroundGradient = backgroundGradient;
		[self setNeedsDisplay:YES];
	}
}

- (void)setContentBorderColor:(NSColor *)borderColor {
	if (_contentBorderColor != borderColor) {
		_contentBorderColor = borderColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setOutsideBorderColor:(NSColor *)outsideBorderColor {
	if (_outsideBorderColor != outsideBorderColor) {
		_outsideBorderColor = outsideBorderColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setPosition:(BFRulerViewPosition)position {
	_position = position;
	[self updateAutoresizingMask];
	[self setNeedsDisplay:YES];
}

- (void)setStartBorderColor:(NSColor *)shortBorderColor {
	if (_startBorderColor != shortBorderColor) {
		_startBorderColor = shortBorderColor;
		[self setNeedsDisplay:YES];
	}
}

- (void)setEndBorderColor:(NSColor *)endBorderColor {
	if (_endBorderColor != endBorderColor) {
		_endBorderColor = endBorderColor;
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect {
	
	CGContextRef c = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	CGFloat length = [self length];	// the longer size
	CGFloat width = [self width];	// the shorter size

	CGFloat x, y;
	CGFloat *xp = BFRulerViewPositionIsHorizonal(_position) ? &x : &y;
	CGFloat *yp = BFRulerViewPositionIsHorizonal(_position) ? &y : &x;
	
	// Draw background color, or if a gradient is set, the gradient.
	if (_backgroundGradient) {
		if (BFRulerViewPositionIsHorizonal(_position)) {
			[_backgroundGradient drawFromPoint:NSMakePoint(0.0f, width) toPoint:NSMakePoint(0.0f, 0.0f) options:0];
		} else {
			[_backgroundGradient drawFromPoint:NSMakePoint(0.0f, 0.0f) toPoint:NSMakePoint(width, 0.0f) options:0];
		}
	} else {
		[_backgroundColor setFill];
		NSRectFill(dirtyRect);
	}
	
	// Stroke short border line.
	if (_startBorderColor) {
		[_startBorderColor setStroke];
		x = 0.5f;
		y = 0.5f;
		CGContextMoveToPoint(c, *xp, *yp);
		y = width - 0.5f;
		CGContextAddLineToPoint(c, *xp, *yp);
		CGContextStrokePath(c);
	}
	if (_endBorderColor) {
		[_endBorderColor setStroke];
		x = length - 0.5f;
		y = 0.5f;
		CGContextMoveToPoint(c, *xp, *yp);
		y = width - 0.5f;
		CGContextAddLineToPoint(c, *xp, *yp);
		CGContextStrokePath(c);
	}
	
	
	CGFloat pixelOffset = _offset * _scale;
	CGFloat valueOffset = _offset;
	
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

	CGFloat firstTickOffset = fmodf(pixelOffset, tickInterval);
	CGFloat firstLabelTickOffset = fmodf(pixelOffset, tickLabelInterval);
	if (firstTickOffset < 0.0f) firstTickOffset += tickInterval;
	if (firstLabelTickOffset < 0.0f) firstLabelTickOffset += tickLabelInterval;
	if (firstTickOffset > 0) firstTickOffset = tickInterval - firstTickOffset;
	if (firstLabelTickOffset > 0) firstLabelTickOffset = tickLabelInterval - firstLabelTickOffset;
	
	int subTickIndex = (int)ceilf(fmodf(pixelOffset, tickLabelInterval) / tickInterval) % ticksPerLabelInterval;
	
	CGFloat labelValue = ceilf(valueOffset / labelInterval) * labelInterval;
	
	CGFloat currentOffset = firstTickOffset;
	
	// Draw the ticks, and labels.
	
	while (currentOffset < length) {
		x = (_allowSubpixelRendering ? currentOffset : roundf(currentOffset)) + 0.5;
		y = BFRulerViewPositionIsHigh(_position) ? 0.0f : width;
		CGContextMoveToPoint(c, *xp, *yp);
		
		BOOL isLabelTick = subTickIndex == 0;
		CGFloat tickSize = isLabelTick ? _labelTickSize : _tickSize;
		tickSize *= width;
		y = BFRulerViewPositionIsHigh(_position) ? tickSize : width - tickSize;
		CGContextAddLineToPoint(c, *xp, *yp);
	
		[_tickColor setStroke];
		CGContextStrokePath(c);
		
		subTickIndex = (subTickIndex + 1) % ticksPerLabelInterval;
		currentOffset += tickInterval;
		
		if (isLabelTick) {
			NSString *labelString = [NSString stringWithFormat:_labelFormat, labelValue + 0];
			NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
			style.maximumLineHeight = 10.0f;
			NSDictionary *attributes = @{NSFontAttributeName : _labelFont,
										 NSForegroundColorAttributeName : _fontColor,
										 NSParagraphStyleAttributeName : style};
			if (BFRulerViewPositionIsHorizonal(_position)) {
				NSSize size = [labelString sizeWithAttributes:attributes];
				x += 2;
				y = BFRulerViewPositionIsHigh(_position) ? _tickSize * width : width - _tickSize * width - size.height;
				y = roundf(y);
				[labelString drawAtPoint:NSMakePoint(*xp, *yp) withAttributes:attributes];
			} else {
				NSSize charSize = [@"W" sizeWithAttributes:attributes];
				x = BFRulerViewPositionIsHigh(_position) ? _tickSize * width + 2.0f : width - _tickSize * width - charSize.width;
				x = roundf(x);
				y = roundf(currentOffset) - 2.5f;
				NSRect rect = NSMakeRect(x, y, 1, 0);
				[labelString drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
			}
			labelValue += labelInterval;
		}
	}
	
	// Stroke content border line.
	if (_contentBorderColor) {
		[_contentBorderColor setStroke];
		x = 0.5f;
		y = BFRulerViewPositionIsHigh(_position) ? 0.5f : width - 0.5f;
		CGContextMoveToPoint(c, *xp, *yp);
		x = length - 0.5f;
		CGContextAddLineToPoint(c, *xp, *yp);
		CGContextStrokePath(c);
	}
	
	// Stroke outside border line.
	if (_outsideBorderColor) {
		[_outsideBorderColor setStroke];
		x = 0.5f;
		y = 0.5f;
		CGContextMoveToPoint(c, *xp, *yp);
		x = length - 0.5f;
		CGContextAddLineToPoint(c, *xp, *yp);
		CGContextStrokePath(c);
	}
}

@end
