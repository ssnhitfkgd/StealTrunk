//
//  DDProgressView.h
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import "AppKitCompatibility.h"
#endif

typedef enum
{
    PROGRESS_STYLE_CIRCLE = 0,
    PROGRESS_STYLE_RECT,
}PROGRESS_STYLE;

@interface DDProgressView : UIView
{
    PROGRESS_STYLE progressStyle;
@private
	float progress ;
	UIColor *innerColor ;
	UIColor *outerColor ;
    UIColor *emptyColor ;
}

@property (nonatomic,retain) UIColor *innerColor ;
@property (nonatomic,retain) UIColor *outerColor ;
@property (nonatomic,retain) UIColor *emptyColor ;
@property (nonatomic,assign) float progress ;

- (id)initWithFrame:(CGRect)frame withStyle:(PROGRESS_STYLE)_progressStyle leftImage:(NSString*)_leftImage rightImage:(NSString*)_rightImage;
@end
