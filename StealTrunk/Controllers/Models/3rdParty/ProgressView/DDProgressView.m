//
//  DDProgressView.m
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import "DDProgressView.h"

#define kProgressBarHeight  14.f
#define kProgressBarWidth	160.0f
#define kViewHeight 22.f

@implementation DDProgressView

@synthesize innerColor ;
@synthesize outerColor ;
@synthesize emptyColor ;
@synthesize progress ;

- (id)init
{
	return [self initWithFrame: CGRectZero] ;
}

- (id)initWithFrame:(CGRect)frame withStyle:(PROGRESS_STYLE)_progressStyle leftImage:(NSString*)_leftImage rightImage:(NSString*)_rightImage
{
	self = [super initWithFrame: frame] ;
	if (self)
	{
        progressStyle = _progressStyle;
		self.backgroundColor = [UIColor clearColor] ;
		self.innerColor = [UIColor lightGrayColor] ;
		self.outerColor = [UIColor lightGrayColor] ;
		self.emptyColor = [UIColor clearColor] ;
		//if (frame.size.width == 0.0f)
			
        frame.size.width = 36;//kProgressBarWidth ;
        if(_leftImage)
        {
            UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_leftImage]];
            [leftImageView setFrame:CGRectMake(-11, (kProgressBarHeight- kViewHeight)/2, 22, 22)];
            [self addSubview:leftImageView];
        }
        
        if(_rightImage)
        {
            UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_rightImage]];
            [rightImageView setFrame:CGRectMake(self.width - 11, (kProgressBarHeight- kViewHeight)/2, 22, 22)];
            [self addSubview:rightImageView];
        }
	}
	return self ;
}

- (void)setProgress:(float)theProgress
{
	// make sure the user does not try to set the progress outside of the bounds
	if (theProgress > 1.0f)
		theProgress = 1.0f ;
	if (theProgress < 0.0f)
		theProgress = 0.0f ;
	
	progress = theProgress ;
	[self setNeedsDisplay] ;
}

- (void)setFrame:(CGRect)frame
{
	// we set the height ourselves since it is fixed
	frame.size.height = kProgressBarHeight ;
	[super setFrame: frame] ;
}

- (void)setBounds:(CGRect)bounds
{
	// we set the height ourselves since it is fixed
	bounds.size.height = kProgressBarHeight ;
	[super setBounds: bounds] ;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext() ;
	
	// save the context
	CGContextSaveGState(context) ;
	
	// allow antialiasing
	CGContextSetAllowsAntialiasing(context, TRUE) ;
	
	// we first draw the outter rounded rectangle
	rect = CGRectInset(rect, 1.0f, 1.0f) ;
    CGFloat radius = 0.0;
    if(progressStyle == PROGRESS_STYLE_CIRCLE)
    {
        radius = 0.5f * rect.size.height ;
    }	 
    
	[outerColor setStroke] ;
	CGContextSetLineWidth(context, 2.0f) ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextDrawPath(context, kCGPathStroke) ;
    
    // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
    rect = CGRectInset(rect, 1.6f, 1.6f) ;
    if(progressStyle == PROGRESS_STYLE_CIRCLE)
    {
        radius = 0.5f * rect.size.height ;
    }

	
	[emptyColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
	// draw the inside moving filled rounded rectangle
    if(progressStyle == PROGRESS_STYLE_CIRCLE)
    {
        radius = 0.5f * rect.size.height ;
    }
	
	// make sure the filled rounded rectangle is not smaller than 2 times the radius
	rect.size.width *= progress ;
	if (rect.size.width < 2 * radius)
		rect.size.width = 2 * radius ;
	
	[innerColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
	
	CGContextBeginPath(context) ;
    CGContextSetRGBFillColor (context,  1, 1, 1, 1.0);
    UIFont  *font = [UIFont boldSystemFontOfSize:11.0];
    //[[NSString stringWithFormat:@"%.1f％",progress*100] drawInRect:CGRectMake(rect.size.width/2, CGRectGetMinY(rect), 80, 20) withFont:font];
    CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
	// restore the context
	CGContextRestoreGState(context) ;
}

@end
