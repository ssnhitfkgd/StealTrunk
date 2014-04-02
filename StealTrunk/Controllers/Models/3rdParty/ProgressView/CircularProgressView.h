//
//  CircularProgressView.h
//  CircularProgressView
//
//  Created by nijino saki on 13-3-2.
//  Copyright (c) 2013年 nijino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CircularProgressDelegate;

@interface CircularProgressView : UIView

@property (strong, nonatomic) AVAudioPlayer *player;//an AVAudioPlayer instance
@property (assign, nonatomic) id <CircularProgressDelegate> delegate;
@property (assign, nonatomic) float progress;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
          audioPath:(NSString *)path;
- (void)play;
- (void)pause;
- (void)revert;
- (void)updateProgressCircle:(CGFloat)progress;
- (void)initProgressWithFrame:(CGRect)frame
                  backColor:(UIColor *)backColor
              progressColor:(UIColor *)progressColor
                  lineWidth:(CGFloat)lineWidth
                  audioPath:(NSString *)path;

@end

@protocol CircularProgressDelegate <NSObject>

- (void)didUpdateProgressView;

@end